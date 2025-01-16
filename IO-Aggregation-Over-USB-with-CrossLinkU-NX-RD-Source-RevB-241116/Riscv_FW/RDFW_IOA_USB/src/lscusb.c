/****************************************************************************/
/**
 *
 * @file lscusb.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"

#define DEBUG_LSC_USB

#ifdef DEBUG_LSC_USB
#define LSC_USB(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_USB(msg, ...)
#endif

/****************************************************************************/
/**
 * @brief
 * This function does the following:
 *   - initializes a specific lsc_usb_dev instance.
 *   - sets up Event Buffer for Core to write events.
 *   - Core Reset and PHY Reset.
 *   - Sets core in Device Mode.
 *   - Sets default speed as HIGH_SPEED.
 *   - Sets Device Address to 0.
 *   - Enables interrupts.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    base_add is the device base address.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *
 * @note     None.
 *****************************************************************************/
uint8_t lsc_usb_init (struct lsc_usb_dev *usb_dev, uint32_t base_add)
{
    LSC_USB("lsc_usb_init\r\n");

    uint32_t status = 0, reg_val = 0, speed = 0;

    usb_dev->base_add = base_add;

    status = lsc_usb_hw_init(usb_dev);
    if (status != LSC_SUCCESS) {
        LSC_USB("Hw Initialization Failed.\r\n");
        return LSC_FAIL;
    }

    reg_val = lsc_usb_read_hw_params(usb_dev, 3);
    LSC_USB("HWPARAM3: %x\r\n", reg_val);
    LSC_USB("num_of_eps: %x\r\n", LSC_NUM_EPS(reg_val));

    usb_dev->num_in_eps = LSC_NUM_IN_EPS(reg_val);  //Including EP0 IN
    LSC_USB("num_in_eps: %x\r\n", usb_dev->num_in_eps);

    usb_dev->num_out_eps = LSC_NUM_EPS(reg_val) - usb_dev->num_in_eps; // Including EP0 IN & OUT
    LSC_USB("num_out_eps: %x\r\n", usb_dev->num_out_eps);

    lsc_usb_initialize_eps(usb_dev);    //Initialize endpoints

    lsc_usb_evt_buf_setup(usb_dev);     //Initialize event buffer

    lsc_usb_set_mode(usb_dev, LSC_GCTL_PRTCAP_DEVICE); //Set mode to Device mode.

    lsc_usb_set_speed(usb_dev, LSC_DCFG_FULLSPEED2 /*LSC_DCFG_HIGHSPEED*/);

    lsc_usb_set_dev_add(usb_dev, 0);

    lsc_usb_enable_ctrl_ep(usb_dev, USB_EP0_MAX_PKT_SZ);

    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * Initializes Endpoints. All OUT endpoints are even numbered and all IN
 * endpoints are odd numbered. EP0 is for Control OUT and EP1 is for
 * Control IN.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   None.
 *
 * @note     This function just initializes physial endpoint structure
 *           with default values of endpoint number, its direction and
 *           resource index as per OUT/IN endpoints specified in GHWPARAMS3.
 ****************************************************************************/
void lsc_usb_initialize_eps (struct lsc_usb_dev *usb_dev)
{
    LSC_USB("lsc_usb_initialize_eps\r\n");

    uint8_t i = 0, ep_num = 0;

    for (i = 0; i < usb_dev->num_out_eps; i++) {
        ep_num = (i << 1) | LSC_EP_DIR_OUT;
        usb_dev->eps[ep_num].phy_ep_num = ep_num;
        usb_dev->eps[ep_num].ep_direction = LSC_EP_DIR_OUT;
        usb_dev->eps[ep_num].resource_index = 0;
    }

    for (i = 0; i < usb_dev->num_in_eps; i++) {
        ep_num = (i << 1) | LSC_EP_DIR_IN;
        usb_dev->eps[ep_num].phy_ep_num = ep_num;
        usb_dev->eps[ep_num].ep_direction = LSC_EP_DIR_IN;
        usb_dev->eps[ep_num].resource_index = 0;
    }
}

/*****************************************************************************/
/**
 * Sets mode of Core to USB Device/Host/OTG.
 * This fuction sets Port Capability Direction into GCTL register.
 *
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    mode is mode to set
 *           - LSC_GCTL_PRTCAP_OTG
 *           - LSC_GCTL_PRTCAP_HOST
 *           - LSC_GCTL_PRTCAP_DEVICE
 *
 * @return   None

 ******************************************************************************/
void lsc_usb_set_mode (struct lsc_usb_dev *usb_dev, uint32_t mode)
{
    LSC_USB("lsc_usb_set_mode: %x\r\n", mode);

    uint32_t reg_val;

    reg_val = lsc_32_read(usb_dev->base_add + LSC_GCTL);

    reg_val &= ~(LSC_GCTL_PRTCAPDIR(LSC_GCTL_PRTCAP_OTG));
    reg_val |= LSC_GCTL_PRTCAPDIR(mode);

    lsc_32_write((usb_dev->base_add + LSC_GCTL), reg_val);
}

/****************************************************************************/
/**
 *
 * @brief
 * Starts the controller so that Host can detect this device.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *
 * @note     Refer Bit 31 (RUN_STOP) of Device Control Register
 *****************************************************************************/
void lsc_usb_start (struct lsc_usb_dev *usb_dev)
{
    LSC_USB("lsc_usb_start\r\n");

    uint32_t reg_val;

    reg_val = lsc_32_read(usb_dev->base_add + LSC_DCTL);

    reg_val |= LSC_DCTL_RUN_STOP;   //Start usb controller

    lsc_32_write((usb_dev->base_add + LSC_DCTL), reg_val);
}

/****************************************************************************/
/**
 *
 * @brief
 * Stops the controller so that Device disconnects from Host.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   LSC_SUCCESS else LSC_FAIL
 *
 * @note     Refer Bit 31 (RUN_STOP) of Device Control Register
 *****************************************************************************/
int32_t lsc_usb_stop (struct lsc_usb_dev *usb_dev)
{
    LSC_USB("lsc_usb_stop\r\n");

    uint32_t reg_val;

    reg_val = lsc_32_read(usb_dev->base_add + LSC_DCTL);
    reg_val &= ~LSC_DCTL_RUN_STOP;

    lsc_32_write((usb_dev->base_add + LSC_DCTL), reg_val);

    //Wait till DEVCTRLHLT resets to 0. When this bit is 1, no events will be generated.
    while (lsc_32_read(usb_dev->base_add + LSC_DSTS) & LSC_DSTS_DEVCTRLHLT)
        ;

    return LSC_SUCCESS;
}

/****************************************************************************/
/**
 * Gets current State of USB Link
 *
 * @param   usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return  Link State
 *
 * @note    This function returns current USB Link State
 *          by reading Device Status Register.
 ****************************************************************************/
uint8_t lsc_usb_get_link_state (struct lsc_usb_dev *usb_dev)
{
    LSC_USB("lsc_usb_get_link_state\r\n");

    uint32_t reg_val;

    reg_val = lsc_32_read(usb_dev->base_add + LSC_DSTS);

    return LSC_DSTS_USBLNKST(reg_val);
}

/****************************************************************************/
/**
 * Sets USB Link to a particular State
 *
 * @param   usb_dev is a pointer to the lsc_usb_dev instance.
 * @param   state is State of Link to set.
 *
 * @return  LSC_SUCCESS else LSC_FAIL
 ****************************************************************************/
uint32_t lsc_usb_set_link_state (struct lsc_usb_dev *usb_dev,
        lsc_usb_link_state_change state)
{
    LSC_USB("lsc_usb_set_link_state\r\n");

    uint32_t reg_val;

    /* Wait until device controller is ready. */
    while (lsc_32_read(usb_dev->base_add + LSC_DSTS) & LSC_DSTS_DCNRD)
        ;

    reg_val = lsc_32_read(usb_dev->base_add + LSC_DCTL);
    reg_val &= ~LSC_DCTL_ULSTCHNGREQ_MASK;

    reg_val |= LSC_DCTL_ULSTCHNGREQ(state);
    lsc_32_write((usb_dev->base_add + LSC_DCTL), reg_val);
    //LSC_USB("--\r\n");
    return LSC_SUCCESS;
}

/** @} */
