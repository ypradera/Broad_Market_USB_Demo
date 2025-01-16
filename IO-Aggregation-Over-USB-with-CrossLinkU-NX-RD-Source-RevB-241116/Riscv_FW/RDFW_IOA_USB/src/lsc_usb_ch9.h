/****************************************************************************/
/**
 *
 * @file lsc_usb_ch9.h
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#ifndef LSC_USB_CH9_H_
#define LSC_USB_CH9_H_

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/

/************************** TypeDef Definitions *****************************/
/*
 * Standard USB structures as per 2.0 specification
 */

#pragma pack(1)

/**
 *  @brief USB Common Descriptor Structure.
 */
typedef struct _USB_COMMON_DESCRIPTOR {
    char bLength;
    char bDescriptorType;
} __attribute__ ((packed)) USB_COMMON_DESCRIPTOR;

/**
 *  @brief USB Standard Device Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint16_t bcdUSB;
    uint8_t bDeviceClass;
    uint8_t bDeviceSubClass;
    uint8_t bDeviceProtocol;
    uint8_t bMaxPacketSize0;
    uint16_t idVendor;
    uint16_t idProduct;
    uint16_t bcdDevice;
    uint8_t iManufacturer;
    uint8_t iProduct;
    uint8_t iSerialNumber;
    uint8_t bNumConfigurations;
} __attribute__ ((packed)) (USB_STD_DEV_DESC);

/**
 *  @brief USB Standard Configuration Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bType;
    uint16_t wTotalLength;
    uint8_t bNumberInterfaces;
    uint8_t bConfigValue;
    uint8_t bIConfigString;
    uint8_t bAttributes;
    uint8_t bMaxPower;
} __attribute__ ((packed)) (USB_STD_CFG_DESC);

/**
 *  @brief USB Standard Interface Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint8_t bInterfaceNumber;
    uint8_t bAlternateSetting;
    uint8_t bNumEndPoints;
    uint8_t bInterfaceClass;
    uint8_t bInterfaceSubClass;
    uint8_t bInterfaceProtocol;
    uint8_t iInterface;
} __attribute__ ((packed)) (USB_STD_IF_DESC);

/**
 *  @brief USB Standard Endpoint Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint8_t bEndpointAddress;
    uint8_t bmAttributes;
    uint16_t bMaxPacketSize;
    uint8_t bInterval;
} __attribute__ ((packed)) (USB_STD_EP_DESC);

/**
 *  @brief USB Standard SUPERSPEED USB ENDPOINT COMPANION
 *  Descriptor Structure
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint8_t bMaxBurst;
    uint8_t bmAttributes;
    uint16_t wBytesPerInterval;
} __attribute__ ((packed)) (USB_STD_EP_SS_COMP_DESC);

/**
 *  @brief Lattice USB20 Configuration Descriptor Structure.
 */
typedef struct {
    USB_STD_CFG_DESC cfg;
    USB_STD_IF_DESC intf;
    USB_STD_EP_DESC ep_in;
    USB_STD_EP_DESC ep_out;
} __attribute__ ((packed)) (LSC_USB20_CFG_DESC);

/**
 *  @brief Lattice USB30 Configuration Descriptor Structure.
 */
typedef struct {
    USB_STD_CFG_DESC cfg;
    USB_STD_IF_DESC intf;
    USB_STD_EP_DESC ep_in;
    USB_STD_EP_SS_COMP_DESC ep_cmp_in;
    USB_STD_EP_DESC ep_out;
    USB_STD_EP_SS_COMP_DESC ep_cmp_out;
} __attribute__ ((packed)) (LSC_USB30_CFG_DESC);

/**
 *  @brief USB Standard String Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint16_t wLANGID[20];
} __attribute__ ((packed)) (USB_STD_STRING_DESC);

/**
 *  @brief USB Standard BOS Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint16_t wTotalLength;
    uint8_t bNumDeviceCaps;
} __attribute__ ((packed)) (USB_STD_BOS_DESC);

/**
 *  @brief USB20 Device Extension Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint8_t bDevCapabiltyType;
    uint32_t bmAttributes;
} __attribute__ ((packed)) (USB_STD_U20_DEVICE_EXT_DESC);

/**
 *  @brief Super Speed USB Device Capability Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint8_t bDevCapabiltyType;
    uint8_t bmAttributes;
    uint16_t wSpeedsSupported;
    uint8_t bFunctionalitySupport;
    uint8_t bU1DevExitLat;
    uint16_t wU2DevExitLat;
} __attribute__ ((packed)) (USB_STD_SS_DEVICE_CAP_DESC);

/**
 *  @brief Platform Capability Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint8_t bDevCapabiltyType;
    uint8_t bReserved;
    uint8_t PlatformCapabilityUUID[16];
    uint8_t CapabilityData[8];
} __attribute__ ((packed)) (USB_STD_PLATFORM_CAP_DESC);

/**
 *  @brief Lattice USB BOS Descriptor Structure.
 */
typedef struct {
    USB_STD_BOS_DESC bos_desc;
    USB_STD_U20_DEVICE_EXT_DESC u20_ext_desc;
    USB_STD_PLATFORM_CAP_DESC plat_cap_desc;
} __attribute__ ((packed)) (LSC_USB_BOS_DESC);

/**
 *  @brief USB Standard Device Qualifier Descriptor Structure.
 */
typedef struct {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint16_t bcdUSB;
    uint8_t bDeviceClass;
    uint8_t bDeviceSubClass;
    uint8_t bDeviceProtocol;
    uint8_t bMaxPacketSize0;
    uint8_t bNumConfiguration;
    uint8_t bReserved;
} __attribute__ ((packed)) (USB_STD_DEV_QUALIFIER_DESC);

