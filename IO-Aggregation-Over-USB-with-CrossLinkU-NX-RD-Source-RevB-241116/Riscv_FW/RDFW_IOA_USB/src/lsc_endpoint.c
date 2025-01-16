/****************************************************************************/
/**
 *
 * @file lsc_endpoint.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"

//#define DEBUG_LSC_EP

#ifdef DEBUG_LSC_EP
#define LSC_EP(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_EP(msg, ...)
//#define LSC_EP_t(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#endif

/****************************************************************************/
/**
 * Returns Transfer Index assigned by Core for an Endpoint transfer.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction of endpoint
 *               - LSC_EP_DIR_IN/LSC_EP_DIR_OUT
 *
 * @return   Transfer Resource Index.
 *
 *****************************************************************************/
uint32_t lsc_usb_ep_get_xfer_index (struct lsc_usb_dev *usb_dev,
        uint8_t usb_ep_num, uint8_t dir)
{
    LSC_EP("lsc_usb_ep_get_xfer_index\r\n");
    //LSC_EP_t("lsc_usb_ep_get_xfer_index\r\n");

    uint8_t phy_ep_num;
    uint32_t res_index;

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);
    res_index = lsc_32_read(usb_dev->base_add + LSC_DEPCMD(phy_ep_num));
    LSC_EP("usb_ep_num: %x\tres_index: %x\r\n", usb_ep_num, res_index);
    //LSC_EP_t("usb_ep_num: %x\tres_index: %x\r\n", usb_ep_num, res_index);

    return LSC_DEPCMD_GET_RSC_IDX(res_index);
}

/****************************************************************************/
/**
 * Sends Start New Configuration command to Endpoint.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction of endpoint
 *           - LSC_EP_DIR_IN/ LSC_EP_DIR_OUT.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *
 * @note
 *           This command should be issued by software
 *           under these conditions:
 *           1. After power-on-reset with xfer_rsc_idx=0 before starting
 *              to configure Physical Endpoints 0 and 1.
 *           2. With xfer_rsc_idx=2 before starting to configure
 *              Physical Endpoints > 1
 *           3. This command should always be issued to
 *              Endpoint 0 (DEPCMD0).
 *****************************************************************************/
