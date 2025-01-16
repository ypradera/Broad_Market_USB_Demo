/****************************************************************************/
/**
 *
 * @file lsc_usb_dev.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"


//#define DEBUG_LSC_USB_DEV

#ifdef DEBUG_LSC_USB_DEV
#define LSC_USB_DEV(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_USB_DEV(msg, ...)
#endif

/*****************************************************************************/
/**
 * @brief
 * This function Initializes Controller.
 *
 * @param  usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return
 *       - LSC_SUCCESS if initialization was successful
 *       - LSC_FAIL if initialization was not successful
 *
 * @note    This function performs PHY reset and updates Global Core
 *          Control Register (GCTL) based on LSC_GHWPARAMS1 values.<br>
 *******************************************************************************/
uint8_t lsc_usb_hw_init (struct lsc_usb_dev *usb_dev)
{
    LSC_USB_DEV("lsc_usb_hw_init\r\n");

    uint32_t reg_val = 0, hw_params1 = 0;

    //Reset the device core by setting LSC_DCTL_CSFTRST = 1 and poll till it becomes 0.
    lsc_32_write((usb_dev->base_add + LSC_DCTL),
            (LSC_DCTL_CSFTRST | LSC_DCTL_LPM_NYET_THRES));

    while (lsc_32_read(usb_dev->base_add + LSC_DCTL) & LSC_DCTL_CSFTRST)
        ;

    //USB ID Register
    LSC_USB_DEV("USB ID: %x\r\n",
            lsc_32_read(usb_dev->base_add + LSC_GSNPSID));

    lsc_usb_phy_reset(usb_dev);

    reg_val = lsc_32_read(usb_dev->base_add + LSC_GCTL);

    //TBD
    reg_val &= ~LSC_GCTL_SCALEDOWN_MASK;
    reg_val &= ~LSC_GCTL_DISSCRAMBLE;
    reg_val &= ~LSC_GCTL_U2EXIT_LFPS;

    hw_params1 = lsc_usb_read_hw_params(usb_dev, 1);

    switch (LSC_GHWPARAMS1_EN_PWROPT(hw_params1)) {
        case LSC_GHWPARAMS1_EN_PWROPT_CLK:
            reg_val &= ~LSC_GCTL_DSBLCLKGTNG;
            break;

            //TBD
        case LSC_GHWPARAMS1_EN_PWROPT_HIB:
//            reg_val = LSC_GCTL_GBLHIBERNATIONEN;
            break;

        default:
            break;
    }

    lsc_32_write((usb_dev->base_add + LSC_GCTL), reg_val);

    return LSC_SUCCESS;
}

/*****************************************************************************/
/**
 * Reads data from Hardware Params Registers of Core.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance>
 * @param    reg_index is Register number to read
 *           - LSC_GHWPARAMS0
 *           - LSC_GHWPARAMS1
 *           - LSC_GHWPARAMS2
 *           - LSC_GHWPARAMS3
 *           - LSC_GHWPARAMS4
 *           - LSC_GHWPARAMS5
 *           - LSC_GHWPARAMS6
 *           - LSC_GHWPARAMS7
 *
 * @return   One of the GHWPARAMS RegValister contents.
 ******************************************************************************/
uint32_t lsc_usb_read_hw_params (struct lsc_usb_dev *usb_dev, uint8_t reg_index)
{
    //LSC_USB_DEV("lsc_usb_read_hw_params: %x\r\n", reg_index);

    uint32_t reg_val = 0;

    reg_val = lsc_32_read(
            usb_dev->base_add + (LSC_GHWPARAMS0_OFFSET + (reg_index * 4)));

    return reg_val;
}

/*****************************************************************************/
/**
 * @brief
 * This function Issues core PHY reset.
 *
 * @param   usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return  None
 *
 * @note    This function perfomrs PHY reset and updates vendor specific
 *          PHY related register.<br>
 ******************************************************************************/
