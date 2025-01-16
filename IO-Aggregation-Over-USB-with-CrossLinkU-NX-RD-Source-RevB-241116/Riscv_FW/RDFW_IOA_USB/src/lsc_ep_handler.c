/****************************************************************************/
/**
 *
 * @file lsc_ep_handler.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"

//#define DEBUG_LSC_EP_HANDLER

#ifdef DEBUG_LSC_EP_HANDLER
#define LSC_EP_HANDLER(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_EP_HANDLER(msg, ...)
#endif


/****************************************************************************/
/**
 * @brief
 * Stops transfer on Endpoint.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction of endpoint
 *               - LSC_EP_DIR_IN/ LSC_EP_DIR_OUT.
 * @param    force flag to stop/pause transfer.
 *
 * @return   None.
 *
 * @note     None.
 ****************************************************************************/
void lsc_usb_stop_xfer (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir, uint8_t force)
{
    LSC_EP_HANDLER("lsc_usb_stop_xfer\r\n");

    uint8_t phy_ep_num;
    uint32_t    cmd;
    struct lsc_ep *ep;
    struct lsc_ep_params *params;

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);
    ep = &usb_dev->eps[phy_ep_num];

    params = lsc_usb_get_ep_params(usb_dev);

    if (ep->resource_index == 0) {
        return;
    }

    /*
     * - Issue EndTransfer WITH CMDIOC bit set
     * - Wait 100us
     */
    cmd = LSC_DEPCMD_ENDTRANSFER;
    cmd |= (force == 1) ? LSC_DEPCMD_HIPRI_FORCERM : 0;
    cmd |= LSC_DEPCMD_CMDIOC;
    cmd |= LSC_DEPCMD_PARAM(ep->resource_index);

    lsc_usb_send_ep_cmd(usb_dev, ep->usb_ep_num, ep->ep_direction,
            cmd, params);
    if (force == 1) {
        ep->resource_index = 0;
    }

    ep->ep_status &= ~LSC_EP_BUSY;

    lsc_usb_usleep(100);

    // Following variable is specific for Setu project.
    // Reset number of previous bulk out complete flag to 0.
    // We are expecting to receive new command packet after getting
    // diconnected and re-enumerated also new command shall be received.
    //previous_bo_cmd_cmp = 0;
    //bi_total_txferred_bytes = 0;
    //memset(bulk_data_buf,0,sizeof(bulk_data_buf));
}

/****************************************************************************/
/**
 * @brief
 * Clears Stall on an Endpoint.
 * Clear Stall (DEPCSTALL) is issued on endpoint to clear stall.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction.
 *
 * @return   None.
 *
 * @note     The application must not issue the Clear Stall command
 *           on a control endpoint.<br>
 *****************************************************************************/
void lsc_usb_ep_clear_stall (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir)
{
    LSC_EP_HANDLER("lsc_usb_ep_clear_stall\r\n");

    uint8_t phy_ep_num;
    struct lsc_ep *ep;
    struct lsc_ep_params *params;

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);
    printf("phy_ep_num:%x\r\n",phy_ep_num);
    ep = &usb_dev->eps[phy_ep_num];

    params = lsc_usb_get_ep_params(usb_dev);

    lsc_usb_send_ep_cmd(usb_dev, ep->usb_ep_num, ep->ep_direction,
            LSC_DEPCMD_CLEARSTALL, params);

    ep->ep_status &= ~LSC_EP_STALL;

    //Reset ep status of Non- control endpoint

    ep->ep_status &=~ LSC_EP_BUSY;
}

/****************************************************************************/
/**
 * @brief
 * Checks the Data Phase and calls user Endpoint handler.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    ep_evt is a pointer to the Endpoint event occurred in core.
 *
 * @return   None.
 *
 * @note     None.
 *****************************************************************************/
