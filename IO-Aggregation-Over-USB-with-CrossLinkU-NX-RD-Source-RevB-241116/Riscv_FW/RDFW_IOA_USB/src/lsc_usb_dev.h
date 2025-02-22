/****************************************************************************/
/**
 *
 * @file lsc_usb_dev.h
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#ifndef LSC_USB_DEV_H_
#define LSC_USB_DEV_H_

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/
#include "usbio/i2c/lsc_i2c_req_mng.h"
#include "usbio/gpio/lsc_gpio.h"
#include "usbio/spi/lsc_spi_req_mng.h"
#include <sys/_stdint.h>
#include "uart.h"
#include "comdef.h"
#include "lsc_hw_regs.h"
#include "lsc_endpoint.h"
#include "utils.h"
#include "stdbool.h"
#include "string.h"
#include "lsc_usb_vendor.h"
#include "reg_access.h"



extern uint8_t print_buf[256];
extern _Response response;
extern uint8_t *reponse_p;
extern _Response *resp;
extern struct plat *pdata;
extern struct lsc_usb_dev *usb_dev;

/* Enable LSC_HIBERNATION_ENABLE to enable hibernation */
//#define LSC_HIBERNATION_ENABLE        1

/* Defines RISC V Firmware Version (X.Y) */
#define LSC_RISCV_VER        0x20

/* Enable LSC_LPM_ENABLE to enable LPM */
//#define LSC_LPM_ENABLE        1

/* Enable LOOPBACK to enable loopback transfer */
//#define LOOPBACK

/************************** Constant Definitions ****************************/
#define USB_EP0_MAX_PKT_SZ            512    /**< Defines default maximum packet size for control endpoint. */

#define USB_IF_NUM            31    /**< Defines Number of Interfaces used in HAL. */

#define LSC_USBIO_VENDOR_REQ  0x0   /**< Brequest used for Vendor Read/Write for USB I/O bridge commands */
#define LSC_VENDOR_BREQ       0x1   /**< Brequest used for Vendor Read/Write. */

#define DEVICE_STATUS_REMOTE_WAKEUP_BUS_POWERED_00_VALUE    0x0000        /**< Defines value of USB device Remote Wakeup & Powered state. */
#define DEVICE_STATUS_REMOTE_WAKEUP_SELF_POWERED_01_VALUE   0x0001        /**< Defines value of USB device Remote Wakeup & Powered state. */
#define DEVICE_STATUS_REMOTE_WAKEUP_BUS_POWERED_10_VALUE    0x0002        /**< Defines value of USB device Remote Wakeup & Powered state. */
#define DEVICE_STATUS_REMOTE_WAKEUP_SELF_POWERED_11_VALUE   0x0003        /**< Defines value of USB device Remote Wakeup & Powered state. */

#define NO_OF_TRB_PER_EP        4   /**< number of TRB*/

#define LSC_PHY_TIMEOUT         5000    /**< Phy timeout- microseconds */

#define LSC_EP_DIR_IN           1       /**< Direction IN */
#define LSC_EP_DIR_OUT          0       /**< Direction OUT */

#define LSC_USB_DIR_OUT         0       /**< Direction to device */
#define LSC_USB_DIR_IN          0x80    /**< Direction to host */

#define LSC_ENDPOINT_XFERTYPE_MASK      0x03    /**< Transfer type mask */
#define LSC_ENDPOINT_XFER_CONTROL       0       /**< Control EP */
#define LSC_ENDPOINT_XFER_ISOC          1       /**< ISO EP */
#define LSC_ENDPOINT_XFER_BULK          2       /**< Bulk EP */
#define LSC_ENDPOINT_XFER_INT           3       /**< Interrupt EP */
#define LSC_ENDPOINT_MAX_ADJUSTABLE     0x80    /**< Max EP */

#define LSC_TEST_J              1   /**< Test Mode J */
#define LSC_TEST_K              2   /**< Test Mode K */
#define LSC_TEST_SE0_NAK        3   /**< Test Mode SE0_NAK */
#define LSC_TEST_PACKET         4   /**< Test Mode TEST PACKET */
#define LSC_TEST_FORCE_ENABLE   5   /**< Test Mode FORCE ENABLE */

#define LSC_NUM_TRBS            8   /**< Number of TRB */

#define LSC_EVENT_PENDING       (0x00000001 << 0)               /**< Event pending bit */
#define LSC_EP_ENABLED          (0x00000001 << 0)               /**< EP status Enabled */
#define LSC_EP_STALL            (0x00000001 << 1)               /**< EP status WEDGE */
#define LSC_EP_WEDGE            (0x00000001 << 2)               /**< EP status busy */
#define LSC_EP_BUSY             ((uint32_t)0x00000001 << 4)     /**< EP status busy */
#define LSC_EP_PENDING_REQUEST  (0x00000001 << 5)               /**< EP status pending request */
#define LSC_EP_MISSED_ISOC      (0x00000001 << 6)               /**< EP status missed ISOC */

