/****************************************************************************/
/**
 *
 * @file lsc_usb_event.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"

//#define DEBUG_LSC_USB_EVT

#ifdef DEBUG_LSC_USB_EVT
#define LSC_USB_EVT(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_USB_EVT(msg, ...)
#endif

/****************************************************************************/
/**
 * Processes events in an Event Buffer.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 *
 * @return   None.
 *
 * @note     This function will call event buffer handler to process
 *           evnts. After processing of all events Event Interrupt Mask
 *           is unmasked so that controller can generate events by writing
 *           into event buffer.<br>
 *****************************************************************************/
void lsc_usb_evt_buf_handler (struct lsc_usb_dev *usb_dev)
{
//    LSC_USB_EVT("lsc_usb_evt_buf_handler\r\n");

    struct lsc_evt_buffer *evt;
    union lsc_event event = {0};

    uint32_t evt_count = 0, reg_val = 0;

    evt = &usb_dev->evt;
    LSC_USB_EVT("Event: Buffer address: 0x%x\r\n", evt->buf_add);

    while (evt->count > 0) {
        event.val = *(uintptr_t*)((uintptr_t)evt->buf_add + evt->offset);
        LSC_USB_EVT("Event Buf Val: %x\r\n", event.val);
        LSC_USB_EVT("Event Offset : %x\r\n", evt->offset);

        //Process received event
        lsc_usb_evt_handler(usb_dev, &event);

        evt->offset = (evt->offset + 4) % LSC_EVENT_BUFFERS_SIZE;
        evt->count -= 4;
        lsc_32_write((usb_dev->base_add + LSC_GEVNTCOUNT(0)), 4);
    }

    evt->count = 0;
    evt->flags &= ~LSC_EVENT_PENDING;

    //Unmask event interrupt
    reg_val = lsc_32_read(usb_dev->base_add + LSC_GEVNTSIZ(0));
    reg_val &= ~LSC_GEVNTSIZ_INTMASK;
    lsc_32_write((usb_dev->base_add + LSC_GEVNTSIZ(0)), reg_val);
}

/****************************************************************************/
/**
 * Endpoint event handler.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    ep_evt is endpoint Event occurred in the core.
 *
 * @return   None.
 *
 * @note     This function handles enpoint related events generated
 *           by controller.<br>
 *****************************************************************************/
void lsc_usb_ep_event (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt)
{
    LSC_USB_EVT("lsc_usb_ep_event\r\n");

    struct lsc_ep *ep;
    uint32_t ep_num;

    ep_num = ep_evt->ep_number;
    ep = &usb_dev->eps[ep_num];

    if ((ep->ep_status & LSC_EP_ENABLED) == 0) {
        return;
    }

    if ((ep_num == 0) || (ep_num == 1)) {
        lsc_usb_ep0_intr(usb_dev, ep_evt);
        return;
    }

//    printf("ep_evt->ep_event:%x\r\n",ep_evt->ep_event);

//    printf("ep_evt->status:%x\r\n",ep_evt->status);
    /* Handle other end point events */
    switch (ep_evt->ep_event) {
        case LSC_DEPEVT_XFERCOMPLETE:
        case LSC_DEPEVT_XFERINPROGRESS:
        	//I2C could handle via Bulk Transfer in future
            //lsc_usb_ep_xfer_cmplt(usb_dev, ep_evt);
            break;

        case LSC_DEPEVT_XFERNOTREADY:
            lsc_usb_ep_xfer_not_ready(usb_dev, ep_evt);
            break;

        default:
            printf("unexpected event\r\n");
            break;
    }
}

/****************************************************************************/
/**
 * Device event handler for device specific events.
 *
 * @param    usb_dev is a pointer to the lsc_usb_dev instance.
 * @param    dev_event is the Device Event occurred in core.
 *
 * @return   None.
 *
 * @note     This function handles Device related events generated
 *           by controller.<br>
 *****************************************************************************/
void lsc_usb_dev_event (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_devt *dev_event)
{
//    LSC_USB_EVT("lsc_usb_dev_event\r\n");

    switch (dev_event->dev_evt_type) {
        case LSC_DEVICE_EVENT_DISCONNECT:
            lsc_usb_disconn_int(usb_dev);
            break;

        case LSC_DEVICE_EVENT_RESET:
            lsc_usb_reset_int(usb_dev);
            break;

        case LSC_DEVICE_EVENT_CONNECT_DONE:
            lsc_usb_connect_int(usb_dev);
            break;

        case LSC_DEVICE_EVENT_LINK_STATUS_CHANGE:
            lsc_usb_link_sts_change_int(usb_dev, dev_event->evt_info);
            break;

        case LSC_DEVICE_EVENT_WAKEUP:
            printf("DEVICE_EVENT_WAKEUP\r\n");
            lsc_usb_wakeup_int (usb_dev);
            break;

        case LSC_DEVICE_EVENT_HIBER_REQ:
            printf("DEVICE_EVENT_HIBER\r\n");
            break;

        case LSC_DEVICE_EVENT_EOPF:
            printf("DEVICE_SUSPEND_EVENT\r\n");
            break;

        case LSC_DEVICE_EVENT_SOF:
            printf("DEVICE_EVENT_SOF\r\n");
            break;

        case LSC_DEVICE_EVENT_ERRATIC_ERROR:
            printf("DEVICE_EVENT_ERRATIC_ERROR\r\n");
            break;

        case LSC_DEVICE_EVENT_CMD_CMPL:
            printf("DEVICE_EVENT_CMD_CMPL\r\n");
            break;

        case LSC_DEVICE_EVENT_OVERFLOW:
            printf("DEVICE_EVENT_OVERFLOW\r\n");
            break;

        case LSC_DEVICE_EVENT_L1_RESUME_WK:
            printf("LSC_DEVICE_EVENT_L1_RESUME_WK\r\n");
            break;

        default:
            LSC_USB_EVT("Invalid Device Events.!!\r\n");
            break;
    }
}

/** @} */
