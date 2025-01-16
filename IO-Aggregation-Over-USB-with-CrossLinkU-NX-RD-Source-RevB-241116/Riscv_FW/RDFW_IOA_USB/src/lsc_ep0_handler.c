/****************************************************************************/
/**
 *
 * @file lsc_ep0_handler.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"

//#define DEBUG_LSC_EP0_HANDLER

#ifdef DEBUG_LSC_EP0_HANDLER
#define LSC_EP0_HANDLER(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_EP0_HANDLER(msg, ...)
#define LSC_EP0_HANDLER_t(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#endif

uint8_t ctrl_data_buf[512]__attribute__((aligned(32))) ;
/****************************************************************************/
/**
 * This function prepares TRB to receive setup packet from HOST.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *
 * @note     Setup packet is always on EP0 OUT.<br>
 ****************************************************************************/
uint8_t lsc_usb_rcv_setup (struct lsc_usb_dev *usb_dev)
{
    LSC_EP0_HANDLER("lsc_usb_rcv_setup\r\n");

    struct lsc_ep_params *params;
    struct lsc_trb *trb;
    struct lsc_ep *ep;
    uint8_t ret;

    params = lsc_usb_get_ep_params(usb_dev);

    /* Setup packet always on EP0 */
    ep = &usb_dev->eps[0];
    if ((ep->ep_status & LSC_EP_BUSY) != 0) {
        return LSC_FAIL;
    }

    trb = &usb_dev->ep0_trb;

    trb->buf_ptr_lo = (uintptr_t)&usb_dev->setup_data;
    trb->buf_ptr_hi = ((uintptr_t)&usb_dev->setup_data >> 16) >> 16;

    trb->size = 8;
    trb->ctrl = LSC_TRBCTL_CONTROL_SETUP;

    // As we have set LST and IOC flags, no need to set IS_IMI flag here. IS_IMI is useful if LST is not set for this TRB.
    // Bit:10 - Interrupt on Short Packet / Interrupt on Missed ISOC (ISP/IMI)
    trb->ctrl |= (LSC_TRB_CTRL_HWO | LSC_TRB_CTRL_LST | LSC_TRB_CTRL_IOC
           /* | LSC_TRB_CTRL_ISP_IMI*/);

//  LSC_EP0_HANDLER("trb->size: %x\ttrb->ctrl: %x\r\n", trb->size, trb->ctrl);

    params->param0 = 0;
    params->param1 = (uintptr_t)trb;
    usb_dev->ep0_state = LSC_EP0_SETUP_PHASE;

    ret = lsc_usb_send_ep_cmd(usb_dev, 0, LSC_EP_DIR_OUT,
            LSC_DEPCMD_STARTTRANSFER, params);
    if (ret != LSC_SUCCESS) {
        return LSC_FAIL;
    }

    ep->ep_status |= LSC_EP_BUSY;
    ep->resource_index = lsc_usb_ep_get_xfer_index(usb_dev, ep->usb_ep_num,
            ep->ep_direction);

    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * Handles Transfer complete event of Control Endpoints EP0 OUT and EP0 IN.
 * This function is called when controller generates transfer complete event
 * on control endpoint.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    ep_evt is a pointer to the Endpoint event occurred in core.
 *
 *****************************************************************************/
void lsc_usb_ep0_xfer_cmplt (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt)
{
    LSC_EP0_HANDLER(" * lsc_usb_ep0_xfer_cmpt\r\n");

    struct lsc_ep *ep;

    setup_pkt *sp;
    uint16_t length;

    ep = &usb_dev->eps[ep_evt->ep_number];
    sp = &usb_dev->setup_data;

    ep->ep_status &= ~LSC_EP_BUSY;
    ep->resource_index = 0;

    LSC_EP0_HANDLER("   ep0_xfer_cmpt: ep0_state: %x\r\n", usb_dev->ep0_state);

    switch (usb_dev->ep0_state) {
        case LSC_EP0_SETUP_PHASE:
          LSC_EP0_HANDLER_t("    EP0_SETUP_PHASE\r\n");

            length = sp->wLength;

            if (length == 0) {
              LSC_EP0_HANDLER_t(" 2-stage control req\r\n");

                usb_dev->is_three_stage = 0;
                usb_dev->control_dir = LSC_EP_DIR_OUT;
            } else {
              LSC_EP0_HANDLER_t(" 3-stage control req\r\n");

                usb_dev->is_three_stage = 1;
                usb_dev->control_dir = !!(sp->bRequestType & LSC_USB_DIR_IN);
            }

            lsc_usb_setup_pkt_process(usb_dev, &usb_dev->setup_data);
            break;

        case LSC_EP0_DATA_PHASE:
          LSC_EP0_HANDLER_t(" EP0_DATA_PHASE\r\n");

            lsc_usb_ep0_data_xfer_cmplt(usb_dev, ep_evt);
            break;

        case LSC_EP0_STATUS_PHASE:
          LSC_EP0_HANDLER_t(" EP0_STATUS_PHASE\r\n");
            lsc_usb_ep0_status_cmplt(usb_dev);
            break;

        default:
//            LSC_EP0_HANDLER("Invalid Ep0(Setup Pkt) State.!!\r\n");
            break;
    }

}

/****************************************************************************/
/**
 * Handles Transfer Not Ready event of Control Endpoints EP0 OUT and EP0 IN.
 * This function is called when controller generates transfer not ready event
 * on control endpoint.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    ep_evt is a pointer to the Endpoint event occurred in core.
 *
 *****************************************************************************/
void lsc_usb_ep0_xfer_not_ready (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt)
{
    LSC_EP0_HANDLER("lsc_usb_ep0_xfer_not_ready\r\n");

    struct lsc_ep *ep;

    ep = &usb_dev->eps[ep_evt->ep_number];

//  LSC_EP0_HANDLER("ep0_xfer_not_ready: ep_evt->status: %x\r\n", ep_evt->status);

    switch (ep_evt->status) {
        case DEPEVT_STATUS_CONTROL_DATA:
          LSC_EP0_HANDLER("STATUS_CONTROL_DATA\r\n");
//          LSC_EP0_HANDLER("ep_evt->ep_number: %x \t usb_dev->control_dir: %x\r\n", ep_evt->ep_number, usb_dev->control_dir);
            /*
             * We already have initialted DATA transfer,
             * if we receive a XferNotReady(DATA) we will ignore it, unless
             * it's for the wrong direction.
             *
             * In that case, we must issue END_TRANSFER command to the Data
             * Phase we already have started and issue SetStall on the
             * control endpoint.
             */
            if (ep_evt->ep_number != usb_dev->control_dir) {
                lsc_usb_end_ep0_ctl_data_xfer(usb_dev, ep);
                lsc_usb_ep0_stall_restart(usb_dev);
            }
            break;

        case DEPEVT_STATUS_CONTROL_STATUS:
          LSC_EP0_HANDLER("STATUS_CONTROL_STATUS\r\n");

            lsc_usb_start_ep0_stat(usb_dev, ep_evt);

            break;

        default:
//            LSC_EP0_HANDLER("Invalid ep0_xfer_not_ready Status.!!\r\n");
            break;
    }
}

/****************************************************************************/
/**
 * This function prepares TRB to send data to Host.
 * This function is called when there is a data stage in control transfer
 * (i.e Three-Stage Control IN Transfer).
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    buf is pointer to data.
 * @param    buf_len is Length of data buffer.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *****************************************************************************/
uint8_t lsc_usb_ep0_send (struct lsc_usb_dev *usb_dev, uint8_t *buf,
        uint32_t buf_len)
{
    LSC_EP0_HANDLER_t("lsc_usb_ep0_send\r\n");
    //printf("lsc_usb_ep0_send\r\n");

    for(uint32_t i = 0; i < buf_len; i++){
    	LSC_EP0_HANDLER_t(" %x ", buf[i]);
    }

    LSC_EP0_HANDLER("\r\n");

    /* Control IN - EP1 */
    struct lsc_ep_params *params;
    struct lsc_ep *ep;
    struct lsc_trb *trb;
    uint8_t ret;

    ep = &usb_dev->eps[1];
    params = lsc_usb_get_ep_params(usb_dev);

    if ((ep->ep_status & LSC_EP_BUSY) != 0) {
        return LSC_FAIL;
    }

    ep->requested_bytes = buf_len;
    ep->bytes_txfered = 0;
    ep->buffer_ptr = buf;


    // Copy to common buffer
    memcpy(ctrl_data_buf,buf,buf_len);

    trb = &usb_dev->ep0_trb;

    trb->buf_ptr_lo = (uintptr_t)( ctrl_data_buf );//buf;
    trb->buf_ptr_hi = ((uintptr_t)( ctrl_data_buf)/*buf*/ >> 16) >> 16;

    trb->size = buf_len;
    trb->ctrl = LSC_TRBCTL_CONTROL_DATA;

    trb->ctrl |= (LSC_TRB_CTRL_HWO | LSC_TRB_CTRL_LST | LSC_TRB_CTRL_IOC
            /*| LSC_TRB_CTRL_ISP_IMI*/);

//  LSC_EP0_HANDLER("trb->size: %x\ttrb->ctrl: %x\r\n", trb->size, trb->ctrl);

    params->param0 = 0;
    params->param1 = (uintptr_t)trb;


    usb_dev->ep0_state = LSC_EP0_DATA_PHASE;

    ret = lsc_usb_send_ep_cmd(usb_dev, 0, LSC_EP_DIR_IN,
            LSC_DEPCMD_STARTTRANSFER, params);
    if (ret != LSC_SUCCESS) {
        return LSC_FAIL;
    }

    ep->ep_status |= LSC_EP_BUSY;
    ep->resource_index = lsc_usb_ep_get_xfer_index(usb_dev, ep->usb_ep_num,
            ep->ep_direction);

    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * This function prepares TRB to receive data from Host.
 * This function is called when there is a data stage in control transfer
 * (i.e Three-Stage Control OUT Transfer).
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    buf is pointer to data.
 * @param    buf_len is Length of data to be received.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *
 * @note     Data is always received on Control OUT - EP0 endpoint.<br>
 *****************************************************************************/
uint8_t lsc_usb_ep0_rcv (struct lsc_usb_dev *usb_dev, uint8_t *buf,
        uint32_t buf_len)
{
    LSC_EP0_HANDLER("lsc_usb_ep0_rcv\r\n");

    struct lsc_ep_params *params;
    struct lsc_ep *ep;
    struct lsc_trb *trb;
    uint8_t ret;
    uint32_t size;

    /* Control OUT - EP0 */
    ep = &usb_dev->eps[0];
    params = lsc_usb_get_ep_params(usb_dev);
    //printf(" Param0 = 0x%x \r\n", usb_dev->ep_params.param0);
    //printf(" Param1 = 0x%x \r\n", usb_dev->ep_params.param1);
    //printf(" Param2 = 0x%x \r\n", usb_dev->ep_params.param2);

    if ((ep->ep_status & LSC_EP_BUSY) != 0) {
        return LSC_FAIL;
    }

    ep->requested_bytes = buf_len;
    //printf(" ep requested bytes = 0x%x \r\n", ep->requested_bytes);
    size = buf_len;
    ep->bytes_txfered = 0;
    ep->buffer_ptr = buf;

    trb = &usb_dev->ep0_trb;

    trb->buf_ptr_lo  = (uintptr_t)( buf );
    trb->buf_ptr_hi = ((uintptr_t)( buf ) >> 16) >> 16;

    trb->size = ep->max_ep_size;
    trb->ctrl = LSC_TRBCTL_CONTROL_DATA;

    trb->ctrl |= (LSC_TRB_CTRL_HWO | LSC_TRB_CTRL_LST | LSC_TRB_CTRL_IOC
           /* | LSC_TRB_CTRL_ISP_IMI*/);

  LSC_EP0_HANDLER("trb->size: %x\ttrb->ctrl: %x\r\n", trb->size, trb->ctrl);

    params->param0 = 0;
    params->param1 = (uintptr_t)trb;
    usb_dev->ep0_state = LSC_EP0_DATA_PHASE;

    ret = lsc_usb_send_ep_cmd(usb_dev, 0, LSC_EP_DIR_OUT,
            LSC_DEPCMD_STARTTRANSFER, params);
    if (ret != LSC_SUCCESS) {
        return LSC_FAIL;
    }

    ep->ep_status |= LSC_EP_BUSY;
    ep->resource_index = lsc_usb_ep_get_xfer_index(usb_dev, ep->usb_ep_num,
            ep->ep_direction);

    return LSC_SUCCESS;
}

/** @} */
