/****************************************************************************/
/**
 *
 * @file lsc_usb_ch9.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"
#include "lsc_usb_ch9.h"
#include "lsc_usb_desc.h"

#define DEBUG_LSC_USB_CH9

#ifdef DEBUG_LSC_USB_CH9
#define LSC_USB_CH9(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_USB_CH9(msg, ...)
#endif

volatile uint32_t maxpktsz = 0, interval = 0, maxburst = 0, bytes_interval = 0,
        attribute = 0, ep_attribute = 0;
uint8_t *reponse_p=NULL;
uint8_t v_buf[VENDOR_REQ_MAX_SIZE] __attribute__ ((aligned(32)));
void process_usb_std_req (struct lsc_usb_dev *usb_dev, setup_pkt *setup_pkt);
void process_usb_cs_req (struct lsc_usb_dev *usb_dev, setup_pkt *setup_pkt);
void process_usb_vendor_req (struct lsc_usb_dev *usb_dev, setup_pkt *setup_pkt);

/*****************************************************************************/
/**
 * This function handles a Setup packet from the host and calls corresponding
 * USB request processing based on bRequestType field of setup data.
 *
 * @param    usb_dev is a pointer to lsc_usb_dev instance of the controller.
 * @param    setup_pkt is the structure containing the setup request.
 *
 * @return   None.
 *
 * @note     None.
 ******************************************************************************/
void lsc_usb_setup_pkt_process (struct lsc_usb_dev *usb_dev,
        setup_pkt *setup_pkt)
{
    LSC_USB_CH9("lsc_usb_setup_pkt_process\r\n");

    switch (setup_pkt->bRequestType & USB_REQ_TYPE_MASK) {
        case USB_CMD_STDREQ:
            LSC_USB_CH9("Standard Request\r\n");
            process_usb_std_req(usb_dev, setup_pkt);
            break;

        case USB_CMD_CLASSREQ:
            LSC_USB_CH9("Class Specific Request\r\n");
            //Class Request handling function in
            //particular class driver file
            process_usb_cs_req(usb_dev, setup_pkt);
            break;

        case USB_CMD_VENDREQ:
            LSC_USB_CH9("Process Vendor Specific Request\r\n");
            //Vendor Request handling function
            process_usb_vendor_req(usb_dev, setup_pkt);
            break;

        default:
            LSC_USB_CH9("Invalid bRequestType\r\n");
            /* Stall on Endpoint 0 */
            lsc_usb_ep0_stall_restart(usb_dev);
            break;
    }
}

/*****************************************************************************/
/**
 * This function handles usb device standard requests.
 *
 * @param    usb_dev is a pointer to lsc_usb_dev instance.
 * @param    setup_pkt is a pointer to the data structure containing the
 *           setup request.
 *
 * @return   None.
 *
 * @note     None.
 ******************************************************************************/