#define LSC_GHWPARAMS0          0   /**< Global Hardware Parameter Register 0 */
#define LSC_GHWPARAMS1          1   /**< Global Hardware Parameter Register 1 */
#define LSC_GHWPARAMS2          2   /**< Global Hardware Parameter Register 2 */
#define LSC_GHWPARAMS3          3   /**< Global Hardware Parameter Register 3 */
#define LSC_GHWPARAMS4          4   /**< Global Hardware Parameter Register 4 */
#define LSC_GHWPARAMS5          5   /**< Global Hardware Parameter Register 5 */
#define LSC_GHWPARAMS6          6   /**< Global Hardware Parameter Register 6 */
#define LSC_GHWPARAMS7          7   /**< Global Hardware Parameter Register 7 */

/* HWPARAMS0 */
#define LSC_MODE(n)             ((n) & 0x7) /**< USB MODE Host, Device or DRD */
#define LSC_MDWIDTH(n)          (((n) & 0xFF00) >> 8) /**< DATA bus width */

/* HWPARAMS1 */
#define LSC_NUM_INT(n)          (((n) & (0x3F << 15)) >> 15)  /**< Number of event buffer in devicemode */

/* HWPARAMS3 */
#define LSC_NUM_IN_EPS_MASK     ((uint32_t)0x0000001F << (uint32_t)18) /**< Number of Device Mode Active IN Endpoints mask */
#define LSC_NUM_EPS_MASK        ((uint32_t)0x0000003F << (uint32_t)12) /**< Number of Device Mode Endpoints mask */
#define LSC_NUM_EPS(p)          (((uint32_t)(p) & (LSC_NUM_EPS_MASK)) >> (uint32_t)12) /**< Number of Device Mode EP */
#define LSC_NUM_IN_EPS(p)       (((uint32_t)(p) & (LSC_NUM_IN_EPS_MASK)) >> (uint32_t)18) /**< Number of Device Mode Active IN Endpoints */

/* HWPARAMS7 */
#define LSC_RAM1_DEPTH(n)       ((n) & 0xFFFF) /**< depth of RAM1 */

#define LSC_DEPEVT_XFERCOMPLETE     0x01    /**< Device EP event transfer complete */
#define LSC_DEPEVT_XFERINPROGRESS   0x02    /**< Device EP event transfer In-progress */
#define LSC_DEPEVT_XFERNOTREADY     0x03    /**< Device EP event transfer not-ready */
#define LSC_DEPEVT_STREAMEVT        0x06    /**< Device EP event stream event */
#define LSC_DEPEVT_EPCMDCMPLT       0x07    /**< Device EP command complete event */

/* Within XferNotReady */
#define DEPEVT_STATUS_TRANSFER_ACTIVE   (1 << 3) /**< EP event status transfer active */

/* Within XferComplete */
#define DEPEVT_STATUS_BUSERR        (1 << 0) /**< EP Event status bus error */
#define DEPEVT_STATUS_SHORT         (1 << 1) /**< EP Event status short packet */
#define DEPEVT_STATUS_IOC           (1 << 2) /**< EP Event status completion */
#define DEPEVT_STATUS_LST           (1 << 3) /**< EP Event status last packet */

/* Stream event only */
#define DEPEVT_STREAMEVT_FOUND      1 /**< EP Event stream found */
#define DEPEVT_STREAMEVT_NOTFOUND   2 /**< EP Event status Not-found */

/* Control-only Status */
#define DEPEVT_STATUS_CONTROL_DATA              1   /**< Control data  status */
#define DEPEVT_STATUS_CONTROL_STATUS            2   /**< Control status */
#define DEPEVT_STATUS_CONTROL_DATA_INVALTRB     9   /**< Control data invalid TRB */
#define DEPEVT_STATUS_CONTROL_STATUS_INVALTRB   0xA /**< Control status invalid TRB */

#define LSC_ENDPOINTS_NUM       18  /**< Total number of endpoint */

#define LSC_EVENT_SIZE          4   /**< event size in bytes */
#define LSC_EVENT_MAX_NUM       16  /**< 2 events/endpoint */
/* (event size * maximum number of event) */
#define LSC_EVENT_BUFFERS_SIZE  64 /**< event size * maximum number of event */

#define LSC_EVENT_TYPE_MASK     0x000000fe /**< Device Specific Event Mask  */

#define LSC_EVENT_TYPE_DEV      0 /**< Device Specific Event */
#define LSC_EVENT_TYPE_CARKIT   3 /**< CARKIT Specific Event- Not support */
#define LSC_EVENT_TYPE_I2C      4 /**< I2C Specific Event- Not support */