/************************** Constant Definitions *****************************/
/**
 * @name Request types
 * @{
 */
#define USB_REQ_TYPE_MASK       0x60    /**< Mask for request opcode */

#define USB_CMD_STDREQ          0x00    /**< Standard Request */
#define USB_CMD_CLASSREQ        0x20    /**< Class Request */
#define USB_CMD_VENDREQ         0x40    /**< Vendor Request */

#define USB_ENDPOINT_NUMBER_MASK    0x0f    /**< USB Endpoint Number Mask */
#define USB_ENDPOINT_DIR_MASK       0x80    /**< USB Endpoint Direction Mask */

#define USB_ENDPOINT_XFERTYPE_MASK      0x03    /**< USB Endpoint Transfer Type Mask */
/* @} */

/**
 * @name USB Standard Request Values
 * @{
 */
#define USB_REQ_GET_STATUS          0x00
#define USB_REQ_CLEAR_FEATURE       0x01
#define USB_REQ_SET_FEATURE         0x03
#define USB_REQ_SET_ADDRESS         0x05
#define USB_REQ_GET_DESCRIPTOR      0x06
#define USB_REQ_SET_DESCRIPTOR      0x07
#define USB_REQ_GET_CONFIGURATION   0x08
#define USB_REQ_SET_CONFIGURATION   0x09
#define USB_REQ_GET_INTERFACE       0x0a
#define USB_REQ_SET_INTERFACE       0x0b
#define USB_REQ_SYNC_FRAME          0x0c
#define USB_REQ_SET_SEL             0x30
#define USB_REQ_SET_ISOCH_DELAY     0x31
/* @} */

/**
 * @name Feature Selectors Values
 * @{
 */
#define USB_ENDPOINT_HALT           0x00
#define USB_DEVICE_REMOTE_WAKEUP    0x01
#define USB_TEST_MODE               0x02
#define USB_U1_ENABLE               0x30
#define USB_U2_ENABLE               0x31
#define USB_INTRF_FUNC_SUSPEND      0x00    /* function suspend */
/* @} */

/**
 * @name USB Standard Descriptor Types
 * @{
 */
#define USB_TYPE_DEVICE_DESC            0x01
#define USB_TYPE_CONFIG_DESC            0x02
#define USB_TYPE_STRING_DESC            0x03
#define USB_TYPE_INTERFACE_DESC         0x04
#define USB_TYPE_ENDPOINT_CFG_DESC      0x05
#define USB_TYPE_DEVICE_QUALIFIER       0x06
#define OSD_TYPE_CONFIG_DESCR           0x07
#define USB_TYPE_INTERFACE_ASSOCIATION  0x0b
#define USB_TYPE_BOS_DESC               0x0F
#define USB_TYPE_HID_DESC               0x21    // Get descriptor: HID
#define USB_TYPE_REPORT_DESC            0x22    // Get descriptor:Report
#define USB_TYPE_DFUFUNC_DESC           0x21    /* DFU Functional Desc */
#define USB_TYPE_ENDPOINT_CMP_DESC      0x30
#define USB_TYPE_SSP_ISO_ENDPOINT_CMP_DESC  0x31
/* @} */

#define USB_DEVICE_CAPABILITY_TYPE      0x10

/**
 * @name USB BOS Device Capability Types
 * @{
 */
#define USB20_EXT_DESC          0x02
#define SS_DEV_CAP_DESC         0x03
#define PLATFORM_CAP_DESC       0x05
#define SSP_DEV_CAP_DESC        0x0A
/* @} */

/**
 * @name USB Request Recipient type
 * @{
 */
#define USB_RECIPIENT_MASK         0x1F
#define USB_RECIPIENT_DEVICE       0x0
#define USB_RECIPIENT_INTERFACE    0x1
#define USB_RECIPIENT_ENDPOINT     0x2
/* @} */

/**
 * @name EndPoint Types
 * @{
 */
#define USB_EP_CONTROL          0
#define USB_EP_ISOCHRONOUS      1
#define USB_EP_BULK             2
#define USB_EP_INTERRUPT        3
/* @} */

/**
 * @name USB Device Classes
 * @{
 */
#define USB_CLASS_AUDIO         0x01
#define USB_CLASS_HID           0x03
#define USB_CLASS_STORAGE       0x08
#define USB_CLASS_MISC          0xEF
#define USB_CLASS_DFU           0xFE
#define USB_CLASS_VENDOR        0xFF
/* @} */

/**
 * @name Different endpoint maximum packet size values mask.
 * @{
 */
#define EP_MAX_PKT_SIZE_2048           0x0800                        /**< Endpoint maximum packet size 2048 */
#define EP_MAX_PKT_SIZE_1024           0x0400                        /**< Endpoint maximum packet size 1024 */
#define EP_MAX_PKT_SIZE_512            0x0200                        /**< Endpoint maximum packet size 512  */
#define EP_MAX_PKT_SIZE_256            0x0100                        /**< Endpoint maximum packet size 256  */
#define EP_MAX_PKT_SIZE_64             0x0040                        /**< Endpoint maximum packet size 64   */
#define EP_MAX_PKT_SIZE_32             0x0020                        /**< Endpoint maximum packet size 32   */
#define EP_MAX_PKT_SIZE_16             0x0010                        /**< Endpoint maximum packet size 16   */
#define EP_MAX_PKT_SIZE_8              0x0008                        /**< Endpoint maximum packet size 8    */
/* @} */

#ifdef __cplusplus
}
#endif

#endif /* LSC_USB_CH9_H_ */

/** @} */
