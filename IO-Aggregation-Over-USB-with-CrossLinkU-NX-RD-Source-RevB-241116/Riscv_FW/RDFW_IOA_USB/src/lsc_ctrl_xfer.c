/****************************************************************************/
/**
 *
 * @file lsc_ctrl_xfer.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"
#include "lsc_usb_ch9.h"

#define DEBUG_LSC_CTRL_XFER

#ifdef DEBUG_LSC_CTRL_XFER
#define LSC_CTRL_XFER(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_CTRL_XFER(msg, ...)
#endif

/****************************************************************************/
/**
 * Enables USB Control Endpoint (EP0OUT and EP0IN).
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    size is control endpoint size.
 *           For High Speed - 64 bytes
 *           For Super Speed - 512 bytes
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *
 * @note     None.
 ****************************************************************************/
uint8_t lsc_usb_enable_ctrl_ep (struct lsc_usb_dev *usb_dev, uint16_t size)
{
    LSC_CTRL_XFER("lsc_usb_enable_ctrl_ep\r\n");

    uint32_t ret;

    ret = lsc_usb_ep_enable(usb_dev, 0, LSC_EP_DIR_OUT, size,
            LSC_ENDPOINT_XFER_CONTROL, false);
    if (ret == LSC_FAIL) {
        return LSC_FAIL;
    }

    ret = lsc_usb_ep_enable(usb_dev, 0, LSC_EP_DIR_IN, size,
            LSC_ENDPOINT_XFER_CONTROL, false);
    if (ret == LSC_FAIL) {
        return LSC_FAIL;
    }

    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * @brief
 * Stalls Control Endpoint and restarts to receive Setup packet.
 * Set Stall command is issued on EP0 OUT only. Controller automatically
 * clears stall and hence ready to receive new setup packet.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   None
 *
 * @note     None.
 *****************************************************************************/
void lsc_usb_ep0_stall_restart (struct lsc_usb_dev *usb_dev)
{
    LSC_CTRL_XFER("lsc_usb_ep0_stall_restart\r\n");
    sprintf(print_buf, "lsc_usb_ep0_stall_restart\r\n");

    struct lsc_ep *ep;

    /* reinitialize physical ep1 */
    ep = &usb_dev->eps[1];
    ep->ep_status = LSC_EP_ENABLED;

    /* stall is always issued on EP0 */
    lsc_usb_ep_set_stall(usb_dev, 0, LSC_EP_DIR_OUT);

    ep = &usb_dev->eps[0];
    ep->ep_status = LSC_EP_ENABLED;
    usb_dev->ep0_state = LSC_EP0_SETUP_PHASE;

    lsc_usb_rcv_setup(usb_dev);
}

/****************************************************************************/
/**
 * Checks the Data Phase and calls user Endpoint handler.
 * This function is called when controller generates transfer complete
 * event with EP0 state as LSC_EP0_DATA_PHASE.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    ep_evt is a pointer to the Endpoint event occurred in core.
 *
 * @return   None.
 *
 *****************************************************************************/
void lsc_usb_ep0_data_xfer_cmplt (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt)
{
    LSC_CTRL_XFER("------ lsc_usb_ep0_data_xfer_cmplt\r\n");

    struct lsc_ep *ep;
    struct lsc_trb *trb;
    uint32_t status;
    uint32_t length;
    uint32_t ep_num;
    uint8_t dir;

    ep_num = ep_evt->ep_number;
    dir = !!ep_num;
    ep = &usb_dev->eps[ep_num];
    trb = &usb_dev->ep0_trb;

    status = LSC_TRB_SIZE_TRBSTS(trb->size);

    if (status == LSC_TRBSTS_SETUP_PENDING) {
        return;
    }

    length = trb->size & LSC_TRB_SIZE_MASK;

    if (length == 0) {
        ep->bytes_txfered = ep->requested_bytes;
    } else {
        if (dir == LSC_EP_DIR_IN) {
            ep->bytes_txfered = ep->requested_bytes - length;
        } else {
            ep->bytes_txfered = ep->requested_bytes;
        }
    }

    if (dir == LSC_EP_DIR_OUT) {
        if ((usb_dev->setup_data.bRequestType & USB_REQ_TYPE_MASK)
                == USB_CMD_VENDREQ) {
            if (usb_dev->usb_vendor_req_handler != NULL) {
                usb_dev->usb_vendor_req_handler(usb_dev, &usb_dev->setup_data);
            }
        }
    }


}

/****************************************************************************/
/**
 * Checks the Status Phase and starts next Control transfer.
 * This function is called when controller generates transfer
 * complete event with EP0 state as LSC_EP0_STATUS_PHASE.
 * After completion of the status stage, prepare setup TRB to
 * receive setup packet from HOST.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   None.
 *****************************************************************************/
void lsc_usb_ep0_status_cmplt (struct lsc_usb_dev *usb_dev)
{
    LSC_CTRL_XFER("lsc_usb_ep0_status_cmplt\r\n");

    struct lsc_trb *trb;

    trb = &usb_dev->ep0_trb;

    if (usb_dev->is_test_mode != 0) {
        uint32_t reg_val;

        reg_val = lsc_32_read(usb_dev->base_add + LSC_DCTL);

        reg_val &= ~LSC_DCTL_TSTCTRL_MASK;
        reg_val |= (usb_dev->test_mode << 1);

        lsc_32_write(usb_dev->base_add + LSC_DCTL, reg_val);
    }

    lsc_usb_rcv_setup(usb_dev);
}

/****************************************************************************/
/**
 * Starts Status Phase of Control Transfer
 * This function prepares status TRB to initiate status stage of
 * a control transfer.
 * Start Transfer (DEPSTRTXFER) command is used to initiate transfer
 * on IN/OUT endpoint.
 * This function is called when controller generates transfer not ready
 * event with endpoint event status DEPEVT_STATUS_CONTROL_STATUS
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    ep_evt is a pointer to the Endpoint event occurred in core.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *****************************************************************************/
uint8_t lsc_usb_start_ep0_stat (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt)
{
    LSC_CTRL_XFER("lsc_usb_start_ep0_stat\r\n");

    struct lsc_ep *ep;
    struct lsc_ep_params *params;
    struct lsc_trb *trb;
    uint32_t type;
    uint32_t ret;
    uint8_t dir;

    ep = &usb_dev->eps[ep_evt->ep_number];
    params = lsc_usb_get_ep_params(usb_dev);

    if ((ep->ep_status & LSC_EP_BUSY) != 0) {
        return LSC_FAIL;
    }

    type = (usb_dev->is_three_stage != 0) ?
            LSC_TRBCTL_CONTROL_STATUS3 : LSC_TRBCTL_CONTROL_STATUS2;

    trb = &usb_dev->ep0_trb;

    /* we use same trb for setup packet */
    trb->buf_ptr_lo = (uintptr_t)&usb_dev->setup_data;
    trb->buf_ptr_hi = ((uintptr_t)&usb_dev->setup_data >> 16) >> 16;

    trb->size = 0;
    trb->ctrl = type;

    trb->ctrl |= (LSC_TRB_CTRL_HWO | LSC_TRB_CTRL_LST | LSC_TRB_CTRL_IOC
            | LSC_TRB_CTRL_ISP_IMI);

    params->param0 = 0;
    params->param1 = (uintptr_t)trb;
    usb_dev->ep0_state = LSC_EP0_STATUS_PHASE;

    /*
     * Control OUT transfer - Status stage happens on EP0 IN - EP1
     * Control IN transfer - Status stage happens on EP0 OUT - EP0
     */
    dir = !usb_dev->control_dir;
    //printf("* usb_send_ep_cmd\r\n");
    ret = lsc_usb_send_ep_cmd(usb_dev, 0, dir, LSC_DEPCMD_STARTTRANSFER,
            params);
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
 * Ends Data Phase - used in case of error.
 * This function is used to end control transfer for an endpoint.
 * End Transfer (DEPENDXFER) command is used to end transfer
 * on IN/OUT endpoint.
 * This function is called when controller generates transfer not ready
 * event with endpoint event status DEPEVT_STATUS_CONTROL_DATA when error
 * occurs.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    ep is a pointer to the Endpoint structure.
 *
 * @return   None
 *
 *****************************************************************************/
void lsc_usb_end_ep0_ctl_data_xfer (struct lsc_usb_dev *usb_dev,
        struct lsc_ep *ep)
{
    LSC_CTRL_XFER("lsc_usb_end_ep0_ctl_data_xfer\r\n");

    struct lsc_ep_params *params;
    uint32_t cmd;

    if (ep->resource_index == 0) {
        return;
    }

    params = lsc_usb_get_ep_params(usb_dev);

    cmd = LSC_DEPCMD_ENDTRANSFER;
    cmd |= LSC_DEPCMD_PARAM(ep->resource_index);

    lsc_usb_send_ep_cmd(usb_dev, ep->usb_ep_num, ep->ep_direction, cmd, params);
    ep->resource_index = 0;
    lsc_usb_usleep(200);
}

/** @} */