#define LSC_DEVICE_EVENT_DISCONNECT         0 /**< Disconnect Detected Event Enable */
#define LSC_DEVICE_EVENT_RESET              1 /**< USB Reset Enable */
#define LSC_DEVICE_EVENT_CONNECT_DONE       2 /**< Connection Done Enable */
#define LSC_DEVICE_EVENT_LINK_STATUS_CHANGE 3 /**< USB/Link State Change Event Enable */
#define LSC_DEVICE_EVENT_WAKEUP             4 /**< Resume/Remote Wakeup Detected Event Enable */
#define LSC_DEVICE_EVENT_HIBER_REQ          5 /**< Hibernation Request Event */
#define LSC_DEVICE_EVENT_EOPF               6 /**< U3/L2-L1 Suspend Event Enable */
#define LSC_DEVICE_EVENT_SOF                7 /**< SOF Event */
#define LSC_DEVICE_EVENT_ERRATIC_ERROR      9 /**< Erratic Error Event Enable */
#define LSC_DEVICE_EVENT_CMD_CMPL           10 /**< Generic Command Complete Event */
#define LSC_DEVICE_EVENT_OVERFLOW           11 /**< Event Buffer Overflow Event */
#define LSC_DEVICE_EVENT_L1_RESUME_WK       14 /**< L1 Resume/RemoteWake Event Event */

#define LSC_GEVNTCOUNT_MASK                 0x0000fffc /**< Global Event Buffer Count Mask */

/*
 * Control Endpoint state
 */
#define LSC_EP0_SETUP_PHASE         1   /**< Setup Phase */
#define LSC_EP0_DATA_PHASE          2   /**< Data Phase */
#define LSC_EP0_STATUS_PHASE        3   /**< Status Pahse */

/*
 * Link State
 */
#define LSC_LINK_STATE_MASK         0x0F /**< Link State Mask */

/**
 * @param lsc_usb_link_state This typedef defines link state.
 *
 */
typedef enum {
    LSC_LINK_STATE_U0 = 0x00, /**< U0 state/ in HS - ON */
    LSC_LINK_STATE_U1 = 0x01, /**< U1 state */
    LSC_LINK_STATE_U2 = 0x02, /**< U2 state/ in HS - SLEEP */
    LSC_LINK_STATE_U3 = 0x03, /**< U3 state/ in HS - SUSPEND */
    LSC_LINK_STATE_SS_DIS = 0x04, /**< SuperSpeed connectivity is disabled */
    LSC_LINK_STATE_RX_DET = 0x05, /**< Warm reset, Receiver detection */
    LSC_LINK_STATE_SS_INACT = 0x06, /**< Link has failed SuperSpeed operation */
    LSC_LINK_STATE_POLL = 0x07, /**< POLL */
    LSC_LINK_STATE_RECOV = 0x08, /**< Retrain SuperSpeed link, Perform Hot reset, Switch to Loop back mode */
    LSC_LINK_STATE_HRESET = 0x09, /**< Hot reset using Training sets */
    LSC_LINK_STATE_CMPLY = 0x0A, /**< Test the transmitter for compliance to voltage and timing specifications */
    LSC_LINK_STATE_LPBK = 0x0B, /**< For test and fault isolation */
    LSC_LINK_STATE_RESET = 0x0E, /**< RESET */
    LSC_LINK_STATE_RESUME = 0x0F, /**< RESUME */
} lsc_usb_link_state; /**< defines link state */

/**
 * @param lsc_usb_link_state_change This typedef defines link state change.
 *
 */
typedef enum {
    LSC_LINK_STATE_CHANGE_U0 = 0x00, /**< U0 /in HS - ON */
    LSC_LINK_STATE_CHANGE_SS_DIS = 0x04, /**< SuperSpeed connectivity is disabled */
    LSC_LINK_STATE_CHANGE_RX_DET = 0x05, /**< Warm reset, Receiver detection */
    LSC_LINK_STATE_CHANGE_SS_INACT = 0x06, /**< Link has failed SuperSpeed operation */
    LSC_LINK_STATE_CHANGE_RECOV = 0x08, /**< Retrain SuperSpeed link, Perform Hot reset, Switch to Loop back mode */
    LSC_LINK_STATE_CHANGE_CMPLY = 0x0A, /**< Test the transmitter for compliance to voltage and timing specifications */
} lsc_usb_link_state_change; /**< link state change */

/**
 * @param lsc_usb_status This typedef defines usb status.
 *
 */
typedef enum {
    LSC_SUCCESS = 0x00, /**< 0 - SUCCESS */
    LSC_FAIL = 0x01, /**<  1 - FAIL */
} lsc_usb_status; /**< Error Code */

/**
 * This enum defines index's of data packet header.
 * @{
 */