void lsc_usb_ep_xfer_cmplt (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt)
{
    LSC_EP_HANDLER("lsc_usb_ep_xfer_cmplt\r\n");

    struct lsc_trb  *trb;
    struct lsc_ep *ep;

    uint32_t    len;
    uint32_t    ep_num;
    uint8_t   dir;

    ep_num = ep_evt->ep_number;
    ep = &usb_dev->eps[ep_num];
    dir = ep->ep_direction;
    trb = &ep->ep_trb[ep->trb_dequeue];

    uint32_t usb_ep_num = ep_num >> 1;
//  LSC_EP_HANDLER("ep_num:%x "dir:%x\r\n",ep_num,dir);

    ep->trb_dequeue++;
    if (ep->trb_dequeue == NO_OF_TRB_PER_EP) {
        ep->trb_dequeue = 0;
    }

    if (ep_evt->ep_event == LSC_DEPEVT_XFERCOMPLETE) {
        ep->ep_status &= ~(LSC_EP_BUSY);
        ep->resource_index = 0;
    }

    len = trb->size & LSC_TRB_SIZE_MASK;

    if (len == 0) {
        ep->bytes_txfered = ep->requested_bytes;
    } else {
        if (dir == LSC_EP_DIR_IN) {
            ep->bytes_txfered = ep->requested_bytes - len;
        } else {
            if (ep->unaligned_tx == 1) {
                ep->bytes_txfered = (uint32_t)roundup(
                             ep->requested_bytes,
                             (uint32_t)ep->max_ep_size);
                ep->bytes_txfered -= len;
                ep->unaligned_tx = 0;
            } else {
                /*
                 * Get the actual number of bytes transmitted
                 * by host
                 */
                ep->bytes_txfered = ep->requested_bytes - len;
            }
        }
    }
//  LSC_EP_HANDLER("ep->bytes_txfered :%x ep->requested_bytes:%x\r\n",  ep->bytes_txfered,ep->requested_bytes );

    if (dir == LSC_EP_DIR_OUT) {
        /* Invalidate Cache */

    } else {
        //EP DIR IN
        //after transfer complete
//      printf("#\r\n");
    }

  if (ep->handler != NULL) {
        ep->handler(usb_dev, usb_ep_num, ep->requested_bytes);
    }

}

/****************************************************************************/
/**
 * @brief
 * Handles Transfer Not Ready event of Non - Control Endpoints.
 * This function is called when controller generates transfer not ready event
 * on non-control endpoint.
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    ep_evt is a pointer to the Endpoint event occurred in core.
 *
 * @return   None.
 *
 * @note     None.
 *
 *****************************************************************************/
void lsc_usb_ep_xfer_not_ready (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt)
{
//    LSC_EP_HANDLER("lsc_usb_ep_xfer_not_ready\r\n");

    struct lsc_ep   *ep;
    uint32_t    ep_num;
    uint32_t    cur_uf;
    uint32_t    Mask;

    ep_num = ep_evt->ep_number;
    ep = &usb_dev->eps[ep_num];

    if (ep->ep_type == LSC_ENDPOINT_XFER_BULK) {
    }
}

/****************************************************************************/
/**
 * @brief
 * Returns status of endpoint - Stalled or not
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction of endpoint
 *               - LSC_EP_DIR_IN/ LSC_EP_DIR_OUT.
 *
 * @return
 *           1 - if stalled
 *           0 - if not stalled
 *
 * @note     None.
 *****************************************************************************/
uint8_t lsc_usb_is_ep_stalled (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir)
{
//    LSC_EP_HANDLER("lsc_usb_is_ep_stalled\r\n");

    uint8_t phy_ep_num;
    struct lsc_ep *ep;

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);
    ep = &usb_dev->eps[phy_ep_num];

    return (uint32_t)(!!(ep->ep_status & LSC_EP_STALL));
}

/****************************************************************************/
/**
 * @brief
 * Stalls an Endpoint.
 * Set Stall (DEPSSTALL) is issued on endpoint to set stall.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction.
 *
 * @return   None.
 *****************************************************************************/
void lsc_usb_ep_set_stall (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir)
{
//    LSC_EP_HANDLER("lsc_usb_ep_set_stall\r\n");

    uint8_t phy_ep_num;
    struct lsc_ep *ep = NULL;
    struct lsc_ep_params *params;

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);
    ep = &usb_dev->eps[phy_ep_num];

    params = lsc_usb_get_ep_params(usb_dev);

    lsc_usb_send_ep_cmd(usb_dev, ep->usb_ep_num, ep->ep_direction,
            LSC_DEPCMD_SETSTALL, params);

    ep->ep_status |= LSC_EP_STALL;
}