void process_usb_std_req (struct lsc_usb_dev *usb_dev, setup_pkt *setup_pkt)
{
//    LSC_USB_CH9("process_usb_std_req\r\n");

    uint8_t res_buf[6] __attribute__ ((aligned(32)));

    uint8_t error = 0, status = 0;
    uint32_t resp_len = 0;

    USB_COMMON_DESCRIPTOR *desc;
    USB_STD_DEV_DESC *dev_desc;
    USB_STD_CFG_DESC *config_desc;

    uint8_t *str;
    uint32_t str_len;
    uint8_t temp_s[128], index = 0;
    USB_STD_STRING_DESC *str_desc;

    uint8_t *ptr;
    uint32_t temp = 0, lenth = 0, len = 0, ifn = 0, alt = 0, size = 0, old = 0;

    uint8_t ep_num = setup_pkt->wIndex & USB_ENDPOINT_NUMBER_MASK;
    /*
     * Direction -- USB_EP_DIR_IN or USB_EP_DIR_OUT
     */
    uint8_t dir = !!(setup_pkt->wIndex & USB_ENDPOINT_DIR_MASK);

    /* Check that the requested reply length is not bigger than our reply
     * buffer. This should never happen...
     */
    if (setup_pkt->wLength > 1024) {
        return;
    }

    LSC_USB_CH9("Setup Pkt: %x %x %2x %2x %2x\r\n", setup_pkt->bRequestType,
            setup_pkt->bRequest, setup_pkt->wValue, setup_pkt->wIndex,
            setup_pkt->wLength);

    switch (setup_pkt->bRequest) {
        case USB_REQ_GET_STATUS:

            switch (setup_pkt->bRequestType & USB_RECIPIENT_MASK) {
                case USB_RECIPIENT_DEVICE:
                    LSC_USB_CH9("GET STATUS DEVICE\r\n\n");

                    if (usb_dev->dev_speed == LSC_SPEED_SUPER) {
//                        LSC_USB_CH9("GET STATUS DEVICE: SS\r\n");

                        ptr = (uint8_t*)&u30_config_desc;
                    } else {
                        if ((usb_dev->dev_speed == LSC_SPEED_HIGH)) {
                            //LSC_USB_CH9("GET STATUS DEVICE: HS\r\n");

                            ptr = (uint8_t*)&u20_config_desc_hs;
                        } else {
                            //LSC_USB_CH9("GET STATUS DEVICE: FS\r\n");

                            ptr = (uint8_t*)&u20_config_desc_fs;
                        }

                        if (((USB_STD_CFG_DESC*)ptr)->bAttributes
                                & USB_CONFIG_SELF_POWERED)
                            *((uint16_t*)&res_buf[0]) = 0x1;

                        if (((USB_STD_CFG_DESC*)ptr)->bAttributes
                                & USB_CONFIG_REMOTE_WAKEUP)
                            *((uint16_t*)&res_buf[0]) |= usb_dev->wakeup_selfpowered;

                        //printf("data: %x\r\n", res_buf[0]);
                    }

                    break;

                case USB_RECIPIENT_INTERFACE:

                    LSC_USB_CH9("GET STATUS INTERFACE\r\n\n");

                    *((uint16_t*)&res_buf[0]) = 0x0;

                    break;

                case USB_RECIPIENT_ENDPOINT:

                    LSC_USB_CH9("GET STATUS ENDPOINT\r\n\n");

                    *((uint16_t*)&res_buf[0]) = lsc_usb_is_ep_stalled(usb_dev,
                            ep_num, dir);

                    break;

                default:

                    LSC_USB_CH9("unknown request for status %x\r\n\n",
                            setup_pkt->bRequestType);

                    lsc_usb_ep0_stall_restart(usb_dev);

                    return;
            }

            lsc_usb_ep0_send(usb_dev, res_buf, setup_pkt->wLength);

            break;

        case USB_REQ_SET_ADDRESS:

            LSC_USB_CH9("SET ADDRESS: %d\r\n\n", setup_pkt->wValue);

            if ((setup_pkt->bRequestType & USB_RECIPIENT_MASK)
                    != USB_RECIPIENT_DEVICE) {
                LSC_USB_CH9("SET ADDRESS: != USB_RECIPIENT_DEVICE\r\n\n");

                lsc_usb_ep0_stall_restart(usb_dev);

                return;
            }

            /* With bit 24 set the address value is held in a shadow
             * register until the status phase is acked. At which point it
             * address value is written into the address register.
             */
            lsc_usb_set_dev_add(usb_dev, setup_pkt->wValue);

            break;

        case USB_REQ_GET_INTERFACE:

            LSC_USB_CH9("GET INTERFACE: %x\r\n\n", setup_pkt->wIndex);

            if ((setup_pkt->bRequestType & USB_RECIPIENT_MASK)
                    != USB_RECIPIENT_INTERFACE) {
                lsc_usb_ep0_stall_restart(usb_dev);

                return;
            }

            if ((usb_dev->usb_configuration != 0)
                    && (setup_pkt->wIndex < usb_dev->usb_num_interface)) {
                res_buf[0] = usb_dev->usb_alt_set[setup_pkt->wIndex];

                lsc_usb_ep0_send(usb_dev, res_buf, setup_pkt->wLength);

            } else {
                lsc_usb_ep0_stall_restart(usb_dev);

                return;
            }

            break;

        case USB_REQ_GET_DESCRIPTOR:

            switch (setup_pkt->bRequestType & USB_RECIPIENT_MASK) {
                case USB_RECIPIENT_DEVICE:

//                      LSC_USB_CH9("REQUEST TO DEVICE\r\n");
                {
                    /* Get descriptor type. */
                    switch ((setup_pkt->wValue >> 8) & 0xff) {

                        case USB_TYPE_DEVICE_DESC:

                            LSC_USB_CH9("GET DEV DESC\r\n\n");

                            resp_len =
                                    setup_pkt->wLength
                                            > sizeof(USB_STD_DEV_DESC) ?
                                            sizeof(USB_STD_DEV_DESC) :
                                            setup_pkt->wLength;

                            if (usb_dev->dev_speed == LSC_SPEED_SUPER)
                                lsc_usb_ep0_send(usb_dev,
                                        (uint8_t*)&u30_device_desc, resp_len);
                            else
                                lsc_usb_ep0_send(usb_dev,
                                        (uint8_t*)&u20_device_desc, resp_len);

                            break;

                        case USB_TYPE_CONFIG_DESC:

                            LSC_USB_CH9("GET CONFIG DESC\r\n\n");

                            if (usb_dev->dev_speed == LSC_SPEED_SUPER) {
                                dev_desc = &u30_device_desc;
                                config_desc =
                                        (USB_STD_CFG_DESC*)&u30_config_desc;
                                ptr = (uint8_t*)&u30_config_desc;
                            } else if (usb_dev->dev_speed == LSC_SPEED_HIGH) {
                                dev_desc = &u20_device_desc;
                                config_desc =
                                        (USB_STD_CFG_DESC*)&u20_config_desc_hs;
                                ptr = (uint8_t*)&u20_config_desc_hs;
                            } else {
                                dev_desc = &u20_device_desc;
                                config_desc =
                                        (USB_STD_CFG_DESC*)&u20_config_desc_fs;
                                ptr = (uint8_t*)&u20_config_desc_fs;
                            }

                            /**************************************************
                             * Below condition verifies, if requested
                             * configuration descriptor using config index
                             * is greater than bNumConfigurations specified
                             * in device descriptor, then it should be stalled
                             ***************************************************/
                            if (dev_desc->bNumConfigurations
                                    < ((setup_pkt->wValue & 0x00FF) + 1)) {
                                lsc_usb_ep0_stall_restart(usb_dev);

                                return;
                            }

                            //Selects configuration descriptor as per requested by host
                            for (uint32_t n = 0;
                                    n != (setup_pkt->wValue & 0x000000ff); n++)
                                config_desc += config_desc->wTotalLength;

                            if (config_desc->bLength == 0) {
                                lsc_usb_ep0_stall_restart(usb_dev);

                                return;
                            }

                            if (setup_pkt->wLength == sizeof(USB_STD_CFG_DESC))
                                lsc_usb_ep0_send(usb_dev, (uint8_t*)ptr,
                                        sizeof(USB_STD_CFG_DESC));
                            else
                                lsc_usb_ep0_send(usb_dev,(uint8_t*)ptr,
                                        config_desc->wTotalLength);

                            break;

                        case USB_TYPE_STRING_DESC:

                            LSC_USB_CH9("GET STRING DESC: %x\r\n\n",
                                    (setup_pkt->wValue & 0xFF));

                            index = setup_pkt->wValue & 0xFF;

                            if (index
                                    >= (sizeof(string_desc) / sizeof(uint8_t*))) {
                                LSC_USB_CH9("Invalid String Index\r\n\n");

                                lsc_usb_ep0_stall_restart(usb_dev);

                                return;
                            }

                            str = (char*)&string_desc[index];

                            str_len = strlen(str);

                            str_desc = (USB_STD_STRING_DESC*)temp_s;

                            /* Index 0 is special as we can not represent the string required in
                             * the table above. Therefore we handle index 0 as a special case.
                             */
                            if (index == 0) {
                                str_desc->bLength = 4;
                                str_desc->bDescriptorType =
                                        USB_TYPE_STRING_DESC;
                                str_desc->wLANGID[0] = 0x0409;
                            }
                            /* All other strings can be pulled from the table above. */
                            else {
                                str_desc->bLength = (str_len * 2) + 2;
                                str_desc->bDescriptorType =
                                        USB_TYPE_STRING_DESC;

                                for (uint32_t i = 0; i < str_len; i++) {
                                    str_desc->wLANGID[i] = (uint16_t)str[i];
                                }
                            }

                            resp_len =
                                    setup_pkt->wLength > str_desc->bLength ?
                                            str_desc->bLength :
                                            setup_pkt->wLength;

                            lsc_usb_ep0_send(usb_dev,
                                    (uint8_t*)&str_desc[0], resp_len);

                            break;

                        case USB_TYPE_DEVICE_QUALIFIER:

                            LSC_USB_CH9("GET DEV QUALIFIER DESC\r\n\n");

                            resp_len =
                                    setup_pkt->wLength
                                            > sizeof(USB_STD_DEV_QUALIFIER_DESC) ?
                                            sizeof(USB_STD_DEV_QUALIFIER_DESC) :
                                            setup_pkt->wLength;

                            lsc_usb_ep0_send(usb_dev,
                                    (uint8_t*)&device_qual_desc, resp_len);

                            break;

                        case OSD_TYPE_CONFIG_DESCR:

                            LSC_USB_CH9("GET OTHER SPEED CONFIG DESC\r\n\n");

                            if (usb_dev->dev_speed == LSC_SPEED_HIGH) {
                                resp_len =
                                        setup_pkt->wLength
                                                > sizeof(LSC_USB20_CFG_DESC) ?
                                                sizeof(LSC_USB20_CFG_DESC) :
                                                setup_pkt->wLength;
                                lsc_usb_ep0_send(usb_dev,
                                        (uint8_t*)&u20_oth_speed_cfg_desc_fs,
                                        resp_len);
                            } else {
                                resp_len =
                                        setup_pkt->wLength
                                                > sizeof(LSC_USB20_CFG_DESC) ?
                                                sizeof(LSC_USB20_CFG_DESC) :
                                                setup_pkt->wLength;
                                lsc_usb_ep0_send(usb_dev,
                                        (uint8_t*)&u20_oth_speed_cfg_desc_hs,
                                        resp_len);
                            }

                            break;

                        case USB_TYPE_BOS_DESC:

                            LSC_USB_CH9("GET BOS DESC\r\n\n");

                            resp_len =
                                    setup_pkt->wLength > sizeof(bos_desc) ?
                                            sizeof(bos_desc) :
                                            setup_pkt->wLength;

                            lsc_usb_ep0_send(usb_dev,(uint8_t*)&bos_desc,
                                    resp_len);

                            break;

                        default:

                            LSC_USB_CH9(
                                    "unknown request for Get Descriptor\r\n\n");

                            lsc_usb_ep0_stall_restart(usb_dev);

                            return;
                    }
                }
                    break;

                case USB_RECIPIENT_INTERFACE:

                    LSC_USB_CH9("REQUEST TO INTERFACE\r\n\n");

                    break;

                case USB_RECIPIENT_ENDPOINT:

                    LSC_USB_CH9("REQUEST TO ENDPOINT\r\n\n");

                    break;

                default:

                    LSC_USB_CH9("unknown request for Reciepient\r\n\n");

                    lsc_usb_ep0_stall_restart(usb_dev);

                    return;
            }
            break;

        case USB_REQ_SET_CONFIGURATION:

            LSC_USB_CH9("SET CONFIG: %x\r\n\n", (setup_pkt->wValue & 0xFF));

            usb_dev->is_config_done = 0;

            if (setup_pkt->wIndex != 0) //for set config Index should be zero if not then stall EP0
                    {
                lsc_usb_ep0_stall_restart(usb_dev);

                return;
            }

            if (usb_dev->dev_speed == LSC_SPEED_SUPER) {
                desc = (USB_COMMON_DESCRIPTOR*)&u30_config_desc;
                size = sizeof(LSC_USB30_CFG_DESC);
            } else if (usb_dev->dev_speed == LSC_SPEED_HIGH) {
                desc = (USB_COMMON_DESCRIPTOR*)&u20_config_desc_hs;
                size = sizeof(LSC_USB20_CFG_DESC);
            } else {
                desc = (USB_COMMON_DESCRIPTOR*)&u20_config_desc_fs;
                size = sizeof(LSC_USB20_CFG_DESC);
            }

            if (setup_pkt->wValue & 0xFF) {
                while (1) {
                    switch (((USB_COMMON_DESCRIPTOR*)desc)->bDescriptorType) {
                        case USB_TYPE_CONFIG_DESC: {
                            temp = ((USB_STD_CFG_DESC*)desc)->bConfigValue;

                            if (temp == (setup_pkt->wValue & 0x000000FF)) {
                                usb_dev->usb_configuration = (setup_pkt->wValue
                                        & 0x000000FF);

                                usb_dev->usb_num_interface =
                                        ((USB_STD_CFG_DESC*)desc)->bNumberInterfaces;

                                for (uint32_t n = 0; n < USB_IF_NUM; n++)
                                    usb_dev->usb_alt_set[n] = 0;

                                /**************************
                                 * Configure Device Status
                                 **************************/
                                temp = ((USB_STD_CFG_DESC*)desc)->bAttributes;

                                if (temp & USB_CONFIG_SELF_POWERED)
                                    usb_dev->wakeup_selfpowered |=
                                            DEVICE_STATUS_REMOTE_WAKEUP_SELF_POWERED_01_VALUE;
                                else
                                    usb_dev->wakeup_selfpowered &=
                                            ~DEVICE_STATUS_REMOTE_WAKEUP_SELF_POWERED_01_VALUE;
                            } else {
                                temp = ((USB_STD_CFG_DESC*)desc)->wTotalLength;
                                lenth += temp;
                                len = ((unsigned int)desc) + temp;
                                desc = (USB_COMMON_DESCRIPTOR*)len;

                                continue;
                            }
                            break;
                        }

                        case USB_TYPE_INTERFACE_DESC: {
                            alt = ((USB_STD_IF_DESC*)desc)->bAlternateSetting;
                            break;
                        }

                        case USB_TYPE_ENDPOINT_CFG_DESC: {

                            ptr = (unsigned char*)desc;

                            temp = ((USB_STD_EP_DESC*)desc)->bEndpointAddress;

                            ep_attribute =
                                    ((USB_STD_EP_DESC*)desc)->bmAttributes;

                            maxpktsz = ((USB_STD_EP_DESC*)desc)->bMaxPacketSize;
                            interval = ((USB_STD_EP_DESC*)desc)->bInterval;

                            if ((usb_dev->dev_speed == LSC_SPEED_SUPER)
                                    && ((ep_attribute
                                            & LSC_ENDPOINT_XFERTYPE_MASK)
                                            == LSC_ENDPOINT_XFER_ISOC)) {
                                maxburst =
                                        ((USB_STD_EP_SS_COMP_DESC*)(ptr + 7))->bMaxBurst;
                                attribute =
                                        ((USB_STD_EP_SS_COMP_DESC*)(ptr + 7))->bmAttributes;

                                bytes_interval = ((USB_STD_EP_SS_COMP_DESC*)(ptr
                                        + 7))->wBytesPerInterval;
                            }

                            if (alt == 0) {
//                              printf("++++++\r\n");
                                //Enable Eps
                                lsc_usb_ep_enable(usb_dev,
                                        (temp & USB_ENDPOINT_NUMBER_MASK),
                                        ((temp & USB_ENDPOINT_DIR_MASK) >> 7),
                                        maxpktsz,
                                        (ep_attribute
                                                & LSC_ENDPOINT_XFERTYPE_MASK),
                                        false);

                                unsigned char dir =
                                        ((temp & USB_ENDPOINT_DIR_MASK) >> 7);
                                unsigned int ep_num = (temp & USB_ENDPOINT_NUMBER_MASK);
//                              printf("ep_num:%x dir:%x\r\n",ep_num,dir);
//                              printf("maxpktsz:%x\r\n",maxpktsz);

                                //Here we are initiating first Bulk In and OUT TRB for respective endpoint.
                                //So, that if host places requests device able to serve it immidiately.
                                //TRB's for Next transfers will be filled after getting transsfer complete
                                //event from lsc_usb_ep_xfer_cmplt().

                                struct lsc_ep *ep;
                                uint8_t phy_ep_num;
                                phy_ep_num = lsc_physicalep(ep_num, dir);
                                ep = &usb_dev->eps[phy_ep_num];
                                if (ep->handler != NULL) {
                                    ep->handler(usb_dev,ep_num, maxpktsz);
                                }
                            }

                            break;
                        }

                        default:
                            break;
                    }
                    temp = desc->bLength;
                    lenth += temp;
                    len = ((unsigned int)desc) + temp;
                    desc = (USB_COMMON_DESCRIPTOR*)len;

                    if (lenth >= size) {
                        break;
                    }
                }//end of while
                usb_dev->is_config_done = 1;
                usb_dev->is_enum_done = 1;

                switch (usb_dev->dev_state) {
                case LSC_STATE_DEFAULT:
                    return;
                    break;

                case LSC_STATE_ADDRESS:
                    usb_dev->dev_state = LSC_STATE_CONFIGURED;
                    break;

                case LSC_STATE_CONFIGURED:
                    break;

                default:
                    lsc_usb_ep0_stall_restart(usb_dev);
                    return;

                    break;
                }
    //                printf("*******\r\n");
            } else {
                usb_dev->is_config_done = 0;
                usb_dev->dev_state = LSC_STATE_ADDRESS;

                //Disable Eps
                for (uint32_t i = 1; i < usb_dev->num_in_eps; i++)
                    lsc_usb_ep_disable(usb_dev, i, LSC_EP_DIR_IN);

                for (uint32_t i = 1; i < usb_dev->num_out_eps; i++)
                    lsc_usb_ep_disable(usb_dev, i, LSC_EP_DIR_OUT);
            }

            break;

        case USB_REQ_GET_CONFIGURATION:

            LSC_USB_CH9("GET CONFIGURATION\r\n\n");

            if ((setup_pkt->bRequestType & USB_RECIPIENT_MASK)
                    != USB_RECIPIENT_DEVICE) {
                lsc_usb_ep0_stall_restart(usb_dev);
                return;
            }

            switch (usb_dev->dev_state) {
                case LSC_STATE_DEFAULT:
                case LSC_STATE_ADDRESS:
                    *((uint8_t*)&res_buf[0]) = 0;

                    break;

                case LSC_STATE_CONFIGURED:
                    *((uint8_t*)&res_buf[0]) = usb_dev->usb_configuration;

                    break;

                default:
                    lsc_usb_ep0_stall_restart(usb_dev);

                    return;
            }

            lsc_usb_ep0_send(usb_dev, res_buf, setup_pkt->wLength);

            break;

        case USB_REQ_CLEAR_FEATURE:

            LSC_USB_CH9("CLEAR FEATURE\r\n\n");

            switch (setup_pkt->bRequestType & USB_RECIPIENT_MASK) {
                case USB_RECIPIENT_DEVICE:
                    if (usb_dev->dev_speed == LSC_SPEED_SUPER) {
                        if (setup_pkt->wValue == USB_U1_ENABLE) {
                            //Disable U1 Sleep
                        } else if (setup_pkt->wValue == USB_U2_ENABLE) {
                            //Disable U2 Sleep
                        } else {
                            lsc_usb_ep0_stall_restart(usb_dev);

                            return;
                        }
                    } else {
                        /**************************
                         * check for remote wake-up
                         **************************/
                        if (setup_pkt->wValue == USB_DEVICE_REMOTE_WAKEUP) {
                            uint8_t *pD, temp;

                            if (usb_dev->dev_speed == LSC_SPEED_HIGH)
                                pD = (char*)&u20_config_desc_hs;
                            else if (usb_dev->dev_speed == LSC_SPEED_FULL)
                                pD = (char*)&u20_config_desc_fs;

                            temp = ((USB_STD_CFG_DESC*)pD)->bAttributes;

                            if (temp & USB_CONFIG_REMOTE_WAKEUP)
                                usb_dev->wakeup_selfpowered &=
                                        ~DEVICE_STATUS_REMOTE_WAKEUP_BUS_POWERED_10_VALUE;
                            else {
                                lsc_usb_ep0_stall_restart(usb_dev);

                                return;
                            }
                        } else {
                            lsc_usb_ep0_stall_restart(usb_dev);

                            return;
                        }
                    }

                    break;

                case USB_RECIPIENT_INTERFACE:
                    if (setup_pkt->wValue == 0) {
                        //Function Suspend
                    } else {
                        lsc_usb_ep0_stall_restart(usb_dev);

                        return;
                    }

                    break;

                case USB_RECIPIENT_ENDPOINT:
                    if (setup_pkt->wValue == USB_ENDPOINT_HALT) {
                        if (usb_dev->usb_configuration != 0) {
                            if (setup_pkt->wValue == 0) {
                                lsc_usb_ep_clear_stall(usb_dev, ep_num, dir);//remove stall feature
                            } else {
                                lsc_usb_ep0_stall_restart(usb_dev);

                                return;
                            }
                        } else {
                            lsc_usb_ep0_stall_restart(usb_dev);

                            return;
                        }
                    }
                    break;

                default:
                    lsc_usb_ep0_stall_restart(usb_dev);
                    return;

                    break;
            }
            break;

        case USB_REQ_SET_FEATURE:

            LSC_USB_CH9("SET FEATURE\r\n\n");

            switch (setup_pkt->bRequestType & USB_RECIPIENT_MASK) {
                case USB_RECIPIENT_DEVICE:

                    if (usb_dev->dev_speed == LSC_SPEED_SUPER) {
                        if (setup_pkt->wValue == USB_U1_ENABLE) {
                            //U1SleepEnable(usb_dev);
                        } else if (setup_pkt->wValue == USB_U2_ENABLE) {
                            //U2SleepEnable(usb_dev);
                        } else {
                            lsc_usb_ep0_stall_restart(usb_dev);

                            return;
                        }
                    }
                    else {
                        if (setup_pkt->wValue == USB_TEST_MODE) {
                            usb_dev->test_mode = (setup_pkt->wIndex >> 8)
                                    & 0xFF;

                            switch (usb_dev->test_mode) {
                                case LSC_TEST_J:
                                case LSC_TEST_K:
                                case LSC_TEST_SE0_NAK:
                                case LSC_TEST_PACKET:
                                case LSC_TEST_FORCE_ENABLE:

                                    usb_dev->is_test_mode = 1;

                                    break;

                                default:
                                    lsc_usb_ep0_stall_restart(usb_dev);
                                    return;

                                    break;
                            }
                        } else if (setup_pkt->wValue == USB_DEVICE_REMOTE_WAKEUP) {
                            uint8_t *pD, temp;

                             if (usb_dev->dev_speed == LSC_SPEED_HIGH)
                                 pD = (char*)&u20_config_desc_hs;
                             else if (usb_dev->dev_speed == LSC_SPEED_FULL)
                                 pD = (char*)&u20_config_desc_fs;

                             temp = ((USB_STD_CFG_DESC*)pD)->bAttributes;

                             if (temp & USB_CONFIG_REMOTE_WAKEUP)
                                 usb_dev->wakeup_selfpowered |=
                                         DEVICE_STATUS_REMOTE_WAKEUP_BUS_POWERED_10_VALUE;
                             else {
                                 lsc_usb_ep0_stall_restart(usb_dev);

                                 return;
                             }
                        } else {
                            lsc_usb_ep0_stall_restart(usb_dev);

                            return;
                        }
                    }

                    break;

                    /* When we run CV test suite application in Windows, need to
                     * add INTRF_FUNC_SUSNPEND command to pass test suite
                     */
                case USB_RECIPIENT_INTERFACE:

                    switch (setup_pkt->wValue) {
                        case USB_INTRF_FUNC_SUSPEND:
                            /* enable Low power suspend */
                            /* enable remote wakeup */
                            break;

                        default:
                            lsc_usb_ep0_stall_restart(usb_dev);
                            return;

                            break;
                    }

                    break;

                case USB_RECIPIENT_ENDPOINT:

                    if (setup_pkt->wValue == USB_ENDPOINT_HALT) {
                        if (!ep_num)
                            lsc_usb_ep0_stall_restart(usb_dev);
                        else
                            lsc_usb_ep_set_stall(usb_dev, ep_num, dir);
                    }

                    break;

                default:
                    lsc_usb_ep0_stall_restart(usb_dev);
                    return;

                    break;
            }

            break;

            /* For set interface, check the alt setting host wants */
        case USB_REQ_SET_INTERFACE:

            LSC_USB_CH9("SET INTERFACE: %x\t\talt_set: %x\r\n\n", setup_pkt->wIndex,
                    (setup_pkt->wValue & 0xFF));

            if (usb_dev->usb_configuration == 0) {
                lsc_usb_ep0_stall_restart(usb_dev);
                return;
            }

            if ((usb_dev->dev_speed == LSC_SPEED_SUPER)) {
                desc = (USB_COMMON_DESCRIPTOR*)&u30_config_desc;
                size = sizeof(LSC_USB30_CFG_DESC);
            } else if ((usb_dev->dev_speed == LSC_SPEED_HIGH)) {
                desc = (USB_COMMON_DESCRIPTOR*)&u20_config_desc_hs;
                size = sizeof(LSC_USB20_CFG_DESC);
            } else {
                desc = (USB_COMMON_DESCRIPTOR*)&u20_config_desc_fs;
                size = sizeof(LSC_USB20_CFG_DESC);
            }

            lenth = 0;

            while (1) {
                switch (desc->bDescriptorType) {
                    case USB_TYPE_CONFIG_DESC: {
                        /***************************************
                         * if there are two configuration supported
                         * by host then here pointer directly go to
                         * that location.
                         **************************************/
                        temp = ((USB_STD_CFG_DESC*)desc)->bConfigValue;

                        if (temp != usb_dev->usb_configuration) {
                            temp = ((USB_STD_CFG_DESC*)desc)->wTotalLength;
                            lenth += temp;
                            len = ((unsigned int)desc) + temp;
                            desc = (USB_COMMON_DESCRIPTOR*)len;
                            continue;
                        }
                        break;
                    }
                    case USB_TYPE_INTERFACE_DESC: {
                        /*****************************************
                         * this is main part of this standerd Request
                         * here device is getting interface no.
                         * as well as alternate settings.
                         ****************************************/
                        ifn = ((USB_STD_IF_DESC*)desc)->bInterfaceNumber;
                        alt = ((USB_STD_IF_DESC*)desc)->bAlternateSetting;

                        if ((ifn == setup_pkt->wIndex)
                                && (alt == (setup_pkt->wValue & 0x000000FF))) {
                            old = usb_dev->usb_alt_set[ifn];
                            usb_dev->usb_alt_set[ifn] = (char)alt;
                            usb_dev->usb_interface = ifn;
                        }
                        break;
                    }
                    case USB_TYPE_ENDPOINT_CFG_DESC: {
                        /*****************************************
                         * here there is requirment of interface no.
                         * & alt setting for enabling corrospondin
                         * End point
                         ****************************************/
                        temp = ((USB_STD_EP_DESC*)desc)->bEndpointAddress;

                        if (ifn == setup_pkt->wIndex) {
                            ep_attribute =
                                    ((USB_STD_EP_DESC*)desc)->bmAttributes;

                            maxpktsz = ((USB_STD_EP_DESC*)desc)->bMaxPacketSize;

                            interval = ((USB_STD_EP_DESC*)desc)->bInterval;

                            if ((usb_dev->dev_speed == LSC_SPEED_SUPER)
                                    && ((ep_attribute
                                            & LSC_ENDPOINT_XFERTYPE_MASK)
                                            == LSC_ENDPOINT_XFER_ISOC)) {
                                maxburst =
                                        ((USB_STD_EP_SS_COMP_DESC*)(desc + 7))->bMaxBurst;
                                attribute =
                                        ((USB_STD_EP_SS_COMP_DESC*)(desc + 7))->bmAttributes;

                                bytes_interval =
                                        ((USB_STD_EP_SS_COMP_DESC*)(desc + 7))->wBytesPerInterval;
                            }

                            if (alt == (setup_pkt->wValue & 0x000000FF)) {
                                //Enable Ep
                                lsc_usb_ep_enable(usb_dev,
                                        (temp & USB_ENDPOINT_NUMBER_MASK),
                                        ((temp & USB_ENDPOINT_DIR_MASK) >> 7),
                                        maxpktsz,
                                        (ep_attribute
                                                & LSC_ENDPOINT_XFERTYPE_MASK),
                                        false);
                            }
                        }

                        break;

                        default:
                        break;
                    }
                }
                temp = desc->bLength;
                lenth += temp;
                len = ((unsigned int)desc) + temp;
                desc = (USB_COMMON_DESCRIPTOR*)len;

                if (lenth >= size)
                    break;
            }

            usb_dev->dev_state = LSC_STATE_CONFIGURED;

            break;

        case USB_REQ_SET_SEL:

            LSC_USB_CH9("SET SEL \r\n\n");

            break;

        case USB_REQ_SET_ISOCH_DELAY:

            LSC_USB_CH9("SET ISOCH DELAY \r\n\n");

            break;

        default:
            LSC_USB_CH9("Invalid bRequest\r\n\n");

            lsc_usb_ep0_stall_restart(usb_dev);

            break;
    }
}