enum usbHeaderIndex
{
    TYPE_INDEX = 0,
    CMD_INDEX = 1,
    FLAGS_INDEX = 2,
    LENGTH_INDEX = 3,
    PAYLOAD_START = 4,
};
/**
 * @}
 */

/*
 * Device States
 */
#define     LSC_STATE_ATTACHED      0 /**< Device State Attach */
#define     LSC_STATE_POWERED       1 /**< Device State Power */
#define     LSC_STATE_DEFAULT       2 /**< Device State Default */
#define     LSC_STATE_ADDRESS       3 /**< Device State Address */
#define     LSC_STATE_CONFIGURED    4 /**< Device State Configure */
#define     LSC_STATE_SUSPENDED     5 /**< Device State Suspend */

/*
 * Device Speeds
 */
#define     LSC_SPEED_UNKNOWN       0 /**< Device Speed Unknown */
#define     LSC_SPEED_LOW           1 /**< Device Speed Low */
#define     LSC_SPEED_FULL          2 /**< Device Speed Full */
#define     LSC_SPEED_HIGH          3 /**< Device Speed High */
#define     LSC_SPEED_SUPER         4 /**< Device Speed Speed */

/*
 * Converts USB endpoint into physical endpoint controller.
 */
#define lsc_physicalep(epnum, direction)    (((epnum) << 1 ) | (direction))
/**< Return Physical EP number
 *   as dwc3 mapping
 */

/***************** Macros (Inline Functions) Definitions *********************/
#define IS_ALIGNED(x, a)    (((x) & (/*(typeof(x))*/(a) - 1)) == 0)
/**< parameter aligned */
/**************************** Type Definitions ******************************/

#define roundup(x, y) (                                 \
        (((x) + (uint32_t)(/*(typeof(y))*/(y) - 1)) / \
         (uint32_t)(/*(typeof(y))*/(y))) * \
        (uint32_t)(/*(typeof(y))*/(y))               \
              ) /**< roundup value based on input parameter */

/**
 * struct lsc_evt_buffer - Software Event buffer representation
 * @param buf_add: Event Buffer address
 * @param offset: Event Buffer offset
 * @param count: Event Buffer count
 * @param flags: Event Buffer Flag - PENDING /NOT PENDING
 */
struct lsc_evt_buffer {
    void *buf_add; /**< Event Buffer address */
    uint32_t offset; /**< Event Buffer offset */
    uint32_t count; /**< Event Buffer count */
    uint32_t flags; /**< Event Buffer Flag - PENDING /NOT PENDING */
};
/**< Software Event buffer representation */

/**
 * struct lsc_trb - Transfer Request Block - Hardware format
 * @param buf_ptr_lo: Data buffer pointer to low 32 bits
 * @param buf_ptr_hi: Data buffer pointer to high 32-bits
 * @param size: Buffer Size
 * @param ctrl: Transfer Request Block Control parameter
 */
struct lsc_trb {
    uint32_t buf_ptr_lo; /**< Data buffer pointer to low 32 bits */
    uint32_t buf_ptr_hi; /**< Data buffer pointer to high 32-bits */
    uint32_t size; /**< Buffer Size */
    uint32_t ctrl; /**< Transfer Request Block Control parameter */
} __attribute__((packed));
/**< Transfer Request Block - Hardware format */

/**
 * struct lsc_ep_params - Endpoint Parameters
 * @param param2: Parameter 2
 * @param param1: Parameter 1
 * @param param0: Parameter 0
 */
struct lsc_ep_params {
    uint32_t param2; /**< Parameter 2 */
    uint32_t param1; /**< Parameter 1 */
    uint32_t param0; /**< Parameter 0 */
};
/**< Endpoint Parameters */

/**
 * struct setup_pkt - USB Standard Control Request
 * @param bRequestType: Characteristics of request
 * @param bRequest: Type of request
 * @param wValue: Word-sized field that varies according to request
 * @param wIndex: Used to pass an index or offset
 * @param wLength: Number of bytes to transfer if there is a Data stage
 */
typedef struct {
    uint8_t bRequestType; /**< Characteristics of request */
    uint8_t bRequest; /**< Type of request */
    uint16_t wValue; /**< Word-sized that varies according to request */
    uint16_t wIndex; /**< Used to pass an index or offset */
    uint16_t wLength; /**< Number of bytes to transfer */
} __attribute__ ((packed)) setup_pkt; /**< USB Standard Control Request */