/****************************************************************************/
/**
* @brief
* Sets an user handler to be called after data is sent/received by an Endpoint
*
* @param    usb_dev is a pointer to the lsc_usb_dev instance.
* @param    epnum is USB endpoint number.
* @param    dir is direction of endpoint
*               - LSC_EP_DIR_IN/LSC_EP_DIR_OUT.
* @param    handler is user handler to be called.
*
* @return   None.
*
* @note     None.
*
*****************************************************************************/
void lsc_set_ep_handler(struct lsc_usb_dev *usb_dev, uint8_t epnum,
        uint8_t dir, void (*handler)(void *, uint32_t, uint32_t))
{
    LSC_EP_HANDLER("lsc_SetEpHandler\r\n");
    uint8_t phy_ep_num;
    struct lsc_ep *ep = NULL;

    phy_ep_num = lsc_physicalep(epnum, dir);
    ep = &usb_dev->eps[phy_ep_num];
    ep->handler = (void (*)(void *, uint32_t, uint32_t))handler;
}


/****************************************************************************/
/**
* @brief
* Initiates DMA to receive data on Endpoint from Host.
*
* @param    usb_dev is pointer to lsc_usb_dev instance.
* @param    usb_ep_num is USB endpoint number.
* @param    buf is pointer to data. This data buffer is cache-aligned.
* @param    len is length of data to be received.
*
* @return   LSC_SUCCESS else LSC_FAIL
*
* @note     This function is expected to initiates DMA to receive data on
*       the endpoint from the Host. This data buffer should be aligned.
*
*****************************************************************************/
uint8_t lsc_usb_ep_buf_rcv(struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
             uint8_t *buf, uint32_t len)
{
  LSC_EP_HANDLER("lsc_EpBufferRecv\r\n");
    uint8_t   phy_ep_num = 0;
    uint32_t    cmd = 0;
    uint32_t    size = 0;
    uint8_t ret_val = 0;
    struct lsc_trb  *trb = NULL;
    struct lsc_ep *ep = NULL;
    struct lsc_ep_params params;

    phy_ep_num = lsc_physicalep(usb_ep_num, LSC_EP_DIR_OUT);
//  LSC_EP_HANDLER("phy_ep_num:%x\r\n",phy_ep_num);

    ep = &usb_dev->eps[phy_ep_num];


    if ((ep->ep_status & LSC_EP_BUSY) != 0) {
        return LSC_FAIL;
    }

//  LSC_EP_HANDLER("ep->ep_direction:%x\r\n",ep->ep_direction);
    if (ep->ep_direction != LSC_EP_DIR_OUT) {
        return (int)LSC_FAIL;
    }

    ep->requested_bytes = len;
    size = len;
    ep->bytes_txfered = 0;
    ep->buffer_ptr = buf;

    /*
     * 8.2.5 - An OUT transfer size (Total TRB buffer allocation)
     * must be a multiple of MaxPacketSize even if software is expecting a
     * fixed non-multiple of MaxPacketSize transfer from the Host.
     */
    if (!IS_ALIGNED(len, ep->max_ep_size)) {
        size = (uint32_t)roundup(len, (uint32_t)ep->max_ep_size);
        ep->unaligned_tx = 1;
    }

    trb = &ep->ep_trb[ep->trb_enqueue];

    ep->trb_enqueue += 1;
    if (ep->trb_enqueue == NO_OF_TRB_PER_EP) {
        ep->trb_enqueue = 0;
    }

    trb->buf_ptr_lo  = (uintptr_t)buf;
    trb->buf_ptr_hi = ((uintptr_t)buf >> 16) >> 16;

    trb->size = size;

    switch (ep->ep_type) {
        case LSC_ENDPOINT_XFER_ISOC:
            /*
             *  According to Linux driver, LSC_TRBCTL_ISOCHRONOUS and
             *  LSC_TRBCTL_CHN fields are only set when request has
             *  scattered list so these fields are not set over here.
             */
            trb->ctrl = (LSC_TRBCTL_ISOCHRONOUS_FIRST
                    | LSC_TRB_CTRL_CSP);

            break;
        case LSC_ENDPOINT_XFER_INT:
        case LSC_ENDPOINT_XFER_BULK:
            trb->ctrl = (LSC_TRBCTL_NORMAL
                    | LSC_TRB_CTRL_LST);

            break;
        default:
            /* Do Nothing. Added for making MISRA-C complaint */
            break;
    }

    trb->ctrl |= (LSC_TRB_CTRL_HWO
             | LSC_TRB_CTRL_IOC
              /*|LSC_TRB_CTRL_ISP_IMI*/);

    params.param0 = 0;
    params.param1 = (uintptr_t)trb;
    params.param2 = 0;

    if ((ep->ep_status & LSC_EP_BUSY) != (uint32_t)0) {
        cmd = LSC_DEPCMD_UPDATETRANSFER;
        cmd |= LSC_DEPCMD_PARAM(ep->resource_index);
    } else {
        if (ep->ep_type == LSC_ENDPOINT_XFER_ISOC) {
            buf += len;
            struct lsc_trb  *TrbTempNext;
            TrbTempNext = &ep->ep_trb[ep->trb_enqueue];

            ep->trb_enqueue++;
            if (ep->trb_enqueue == NO_OF_TRB_PER_EP) {
                ep->trb_enqueue = 0;
            }

            TrbTempNext->buf_ptr_lo  = (uintptr_t)buf;
            TrbTempNext->buf_ptr_hi  = ((uintptr_t)buf >>
                               16) >> 16;
            TrbTempNext->size = len & LSC_TRB_SIZE_MASK;

            TrbTempNext->ctrl = (LSC_TRBCTL_ISOCHRONOUS_FIRST
                         | LSC_TRB_CTRL_CSP
                         | LSC_TRB_CTRL_HWO
                         | LSC_TRB_CTRL_IOC
                         | LSC_TRB_CTRL_ISP_IMI);

            cmd |= LSC_DEPCMD_PARAM(ep->cur_micro_frame);
        }

        cmd = LSC_DEPCMD_STARTTRANSFER;
    }

    ret_val = lsc_usb_send_ep_cmd(usb_dev, usb_ep_num, ep->ep_direction,
                   cmd, &params);
    if (ret_val != LSC_SUCCESS) {
        return LSC_FAIL;
    }

    if ((ep->ep_status & LSC_EP_BUSY) == (uint32_t)0) {
        ep->resource_index = (uint8_t)lsc_usb_ep_get_xfer_index(usb_dev,
                     ep->usb_ep_num,
                     ep->ep_direction);

        ep->ep_status |= LSC_EP_BUSY;
    }
    return LSC_SUCCESS;
}