void lsc_usb_phy_reset (struct lsc_usb_dev *usb_dev)
{
    LSC_USB_DEV("lsc_usb_phy_reset\r\n");

    uint32_t reg_val = 0;

    //Put Core in Reset
    lsc_32_write((usb_dev->base_add + LSC_GCTL), LSC_GCTL_CORESOFTRESET);

    //USB3 PHY reset
    lsc_32_write((usb_dev->base_add + LSC_GUSB3PIPECTL(0)),
            (LSC_GUSB3PIPECTL_PHYSOFTRST | LSC_GUSB3PIPECTL_REQ_P1P2P3
                    | LSC_GUSB3PIPECTL_DELAYP1TRANS
                    | LSC_GUSB3PIPECTL_DELAYP1P2P3
                    | LSC_GUSB3PIPECTL_SS_TX_DE_EMPHASIS));

    //USB2 PHY reset
    lsc_32_write((usb_dev->base_add + LSC_GUSB2PHYCFG(0)),
            (LSC_GUSB2PHYCFG_PHYSOFTRST | LSC_GUSB2PHYCFG_LSIPD_3_BIT
                    | LSC_GUSB2PHYCFG_USBTRDTIM_8_BIT_UTMI_ULPI));

    //wait for 5000us
    lsc_usb_usleep(5000);

    //Unknown register information is from lattice shared c file
    // USB 2.0 PHY Internal CSR Configuration
    // Default Value = 300
    lsc_32_write((usb_dev->base_add + 0x00018008), 0x00000700);    // 6002

//  if (EXT_CLK_EN)
//      // External Clock
//      lsc_32_write((usb_dev->base_add + 0x00018004), 0x00000100); // 6001
//  else
    // Internal Clock
    lsc_32_write((usb_dev->base_add + 0x00018004), 0x01000100);    // 6001

    // USB 3.0 PHY Internal CSR Configuration
    lsc_32_write((usb_dev->base_add + 0x00014010), 0x00060000); // 5004

    // USB 3.0 PHY External CSR Configuration
    // USB3 PHY 0xc8 to 0xcb
    lsc_32_write((usb_dev->base_add + 0x000100C8), 0x00000040); // 4032
    // USB3 PHY 0x8c to 0x8f
    lsc_32_write((usb_dev->base_add + 0x0001008C), 0x90940001); // 4023
    // USB3 PHY 0x90 to 0x93
    lsc_32_write((usb_dev->base_add + 0x00010090), 0x3f7a03d0); // 4024
    // USB3 PHY 0x94 to 0x97
    lsc_32_write((usb_dev->base_add + 0x00010094), 0x03d09000); // 4025
    // USB3 PHY 0x40 to 0x43 // Added by Pavan

//  if (EXT_CLK_EN)
//      // External Clock
//      lsc_32_write((usb_dev->base_add + 0x00010040), 0x7FE78032);  // 4010
//  else
    // Internal Clock : All Default Values : Not Required
    lsc_32_write((usb_dev->base_add + 0x00010040), 0x7FE7C032); // 4010

    //Clear USB3 PHY reset
    reg_val = lsc_32_read(usb_dev->base_add + LSC_GUSB3PIPECTL(0));
    reg_val &= ~LSC_GUSB3PIPECTL_PHYSOFTRST;
    lsc_32_write((usb_dev->base_add + LSC_GUSB3PIPECTL(0)), reg_val);

    //Clear USB2 PHY reset
    reg_val = lsc_32_read(usb_dev->base_add + LSC_GUSB2PHYCFG(0));
    reg_val &= ~LSC_GUSB2PHYCFG_PHYSOFTRST;
    lsc_32_write((usb_dev->base_add + LSC_GUSB2PHYCFG(0)), reg_val);

    //wait for 5000us
    lsc_usb_usleep(5000);

    //Take Core out of reset state after PHYS are stable
    reg_val = lsc_32_read(usb_dev->base_add + LSC_GCTL);
    reg_val &= ~LSC_GCTL_CORESOFTRESET;
    lsc_32_write((usb_dev->base_add + LSC_GCTL), reg_val);
}

/*****************************************************************************/
/**
 * Sets up Event buffers so that events are written by Controller.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   None

 * @note   This function provides buffer address to the controller
 *         for writing events. Firmware will read all events from
 *         this buffer and processes it.<br>
 ****************************************************************************/
void lsc_usb_evt_buf_setup (struct lsc_usb_dev *usb_dev)
{
    LSC_USB_DEV("lsc_usb_evt_buf_setup\r\n");

    struct lsc_evt_buffer *evt;

    evt = &usb_dev->evt;
    evt->buf_add = (void*)usb_dev->event_buf;
    evt->offset = 0;
uint32_t offset=0;

offset=(uint32_t)usb_dev->event_buf;
    lsc_32_write((usb_dev->base_add + LSC_GEVNTADRLO(0)),
            (offset ));      //Lower 32-bit address [0:31]

    lsc_32_write((usb_dev->base_add + LSC_GEVNTADRHI(0)),
            ((offset ) >> 16) >> 16); //Higher 32-bit address [32-64]

    lsc_32_write((usb_dev->base_add + LSC_GEVNTSIZ(0)),
            LSC_GEVNTSIZ_SIZE(sizeof(usb_dev->event_buf))); //256 bytes event buffer

    lsc_32_write((usb_dev->base_add + LSC_GEVNTCOUNT(0)), 0);
}

/****************************************************************************/
/**
 * @brief
 * Sets speed of the Controller for connecting to Host
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    speed is required speed
 *               - LSC_DCFG_SUPERSPEED
 *               - LSC_DCFG_HIGHSPEED
 *               - LSC_DCFG_FULLSPEED2
 *               - LSC_DCFG_LOWSPEED
 *               - LSC_DCFG_FULLSPEED1
 *
 * @return   None
 *
 * @note     This function sets controller's maximum operating speed.<br>
 *****************************************************************************/
void lsc_usb_set_speed (struct lsc_usb_dev *usb_dev, uint32_t speed)
{
    LSC_USB_DEV("lsc_usb_set_speed: %x\r\n", speed);

    uint32_t reg_val;

    reg_val = lsc_32_read(usb_dev->base_add + LSC_DCFG);

    reg_val &= ~LSC_DCFG_SPEED_MASK;
    reg_val |= speed;

    lsc_32_write((usb_dev->base_add + LSC_DCFG), reg_val);
}