uint32_t lsc_usb_start_ep_cfg (struct lsc_usb_dev *usb_dev, uint32_t usb_ep_num,
        uint8_t dir)
{
    LSC_EP("lsc_usb_start_ep_cfg\r\n");
    //LSC_EP_t("lsc_usb_start_ep_cfg\r\n");

    struct lsc_ep_params *params;
    uint32_t cmd;
    uint8_t phy_ep_num;

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);
    //LSC_EP_t("phy_ep_num 0x%02x \r\n", phy_ep_num);
    params = lsc_usb_get_ep_params(usb_dev);

    if (phy_ep_num != 1) {
        cmd = LSC_DEPCMD_DEPSTARTCFG;
        /* XferRscIdx == 0 for EP0 and 2 for the remaining */
        if (phy_ep_num > 1) {
            if (usb_dev->is_config_done != 0) {
                return LSC_SUCCESS;
            }
            usb_dev->is_config_done = 1;
            cmd |= LSC_DEPCMD_PARAM(2); //2 - xfer_res_index for ep other than control ep
        }

        return lsc_usb_send_ep_cmd(usb_dev, 0, LSC_EP_DIR_OUT, cmd, params);
    }

    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * Sends Set Endpoint Configuration command to Endpoint.
 * This command sets the physical endpoint configuration information.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction of endpoint
 *               -LSC_EP_DIR_IN/ LSC_EP_DIR_OUT.
 * @param    size is size of Endpoint size.
 * @param    ep_type is Endpoint type Control/Bulk/Interrupt/Isoc.
 * @param    restore should be true if saved state should be restored;
 *           typically this would be false
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *****************************************************************************/
uint32_t lsc_usb_set_ep_cfg (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir, uint16_t size, uint8_t ep_type, uint8_t restore)
{
    //LSC_EP("lsc_usb_set_ep_cfg\r\n");

    struct lsc_ep *ep;
    struct lsc_ep_params *params;
    uint8_t phy_ep_num;

    params = lsc_usb_get_ep_params(usb_dev);

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);
    ep = &usb_dev->eps[phy_ep_num];

    params->param0 = LSC_DEPCFG_EP_TYPE(
            ep_type) | LSC_DEPCFG_MAX_PACKET_SIZE(size);

    /*
     * Set burst size to 1 as recommended
     */
    if (usb_dev->dev_speed == LSC_SPEED_SUPER) {
        params->param0 |= LSC_DEPCFG_BURST_SIZE(1);
    }

    params->param1 = LSC_DEPCFG_XFER_COMPLETE_EN | LSC_DEPCFG_XFER_NOT_READY_EN;

    if (restore == true) {
        params->param0 |= LSC_DEPCFG_ACTION_RESTORE;
        params->param2 = ep->ep_saved_state;
    }

    /*
     * We are doing 1:1 mapping for endpoints, meaning
     * Physical Endpoints 2 maps to Logical Endpoint 2 and
     * so on. We consider the direction bit as part of the physical
     * endpoint number. So USB endpoint 0x81 is 0x03.
     */
    params->param1 |= LSC_DEPCFG_EP_NUMBER(phy_ep_num);

    if (dir != LSC_EP_DIR_OUT) {
        params->param0 |= LSC_DEPCFG_FIFO_NUMBER((phy_ep_num >> 1));
    }

    return lsc_usb_send_ep_cmd(usb_dev, usb_ep_num, dir, LSC_DEPCMD_SETEPCONFIG,
            params);

    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * Sends Set Transfer Resource command to Endpoint.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction of endpoint - LSC_EP_DIR_IN/ LSC_EP_DIR_OUT
 *
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *****************************************************************************/
uint32_t lsc_usb_set_xfer_resource (struct lsc_usb_dev *usb_dev,
        uint8_t usb_ep_num, uint8_t dir)
{
//    LSC_EP("lsc_usb_set_xfer_resource\r\n");

    struct lsc_ep_params *params;

    params = lsc_usb_get_ep_params(usb_dev);

    params->param0 = LSC_DEPXFERCFG_NUM_XFER_RES(1);

    return lsc_usb_send_ep_cmd(usb_dev, usb_ep_num, dir,
            LSC_DEPCMD_SETTRANSFRESOURCE, params);

    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * Clears stall on all stalled Eps.
 * This function clears stall for all endpoints except EP0 OUT
 * (Physical EP - 0) as controller clears stall of EP0_OUT automatially.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   None.
 *****************************************************************************/
void lsc_usb_clear_stall_all_ep (struct lsc_usb_dev *usb_dev)
{
//    LSC_EP("lsc_usb_clear_stall_all_ep\r\n");

    for (uint32_t ep_num = 1; ep_num < LSC_ENDPOINTS_NUM; ep_num++) {
        struct lsc_ep *ep;

        ep = &usb_dev->eps[ep_num];

        if ((ep->ep_status & LSC_EP_ENABLED) == 0) {
            continue;
        }

        if ((ep->ep_status & LSC_EP_STALL) == 0) {
            continue;
        }

        lsc_usb_ep_clear_stall(usb_dev, ep->usb_ep_num, ep->ep_direction);
    }
}

/****************************************************************************/
/**
 * Stops any active transfer.
 * This function stops active transfer of any non control endpoints.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   None.
 *****************************************************************************/
void lsc_usb_stop_active_transfers (struct lsc_usb_dev *usb_dev)
{
//    LSC_EP("lsc_usb_stop_active_transfers\r\n");

    for (uint32_t ep_num = 2; ep_num < LSC_ENDPOINTS_NUM; ep_num++) {
        struct lsc_ep *ep;

        ep = &usb_dev->eps[ep_num];

        if ((ep->ep_status & LSC_EP_ENABLED) == 0)
            continue;

        lsc_usb_stop_xfer(usb_dev, ep->usb_ep_num, ep->ep_direction, true);
    }
}

/** @} */