/****************************************************************************/
/**
* @brief
* Initiates DMA to send data on endpoint to Host.
*
* @param    usb_dev is pointer to lsc_usb_dev instance.
* @param    usb_ep_num is USB endpoint number.
* @param    buf is pointer to data. This data buffer is cache-aligned.
* @param    buf_len is length of data buffer.
*
* @return   LSC_SUCCESS else LSC_FAIL
*
* @note     This function is expected to initiates DMA to send data on
*       endpoint towards Host. This data buffer should be aligned.
*       DMA is configured using Transfer Request Blocks (TRB).
*
*****************************************************************************/
uint8_t lsc_usb_ep_buf_send (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
             uint8_t *buf, uint32_t buf_len)
{
    LSC_EP_HANDLER("lsc_EpBufferSend\r\n");
    uint8_t   phy_ep_num = 0;
    uint32_t    cmd = 0;
    uint8_t ret_val = 0;
    struct lsc_trb  *trb = NULL;
    struct lsc_ep *ep = NULL;
    struct lsc_ep_params params;

    phy_ep_num = lsc_physicalep(usb_ep_num, LSC_EP_DIR_IN);

    ep = &usb_dev->eps[phy_ep_num];

    if ((ep->ep_status & LSC_EP_BUSY) != 0)
        {
        return LSC_FAIL;
    }

    if (ep->ep_direction != LSC_EP_DIR_IN) {
        return (int)LSC_FAIL;
    }

    ep->requested_bytes = buf_len;
    ep->bytes_txfered = 0;
    ep->buffer_ptr = buf;

    trb = &ep->ep_trb[ep->trb_enqueue];

    ep->trb_enqueue++;
    if (ep->trb_enqueue == NO_OF_TRB_PER_EP) {
        ep->trb_enqueue = 0;
    }

    trb->buf_ptr_lo  = (uintptr_t)buf;
    trb->buf_ptr_hi  = ((uintptr_t)buf >> 16) >> 16;

    trb->size = buf_len & LSC_TRB_SIZE_MASK;

    switch (ep->ep_type) {
        case LSC_ENDPOINT_XFER_ISOC:
            /*
             *  According to DWC3 datasheet, LSC_TRBCTL_ISOCHRONOUS and
             *  LSC_TRBCTL_CHN fields are only set when request has
             *  scattered list so these fields are not set over here.
             */
            trb->ctrl = (LSC_TRBCTL_ISOCHRONOUS_FIRST
                    | LSC_TRB_CTRL_CSP);

            break;
        case LSC_ENDPOINT_XFER_INT:
        case LSC_ENDPOINT_XFER_BULK:
            trb->ctrl = (LSC_TRBCTL_NORMAL
                    | LSC_TRB_CTRL_LST);

            break;
        default:
            /* Do Nothing. Added for making MISRA-C complaint */
            break;
    }

    trb->ctrl |= (LSC_TRB_CTRL_HWO
             | LSC_TRB_CTRL_IOC
             /*| LSC_TRB_CTRL_ISP_IMI*/);//Commented the ISP_IMI since this is for isoschronous and was facing issue in bulk transfer if it is enabled.

    params.param0 = 0;
    params.param1 = (uintptr_t)trb;
    params.param2 = 0;

    if ((ep->ep_status & LSC_EP_BUSY) != (uint32_t)0) {
        cmd = LSC_DEPCMD_UPDATETRANSFER;
        cmd |= LSC_DEPCMD_PARAM(ep->resource_index);
    } else {
        if (ep->ep_type == LSC_ENDPOINT_XFER_ISOC) {
            buf += buf_len;
            struct lsc_trb  *trbtempnext ;
            trbtempnext = &ep->ep_trb[ep->trb_enqueue];

            ep->trb_enqueue++;
            if (ep->trb_enqueue == NO_OF_TRB_PER_EP) {
                ep->trb_enqueue = 0;
            }

            trbtempnext->buf_ptr_lo  = (uintptr_t)buf;
            trbtempnext->buf_ptr_hi  = ((uintptr_t)buf >>
                               16) >> 16;
            trbtempnext->size = buf_len & LSC_TRB_SIZE_MASK;

            trbtempnext->ctrl = (LSC_TRBCTL_ISOCHRONOUS_FIRST
                         | LSC_TRB_CTRL_CSP
                         | LSC_TRB_CTRL_HWO
                         | LSC_TRB_CTRL_IOC
                         | LSC_TRB_CTRL_ISP_IMI);

            cmd |= LSC_DEPCMD_PARAM(ep->cur_micro_frame);
        }

        cmd = LSC_DEPCMD_STARTTRANSFER;
    }


    if ((ep->ep_status & LSC_EP_BUSY) == (uint32_t)0) {
        ep->resource_index = (uint8_t)lsc_usb_ep_get_xfer_index(usb_dev,
                     ep->usb_ep_num,
                     ep->ep_direction);

        ep->ep_status |= LSC_EP_BUSY;
    }


    ret_val = lsc_usb_send_ep_cmd(usb_dev, usb_ep_num, ep->ep_direction,
                   cmd, &params);
    if (ret_val != (int)LSC_SUCCESS) {
        return (int)LSC_FAIL;
    }

    return (int)LSC_SUCCESS;
}


/** @} */