/**
 * struct lsc_ep - Endpoint representation
 * @cond test
 * @param Handler: User handler
 * @endcond
 * @param ep_trb: TRB used by endpoint
 * @param ep_status: Flags to represent Endpoint status
 * @param ep_saved_state: Endpoint status saved at the time of hibernation
 * @param requested_bytes: RequestedBytes for transfer
 * @param bytes_txfered: Actual Bytes transferred
 * @param interval: Data transfer service interval
 * @cond test
 * @param trb_enqueue: number of TRB enqueue
 * @param trb_dequeue: number of TRB dequeue
 * @endcond
 * @param max_ep_size: Size of endpoint
 * @param cur_micro_frame: current microframe
 * @param buffer_ptr: Buffer location
 * @param resource_index: Resource Index assigned to Endpoint by core
 * @param phy_ep_num: Physical Endpoint Number in core
 * @param usb_ep_num: USB Endpoint Number
 * @param ep_type: Type of Endpoint - Control/BULK/INTERRUPT/ISOC
 * @param ep_direction: Direction - EP_DIR_OUT/EP_DIR_IN
 * @cond test
 * @param unaligned_tx: Unaligned Tx flag - 0/1
 * @endcond
 */
struct lsc_ep {
  void (*handler)(void *, uint32_t,  uint32_t);
    /**< User handler called
     *   when data is sent for IN Ep
     *   and received for OUT Ep
     */
    struct lsc_trb ep_trb[NO_OF_TRB_PER_EP + 1] __attribute__ ((aligned(32)));
    /**< TRB used by endpoint
     *   One extra Link TRB
     */
    uint32_t ep_status; /**< Flags to represent Endpoint status */
    uint32_t ep_saved_state; /**< Endpoint status saved at the time of
     *   hibernation
     */
    uint32_t requested_bytes; /**< RequestedBytes for transfer */
    uint32_t bytes_txfered; /**< Actual Bytes transferred */
    uint8_t interval; /**< Data transfer service interval */
    uint32_t    trb_enqueue;         /**< number of TRB enqueue */
    uint32_t    trb_dequeue;         /**< number of TRB dequeue */
    uint16_t max_ep_size; /**< Size of endpoint */
    uint16_t cur_micro_frame; /**< current microframe */
    uint8_t *buffer_ptr; /**< Buffer location */
    uint8_t resource_index; /**< Resource Index assigned to
     *   Endpoint by core
     */
    uint8_t phy_ep_num; /**< Physical Endpoint Number in core */
    uint8_t usb_ep_num; /**< USB Endpoint Number */
    uint8_t ep_type; /**< Type of Endpoint -
     *   Control/BULK/INTERRUPT/ISOC
     */
    uint8_t ep_direction; /**< Direction - EP_DIR_OUT/EP_DIR_IN */
    uint8_t  unaligned_tx;        /**< Unaligned Tx flag - 0/1 */
} __attribute__ ((packed)) ;
/**< Endpoint representation */

/**
 * USB Device Controller representation
 */
/**
 * struct lsc_usb_dev - USB Device Controller representation
 * @param setup_data: Setup data packet
 * @param ep0_trb: TRB for control transfers
 * @param ConfigPtr: Configuration info pointer
 * @param eps: Endpoints array
 * @param evt: Usb event buffer
 * @param ep_params: Endpoint Parameters
 * @param base_add: Core register base address
 * @param dev_desc_size: Device descriptor size
 * @param config_desc_size: Config descriptor size
 * @cond test
 * @param AppData: Application data
 * @param *Chapter9: USB Chapter9 function handler
 * @param *ResetIntrHandler: Reset function handler
 * @param *DisconnectIntrHandler: Disconnect function handler
 * @endcond
 * @param *dev_desc: Device descriptor pointer
 * @param *config_desc: Config descriptor pointer
 * @param dev_speed: USB device speed
 * @param dev_state: USB device state
 * @param event_buf: Event buffer array
 * @param num_out_eps: Number of out endpoints
 * @param num_in_eps: Number of in endpoint
 * @param control_dir: Control endpoint direction
 * @param is_test_mode: USB test mode flag
 * @param test_mode:  Test Mode
 * @param ep0_state: Control EP state
 * @param link_state: USB link state
 * @cond test
 * @param UnalignedTx: Unaligned transfer flag
 * @endcond
 * @param is_config_done: Flag - Check config is done or not
 * @param usb_configuration: USB Configuration
 * @param is_three_stage: USB three stage communication
 * @cond test
 * @param IsHibernated: Flag - Hibernated state
 * @param HasHibernation: Has hibernation support
 * @param *data_ptr: pointer for storing applications data
 * @endcond
 */