/*****************************************************************************/
/**
 * This function handles usb device class specific requests.
 *
 * @param    usb_dev is a pointer to lsc_usb_dev instance.
 * @param    setup_pkt is a pointer to the data structure containing the
 *           setup request.
 *
 * @return   None.
 *
 * @note     None.
 ******************************************************************************/
void process_usb_cs_req (struct lsc_usb_dev *usb_dev, setup_pkt *setup_pkt)
{
//  LSC_USB_CH9("process_usb_cs_req\r\n");

    /*
     * Direction -- USB_EP_DIR_IN or USB_EP_DIR_OUT
     */
    uint8_t dir = setup_pkt->bRequestType & LSC_USB_DIR_IN;

    if (dir) {
        //CS IN Request
        LSC_USB_CH9("CS IN Req\r\n");
    } else {
        //CS OUT Request
        LSC_USB_CH9("CS OUT Req\r\n");
    }
}

/*****************************************************************************/
/**
 * This function handles usb device vendor specific requests.
 *
 * @param    usb_dev is a pointer to lsc_usb_dev instance.
 * @param    setup_pkt is a pointer to the data structure containing the
 *           setup request.
 *
 * @return   None.
 *
 * @note     None.
 ******************************************************************************/
void process_usb_vendor_req (struct lsc_usb_dev *usb_dev, setup_pkt *setup_pkt)
{
//  LSC_USB_CH9("process_usb_vendor_req\r\n");

    uint32_t transfer_len = 0;
    /*
     * Direction -- USB_EP_DIR_IN or USB_EP_DIR_OUT
     */
    uint8_t dir = setup_pkt->bRequestType & LSC_USB_DIR_IN;

    LSC_USB_CH9("Setup Pkt: %x %x %2x %2x %2x\r\n", setup_pkt->bRequestType,
            setup_pkt->bRequest, setup_pkt->wValue, setup_pkt->wIndex,
            setup_pkt->wLength);

    if (dir) {
        //CS IN Request
//      LSC_USB_CH9("Vendor IN Req\r\n");
    	LSC_USB_CH9(" IN Transaction \r\n");
    	LSC_USB_CH9(" bRequest = 0x%02x \r\n", setup_pkt->bRequest );
        switch (setup_pkt->bRequest) {
            case WINUSB_REQ:
//              LSC_USB_CH9("WinUSB Req\r\n");
            	printf("WinUSB Req\r\n");

                switch (setup_pkt->wIndex) {
                    case MS_OS_2_0_DESC_SET_REQUEST:
                        LSC_USB_CH9("MS Os 2.0 Desc Req\r\n\n");

                        lsc_usb_ep0_send(usb_dev, descp_set,
                                setup_pkt->wLength);
                        break;

                    default:
                        lsc_usb_ep0_stall_restart(usb_dev);
                        break;
                }
                break;

            /*case LSC_VENDOR_BREQ:
                printf("***********  LSC Vendor IN ************\r\n");
				reponse_p = (uint8_t*) &response;

                    //printf(" reponse_p[0] = 0x%02x \r\n" , reponse_p[0]);
                    if(reponse_p[0] == 0x0E){
                    	//printf(" Error Transfer Len = 1\r\n");
                    	transfer_len = 1;
                    }
                    else {
                    	printf(" Not error reported \r\n");
                    	transfer_len = setup_pkt->wLength;
                    }

                    //printf("Transfer Len = 0x%02x \r\n", transfer_len);


					lsc_usb_ep0_send(usb_dev, reponse_p, transfer_len);
                break;*/

            default: //will handle bRequest GPIO = 0, I2C = 1 and SPI = 2

                if(usb_dev->usb_vendor_req_handler!=NULL)
                {
                	usb_dev->usb_vendor_req_handler(usb_dev,&usb_dev->setup_data);
                }

                break;
        }
    } else {
        //CS OUT Request
//      LSC_USB_CH9("Vendor OUT Req\r\n");

        switch (setup_pkt->bRequest) {
            case LSC_VENDOR_BREQ:
                printf("LSC Vendor OUT\r\n\n");

                lsc_usb_ep0_rcv(usb_dev, v_buf, setup_pkt->wLength);

                break;

            default:
                if(usb_dev->usb_vendor_req_handler!=NULL)
                {
                usb_dev->usb_vendor_req_handler(usb_dev,&usb_dev->setup_data);
                }
                break;
        }
    }
}

/** @} */
