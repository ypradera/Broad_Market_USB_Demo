/****************************************************************************/
/**
 *
 * @file lsc_command.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"

//#define DEBUG_LSC_CMD

#ifdef DEBUG_LSC_CMD
#define LSC_CMD(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_CMD(msg, ...)
#endif

/****************************************************************************/
/**
 * Returns zeroed parameters to be used by Endpoint commands
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   Zeroed Params structure pointer.
 *
 * @note     None.
 *****************************************************************************/
struct lsc_ep_params* lsc_usb_get_ep_params (struct lsc_usb_dev *usb_dev)
{
    LSC_CMD("lsc_usb_get_ep_params\r\n");

    // Setting ep_params to zero.
    usb_dev->ep_params.param0 = 0x00;
    usb_dev->ep_params.param1 = 0x00;
    usb_dev->ep_params.param2 = 0x00;

    return &usb_dev->ep_params;

//    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * This function sends physical endpoint-specific commands.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction of endpoint
 *           - LSC_EP_DIR_IN/ LSC_EP_DIR_OUT.
 * @param    cmd is Endpoint command.
 * @param    params is Endpoint command parameters.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *
 *****************************************************************************/
uint32_t lsc_usb_send_ep_cmd (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir, uint32_t cmd, struct lsc_ep_params *params)
{
    LSC_CMD("lsc_usb_send_ep_cmd\r\n");

    uint32_t phy_ep_num;

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);

    lsc_32_write((usb_dev->base_add + LSC_DEPCMDPAR0(phy_ep_num)),
            params->param0);
    lsc_32_write((usb_dev->base_add + LSC_DEPCMDPAR1(phy_ep_num)),
            params->param1);
    lsc_32_write((usb_dev->base_add + LSC_DEPCMDPAR2(phy_ep_num)),
            params->param2);

    lsc_32_write((usb_dev->base_add + LSC_DEPCMD(phy_ep_num)),
            (cmd | LSC_DEPCMD_CMDACT));

    while (lsc_32_read(usb_dev->base_add + LSC_DEPCMD(phy_ep_num))
            & LSC_DEPCMD_CMDACT)
        ;  //poll CMDACT
  LSC_CMD("------\r\n");
  LSC_CMD("Param0: %x\r\n", lsc_32_read(usb_dev->base_add + LSC_DEPCMDPAR0(phy_ep_num)));
  LSC_CMD("Param1: %x\r\n", lsc_32_read(usb_dev->base_add + LSC_DEPCMDPAR1(phy_ep_num)));
  LSC_CMD("Param2: %x\r\n", lsc_32_read(usb_dev->base_add + LSC_DEPCMDPAR2(phy_ep_num)));

    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * @brief
 * Enables Endpoint for sending/receiving data. Endpoints are
 * enabled using Start New Configuration (DEPSTARTCFG) and
 * Set Endpoint Configuration (DEPCFG)
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction of endpoint
 *               - LSC_EP_DIR_IN/ LSC_EP_DIR_OUT.
 * @param    max_size is size of Endpoint size.
 * @param    ep_type is Endpoint type Control/Bulk/Interrupt/Isoc.
 * @param    restore should be true if saved state should be restored;
 *           typically this would be false
 *
 * @return   LSC_SUCCESS else LSC_FAIL

 ****************************************************************************/
uint32_t lsc_usb_ep_enable (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir, uint16_t max_size, uint8_t ep_type, uint8_t restore)
{
    LSC_CMD("lsc_usb_ep_enable\r\n");

    //LSC_CMD("usb_ep_num: %x\tdir: %x\tmax_size: %x\tep_type: %x\r\n", usb_ep_num, dir, max_size, ep_type);

    struct lsc_ep *ep;
    uint32_t reg_val;
    uint32_t phy_ep_num;

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);
    ep = &usb_dev->eps[phy_ep_num];

//  printf("phy_ep_num: %x\tep->ep_status: %x\r\n", phy_ep_num, ep->ep_status);

    ep->usb_ep_num = usb_ep_num;
    ep->ep_direction = dir;
    ep->ep_type = ep_type;
    ep->max_ep_size = max_size;
    ep->phy_ep_num = phy_ep_num;
    ep->cur_micro_frame = 0;

    if ((ep->ep_status & LSC_EP_ENABLED) == 0) {
//      printf("-1-\r\n");
        if (lsc_usb_start_ep_cfg(usb_dev, usb_ep_num, dir) == LSC_FAIL) {
//          printf("-2-\r\n");
            return LSC_FAIL;
        }
    }

    if (lsc_usb_set_ep_cfg(usb_dev, usb_ep_num, dir, max_size, ep_type, restore)
            == LSC_FAIL) {
//      printf("-3-\r\n");
        return LSC_FAIL;
    }

    if ((ep->ep_status & LSC_EP_ENABLED) == 0) {
//      printf("-4-\r\n");
        if (lsc_usb_set_xfer_resource(usb_dev, usb_ep_num, dir) == LSC_FAIL) {
//          printf("-5-\r\n");
            return LSC_FAIL;
        }

        ep->ep_status |= LSC_EP_ENABLED;

        reg_val = lsc_32_read(usb_dev->base_add + LSC_DALEPENA);
        reg_val |= (LSC_DALEPENA_EP(ep->phy_ep_num));

        lsc_32_write((usb_dev->base_add + LSC_DALEPENA), reg_val);
        //LSC_CMD("Active EP: %x\r\n",
               // lsc_32_read(usb_dev->base_add + LSC_DALEPENA));
    }
//  printf("-6-\r\n");
    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * @brief
 * Disables Endpoint. It clears corresponding bit for a physical
 * endpoint from Device Active USB Endpoint Enable Register (DALEPENA).
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    usb_ep_num is USB endpoint number.
 * @param    dir is direction of endpoint
 *           - LSC_EP_DIR_IN/ LSC_EP_DIR_OUT.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 ****************************************************************************/
uint32_t lsc_usb_ep_disable (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir)
{
//    LSC_CMD("lsc_usb_ep_disable\r\n");

    uint32_t reg_val;
    uint8_t phy_ep_num;
    struct lsc_ep *ep;

    phy_ep_num = lsc_physicalep(usb_ep_num, dir);
    ep = &usb_dev->eps[phy_ep_num];

    /* make sure HW endpoint isn't stalled */
    if ((ep->ep_status & LSC_EP_STALL) != 0) {
        lsc_usb_ep_clear_stall(usb_dev, ep->usb_ep_num, ep->ep_direction);
    }

    reg_val = lsc_32_read(usb_dev->base_add + LSC_DALEPENA);
    reg_val &= ~LSC_DALEPENA_EP(ep->phy_ep_num);

    lsc_32_write((usb_dev->base_add + LSC_DALEPENA), reg_val);

    ep->ep_type = 0;
    ep->ep_status = 0;
    ep->max_ep_size = 0;
    ep->trb_enqueue  = 0;
    ep->trb_dequeue  = 0;

    return LSC_SUCCESS;
}

/** @} */