struct lsc_usb_dev {
    setup_pkt setup_data __attribute__ ((aligned(32))); /**< Setup Packet buffer */
    struct lsc_trb ep0_trb __attribute__ ((aligned(32))); /**< TRB for control transfers */
    struct lsc_ep eps[LSC_ENDPOINTS_NUM]; /**< Endpoints */
    struct lsc_evt_buffer evt; /**< Usb event buffer */
    struct lsc_ep_params ep_params; /**< Endpoint Parameters */
    uint32_t base_add; /**< Core register base address */
    uint8_t dev_desc_size; /**< Device descriptor size */
    uint32_t config_desc_size; /**< Config descriptor size */
    void *dev_desc; /**< Device descriptor pointer */
    void *config_desc; /**< Config descriptor pointer */
    uint8_t dev_speed; /**< USB Device Speed */
    uint8_t dev_state; /**< USB Device State */
    uint8_t event_buf[LSC_EVENT_BUFFERS_SIZE] __attribute__((aligned(LSC_EVENT_BUFFERS_SIZE))); /**< Event buffer array */
    uint8_t num_out_eps; /**< Number of out endpoints */
    uint8_t num_in_eps; /**< Number of in endpoint */
    uint8_t control_dir; /**< Control endpoint direction */
    uint8_t is_test_mode; /**< USB test mode flag */
    uint8_t test_mode; /**< Test Mode */
    uint8_t ep0_state; /**< Control EP state */
    uint8_t link_state; /**< Usb link state */
    uint8_t l2_suspend; /**< L2 Suspend state */
    uint8_t is_config_done; /**< Flag - Check config is done or not */
    uint8_t is_enum_done;/**< Flag - Check if enumeration is done or not */
    uint8_t usb_configuration; /**< Represents USB Configuration */
    uint8_t is_three_stage; /**< USB three stage communication */
//  uint8_t IsHibernated;                                   /**< Hibernated state */
//  uint8_t HasHibernation;                                 /**< Has hibernation support */
    uint8_t usb_num_interface;
    uint8_t usb_interface;
    uint8_t usb_alt_set[USB_IF_NUM];
    uint8_t wakeup_selfpowered;
    void (*usb_vendor_req_handler)(void *, void *);
};

/**
 * struct lsc_event_type - Device Endpoint Events type
 * @param is_dev_evt: Device specific event
 * @param evt_type: Event types
 * @param reserved8_31: Reserved, not used
 */
struct lsc_event_type {
    uint32_t is_dev_evt :1; /**< Device specific event */
    uint32_t type :7; /**< Event types */
    uint32_t reserved8_31 :24; /**< Reserved, not used */
} __attribute__((packed));
/**< Device Endpoint Events type */
/**
 * struct lsc_event_epevt - Device Endpoint Events
 * @param is_ep_evt: indicates this is an endpoint event
 * @param ep_number: number of the endpoint
 * @param ep_event: The event we have:
 *  0x00    - Reserved
 *  0x01    - XferComplete
 *  0x02    - XferInProgress
 *  0x03    - XferNotReady
 *  0x04    - RxTxFifoEvt (IN->Underrun, OUT->Overrun)
 *  0x05    - Reserved
 *  0x06    - StreamEvt
 *  0x07    - EPCmdCmplt
 * @param reserved11_10: Reserved, don't use.
 * @param status: Indicates the status of the event. Refer to databook for
 *  more information.
 * @param parameters: Parameters of the current event. Refer to databook for
 *  more information.
 */
struct lsc_event_epevt {
    uint32_t is_ep_evt :1; /**< indicates this is an endpoint event */
    uint32_t ep_number :5; /**< number of the endpoint */
    uint32_t ep_event :4; /**< endpoint event */
    uint32_t reserved11_10 :2; /**< Reserved, not used */
    uint32_t status :4; /**< Indicates the status of the event */
    uint32_t parameters :16; /**< Parameters of the current event */
} __attribute__((packed));
/**< Device Endpoint Events */
/**
 * struct lsc_event_devt - Device Events
 * @param is_dev_evt: indicates this is a non-endpoint event
 * @param dev_event: indicates it's a device event. Should read as 0x00
 * @param dev_evt_type: indicates the type of device event.
 *  0   - DisconnEvt
 *  1   - USBRst
 *  2   - ConnectDone
 *  3   - ULStChng
 *  4   - WkUpEvt
 *  5   - Reserved
 *  6   - EOPF
 *  7   - SOF
 *  8   - Reserved
 *  9   - ErrticErr
 *  10  - CmdCmplt
 *  11  - EvntOverflow
 *  12  - VndrDevTstRcved
 *  14  - L1 Resume
 * @param reserved15_12: Reserved, not used
 * @param evt_info: Information about this event
 * @param reserved31_25: Reserved, not used
 */
struct lsc_event_devt {
    uint32_t is_dev_evt :1; /**< non-endpoint event */
    uint32_t dev_event :7; /**< device event */
    uint32_t dev_evt_type :4; /**< type of device event */
    uint32_t reserved15_12 :4; /**< Reserved, not used */
    uint32_t evt_info :9; /**< Information about this event */
    uint32_t reserved31_25 :7; /**< Reserved, not used */
} __attribute__((packed));
/**< Device Events */
/**
 * struct lsc_event_gevt - Other Core Events
 * @param is_global_evt: indicates this is a non-endpoint event (not used)
 * @param dev_event: indicates it's (0x03) Carkit or (0x04) I2C event.
 * @param phy_port_number: self-explanatory
 * @param reserved31_12: Reserved, not used.
 */