/****************************************************************************/
/**
 * @brief
 * Sets Device Address of the Controller
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    add is address to set.
 *
 * @return   None.
 *
 * @note     This function sets address of the controller.<br>
 *****************************************************************************/
void lsc_usb_set_dev_add (struct lsc_usb_dev *usb_dev, uint16_t add)
{
    LSC_USB_DEV("lsc_usb_set_dev_add: %x\r\n", add);

    uint32_t reg_val;

    usb_dev->dev_state = LSC_STATE_ADDRESS;

    reg_val = lsc_32_read(usb_dev->base_add + LSC_DCFG);

    reg_val &= ~LSC_DCFG_DEVADDR_MASK;
    reg_val |= LSC_DCFG_DEVADDR(add);

    lsc_32_write((usb_dev->base_add + LSC_DCFG), reg_val);
}

/*****************************************************************************/
/**
 * @brief
 * API for Sleep routine.
 *
 * @param    useconds is time in MilliSeconds.
 *
 * @return   None.
 *
 * @note     None.
 ******************************************************************************/
void lsc_usb_usleep (uint32_t useconds)
{
//    LSC_USB_DEV("lsc_usb_sleep\r\n");

    uint32_t val, count;
    timer_reg_p base = (timer_reg_p) TIMER0_INST_BASE_ADDR;

    count = 1 + useconds * (SYSCLK_KHZ / 1000); // to avoid overflow, dont allow delay too long time

    base->cnt_l = 1;
    base->cnt_h = 0;
//  base->cmp_l = count + 1;
//  base->cmp_h = 0;

    do {
        val = base->cnt_l;
    } while (val < count);
}

/****************************************************************************/
/**
 * @brief
 * Read Device Status Register.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   None.
 *****************************************************************************/
void lsc_read_dev_status_reg (struct lsc_usb_dev *usb_dev)
{
//  LSC_USB_DEV("lsc_read_dev_status_reg\r\n");

    uint32_t reg_val = 0;

    reg_val = lsc_32_read(usb_dev->base_add + LSC_DSTS);

    LSC_USB_DEV("Dev_Sts: %x\r\n", reg_val);

    if (reg_val & LSC_DSTS_CONNECTSPD) {
        if ((reg_val & LSC_DSTS_CONNECTSPD) == LSC_DSTS_SUPERSPEED){
            LSC_USB_DEV("Super Speed Device\r\n");

        }else if ((reg_val & LSC_DSTS_CONNECTSPD) == LSC_DSTS_HIGHSPEED){
            LSC_USB_DEV("High Speed Device\r\n");

        }else if ((reg_val & LSC_DSTS_CONNECTSPD) == LSC_DSTS_FULLSPEED2)
            LSC_USB_DEV("Full Speed Device\r\n");

    }

    if (reg_val & LSC_DSTS_SOFFN_MASK) {
        LSC_USB_DEV("SOFN: %x\r\n", LSC_DSTS_SOFFN(reg_val));
    }

    if (reg_val & LSC_DSTS_RXFIFOEMPTY) {
        LSC_USB_DEV("RXFIFO Empty\r\n");
    }

    if (reg_val & LSC_DSTS_USBLNKST_MASK) {
        LSC_USB_DEV("USB/Link State\r\n");

        if (usb_dev->dev_speed == LSC_SPEED_SUPER) {
            LSC_USB_DEV("LTSSM State\r\n");
        } else {
            LSC_USB_DEV("HS/FS State\r\n");

            switch (LSC_DSTS_USBLNKST(reg_val & LSC_DSTS_USBLNKST_MASK)) {
                case 0:
                    LSC_USB_DEV("On State\r\n");

                    break;

                case 2:
                    LSC_USB_DEV("Sleep (L1) State\r\n");

                    break;

                case 3:
                    LSC_USB_DEV("Suspend (L2) State\r\n");
                    usb_dev->l2_suspend = 1;
                    break;

                case 4:
                    LSC_USB_DEV("Disconnected State (Default State)\r\n");

                    break;

                case 5:
                    LSC_USB_DEV("Early Suspend State\r\n");

                    break;

                case 14:
                    LSC_USB_DEV("Reset State\r\n");

                    break;

                case 15:
                    LSC_USB_DEV("Resume state\r\n");

                    break;

                default:
                    LSC_USB_DEV("Invalid HS/FS State\r\n");

                    break;
            }
        }
    }

    if (reg_val & LSC_DSTS_DEVCTRLHLT) {
        LSC_USB_DEV("Device Controller Halted\r\n");
    }

    if (reg_val & LSC_DSTS_COREIDLE) {
        LSC_USB_DEV("Core Idle\r\n");
    }

    if (reg_val & LSC_DSTS_SSS) {
        LSC_USB_DEV("SSS Save State Status\r\n");
    }

    if (reg_val & LSC_DSTS_RSS) {
        LSC_USB_DEV("RSS Restore State Status\r\n");
    }

    if (reg_val & LSC_DSTS_DCNRD) {
        LSC_USB_DEV("Device Controller Not Ready\r\n");
    }
}

/** @} */