struct lsc_event_gevt {
    uint32_t is_global_evt :1; /**< non-endpoint event (not used)*/
    uint32_t dev_event :7; /**< it's (0x03) Carkit or (0x04) I2C event */
    uint32_t phy_port_number :4; /**< Phy_Port_Number:4 */
    uint32_t reserved31_12 :20; /**< reserved31_12 */
} __attribute__((packed));
/**< Core events */
/**
 * union lsc_event - representation of Event Buffer contents
 * @param evt: raw 32-bit event
 * @param evt_type: type of the event
 * @param ep_evt: Device Endpoint Event
 * @param dev_evt: Device Event
 * @param gl_evt: Global Event
 */
union lsc_event {
    uint32_t val; /**< raw 32-bit event */
    struct lsc_event_type evt_type; /**< type of the event */
    struct lsc_event_epevt ep_evt; /**< Device Endpoint Event */
    struct lsc_event_devt dev_evt; /**< Device Event */
    struct lsc_event_gevt gl_evt; /**< Global Event */
};
/**< Representation of Event Buffers */

/************************** Function Prototypes ******************************/
/*
 * Functions in lsc_usb_dev.c
 */
//int32_t LtcUsb_SetU1SleepTimeout(struct lsc_usb_dev *usb_dev, uint8_t Timeout);
//int32_t LtcUsb_SetU2SleepTimeout(struct lsc_usb_dev *usb_dev, uint8_t Timeout);
//int32_t LtcUsb_AcceptU1U2Sleep(struct lsc_usb_dev *usb_dev);
//int32_t LtcUsb_U1SleepEnable(struct lsc_usb_dev *usb_dev);
//int32_t LtcUsb_U2SleepEnable(struct lsc_usb_dev *usb_dev);
//int32_t LtcUsb_U1SleepDisable(struct lsc_usb_dev *usb_dev);
//int32_t LtcUsb_U2SleepDisable(struct lsc_usb_dev *usb_dev);
//int32_t LtcUsb_IsSuperSpeed(struct lsc_usb_dev *usb_dev);
uint8_t lsc_usb_hw_init (struct lsc_usb_dev *usb_dev);
void lsc_usb_evt_buf_setup (struct lsc_usb_dev *usb_dev);
void lsc_usb_set_speed (struct lsc_usb_dev *usb_dev, uint32_t speed);
void lsc_usb_set_dev_add (struct lsc_usb_dev *usb_dev, uint16_t add);
uint32_t lsc_usb_read_hw_params (struct lsc_usb_dev *usb_dev, uint8_t reg_index);
void lsc_usb_phy_reset (struct lsc_usb_dev *usb_dev);
void lsc_usb_idle (struct lsc_usb_dev *usb_dev);
void lsc_usb_usleep (uint32_t useconds);
void lsc_read_dev_status_reg (struct lsc_usb_dev *usb_dev);

/*
 * Functions in lscusb.c
 */
uint8_t lsc_usb_init (struct lsc_usb_dev *usb_dev, uint32_t base_add);
void lsc_usb_initialize_eps (struct lsc_usb_dev *usb_dev);
void lsc_usb_set_mode (struct lsc_usb_dev *usb_dev, uint32_t mode);
void lsc_usb_start (struct lsc_usb_dev *usb_dev);
int32_t lsc_usb_stop (struct lsc_usb_dev *usb_dev);
uint8_t lsc_usb_get_link_state (struct lsc_usb_dev *usb_dev);
uint32_t lsc_usb_set_link_state (struct lsc_usb_dev *usb_dev,
        lsc_usb_link_state_change state);
/*
 * Functions in lsc_command.c
 */
uint32_t lsc_usb_ep_enable (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir, uint16_t max_size, uint8_t ep_type, uint8_t restore);
uint32_t lsc_usb_ep_disable (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir);
struct lsc_ep_params* lsc_usb_get_ep_params (struct lsc_usb_dev *usb_dev);
uint32_t lsc_usb_send_ep_cmd (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir, uint32_t cmd, struct lsc_ep_params *params);

/*
 * Functions in lsc_ep_handler.c
 */
void lsc_usb_clear_stalls (struct lsc_usb_dev *usb_dev);
uint8_t lsc_usb_ep_buf_send (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t *buf, uint32_t buf_len);
uint8_t lsc_usb_ep_buf_rcv (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t *buf, uint32_t buf_len);
void lsc_usb_ep_set_stall (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir);
void lsc_usb_ep_clear_stall (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir);
uint8_t lsc_usb_is_ep_stalled (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir);
void lsc_usb_stop_xfer (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir, uint8_t force);
void lsc_usb_ep_xfer_cmplt (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt);
void lsc_usb_ep_xfer_not_ready (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt);

/*
 * Functions in lsc_ep0_handler.c
 */
uint8_t lsc_usb_rcv_setup (struct lsc_usb_dev *usb_dev);
void lsc_usb_ep0_xfer_cmplt (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt);
void lsc_usb_ep0_xfer_not_ready (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt);
uint8_t lsc_usb_ep0_send (struct lsc_usb_dev *usb_dev, uint8_t *buf,
        uint32_t buf_len);
uint8_t lsc_usb_ep0_rcv (struct lsc_usb_dev *usb_dev, uint8_t *buf,
        uint32_t buf_len);

/*
 * Functions in lsc_usb_event.c
 */
void lsc_usb_ep_event (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt);
void lsc_usb_dev_event (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_devt *dev_event);
void lsc_usb_evt_buf_handler (struct lsc_usb_dev *usb_dev);

/*
 * Functions in lsc_intr.c
 */
void lsc_usb_int_handler (void *context);
void lsc_usb_enable_int (struct lsc_usb_dev *usb_dev, uint32_t mask);
void lsc_usb_disable_int (struct lsc_usb_dev *usb_dev, uint32_t mask);
void lsc_usb_evt_handler (struct lsc_usb_dev *usb_dev,
        const union lsc_event *event);
void lsc_usb_link_sts_change_int (struct lsc_usb_dev *usb_dev,
        uint32_t evt_info);
void lsc_usb_connect_int (struct lsc_usb_dev *usb_dev);
void lsc_usb_disconn_int (struct lsc_usb_dev *usb_dev);
void lsc_usb_reset_int (struct lsc_usb_dev *usb_dev);
void lsc_usb_ep0_intr (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *event);
void lsc_usb_wakeup_int (struct lsc_usb_dev *usb_dev);
void lsc_gpio_int_handler (void *context);

/*
 * Hibernation Functions
 */
//#ifdef LSC_HIBERNATION_ENABLE
//void LtcUsb_WakeUpIntrHandler(void *lsc_usb_devusb_dev);
//#endif
/*
 * Functions in lsc_ctrl_xfer.c
 */
void lsc_usb_ep0_stall_restart (struct lsc_usb_dev *usb_dev);
uint8_t lsc_usb_enable_ctrl_ep (struct lsc_usb_dev *usb_dev, uint16_t size);
void lsc_usb_ep0_data_xfer_cmplt (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt);
void lsc_usb_ep0_status_cmplt (struct lsc_usb_dev *usb_dev);
uint8_t lsc_usb_start_ep0_stat (struct lsc_usb_dev *usb_dev,
        const struct lsc_event_epevt *ep_evt);
void lsc_usb_end_ep0_ctl_data_xfer (struct lsc_usb_dev *usb_dev,
        struct lsc_ep *ep);

/*
 * Functions in lsc_endpoint.c
 */
uint32_t lsc_usb_ep_get_xfer_index (struct lsc_usb_dev *usb_dev,
        uint8_t usb_ep_num, uint8_t dir);
uint32_t lsc_usb_start_ep_cfg (struct lsc_usb_dev *usb_dev, uint32_t usb_ep_num,
        uint8_t dir);
uint32_t lsc_usb_set_ep_cfg (struct lsc_usb_dev *usb_dev, uint8_t usb_ep_num,
        uint8_t dir, uint16_t size, uint8_t ep_type, uint8_t restore);
uint32_t lsc_usb_set_xfer_resource (struct lsc_usb_dev *usb_dev,
        uint8_t usb_ep_num, uint8_t dir);
void lsc_usb_clear_stall_all_ep (struct lsc_usb_dev *usb_dev);
void lsc_usb_stop_active_transfers (struct lsc_usb_dev *usb_dev);

void lsc_set_ep_handler(struct lsc_usb_dev *usb_dev, uint8_t epnum,
        uint8_t dir, void (*handler)(void *, uint32_t, uint32_t));
void lsc_bulk_out_handler(struct lsc_usb_dev *usb_dev, uint32_t ep_num,uint32_t requested_bytes);
void lsc_bulk_in_handler(struct lsc_usb_dev *usb_dev,uint32_t ep_num, uint32_t  requested_bytes);
void lsc_usb_vendor_req (void *dev,void *setup);
/*
 * Functions in lsc_usb_ch9.c
 */
void lsc_usb_setup_pkt_process (struct lsc_usb_dev *usb_dev,
        setup_pkt *setup_pkt);

#ifdef __cplusplus
}
#endif

#endif /* LSC_USB_DEV_H_ */

/** @} */
