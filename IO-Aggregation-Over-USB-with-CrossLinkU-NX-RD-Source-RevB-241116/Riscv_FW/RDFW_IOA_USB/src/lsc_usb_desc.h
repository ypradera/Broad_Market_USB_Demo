/****************************************************************************/
/**
 *
 * @file lsc_usb_desc.h
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#ifndef LSC_USB_DESC_H_
#define LSC_USB_DESC_H_

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/
#include "lsc_usb_ch9.h"
#include "lsc_winsub.h"

/************************** Constant Definitions ****************************/
#define USB20_BCD       0x0210  /**< USB20 BCD Value. */
#define USB3_BCD        0x0320  /**< USB30 BCD Value. */
#define USB_VID         0x2AC1  /**< Lattice Vendor ID. */
#define USB_PID         0xFD00  /**< Lattice Product ID. */

#define USB_MAX_PACKET0_SS 9    /**< Control endpoint's max packet size for USB 3.0. */
#define USB_MAX_PACKET0_HS 64   /**< Control endpoint's max packet size for USB 2.0. */

#define BCD_DEV         0x0010  /**< USB BCD Value. */

/**
 *  @brief bmAttributes in Configuration Descriptor
 *   common for hi-speed and superspeed
 */
#define USB_CONFIG_POWERED_MASK                0xC0
#define USB_CONFIG_BUS_POWERED                 0x80 // Reserved bit (bit 1) must be 1 according to spec.
#define USB_CONFIG_SELF_POWERED                0xC0 // Reserved bit (bit 1) must be 1 according to spec.
#define USB_CONFIG_REMOTE_WAKEUP               0x20

#define NUM_OF_ENDPOINT     0x2 /**< Number of Endpoints in Device Configuration. */

/************************** TypeDef Definitions *****************************/
/**
 *  @brief USB20 Device Descriptor Data.
 */
USB_STD_DEV_DESC __attribute__ ((aligned(4))) u20_device_desc = {
        sizeof(USB_STD_DEV_DESC), /* bLength */
        USB_TYPE_DEVICE_DESC, /* bDescriptorType */
        USB20_BCD, /* bcdUSB */
        0x00, /* bDeviceClass */
        0x00, /* bDeviceSubClass */
        0x00, /* bDeviceProtocol */
        USB_MAX_PACKET0_HS, /* bMaxPacketSize0 */
        USB_VID, /* idVendor */
        USB_PID, /* idProduct */
        BCD_DEV, /* bcdDevice */
        0x01, /* iManufacturer */
        0x02, /* iProduct */
        0x03, /* iSerialNumber */
        0x01 /* bNumConfigurations */
};

/**
 *  @brief USB30 Device Descriptor Data.
 */
USB_STD_DEV_DESC __attribute__ ((aligned(4))) u30_device_desc = {
        sizeof(USB_STD_DEV_DESC), /* bLength */
        USB_TYPE_DEVICE_DESC, /* bDescriptorType */
        USB3_BCD, /* bcdUSB */
        0x00, /* bDeviceClass */
        0x00, /* bDeviceSubClass */
        0x00, /* bDeviceProtocol */
        USB_MAX_PACKET0_SS, /* bMaxPacketSize0 */
        USB_VID, /* idVendor */
        USB_PID, /* idProduct */
        BCD_DEV, /* bcdDevice */
        0x01, /* iManufacturer */
        0x02, /* iProduct */
        0x03, /* iSerialNumber */
        0x01 /* bNumConfigurations */
};

/**
 *  @brief USB20 High Speed Configuration Descriptor Data.
 */
LSC_USB20_CFG_DESC __attribute__ ((aligned(4))) u20_config_desc_hs = {{
//Standard Configuration Descriptor
        sizeof(USB_STD_CFG_DESC), /* bLength */
        USB_TYPE_CONFIG_DESC, /* bDescriptorType */
        sizeof(LSC_USB20_CFG_DESC), /* wTotalLength */
        0x01, /* bNumInterfaces */
        0x01, /* bConfigurationValue */
        0x00, /* iConfiguration */
        (USB_CONFIG_SELF_POWERED | USB_CONFIG_REMOTE_WAKEUP), /* bmAttribute */
        0x32 /* bMaxPower  */
},

{
//Standard Interface Descriptor
        sizeof(USB_STD_IF_DESC), /* bLength */
        USB_TYPE_INTERFACE_DESC, /* bDescriptorType */
        0x00, /* bInterfaceNumber */
        0x00, /* bAlternateSetting */
        NUM_OF_ENDPOINT, /* bNumEndPoints */
        0xFF, /* bInterfaceClass */
        0x00, /* bInterfaceSubClass */
        0xFF, /* bInterfaceProtocol */
        0x00 /* iInterface */
},

{
//Bulk In Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x81, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        EP_MAX_PKT_SIZE_512, /* wMaxPacketSize */
        0x01, /* bInterval */
},

{
//Bulk Out Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x01, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        EP_MAX_PKT_SIZE_512, /* wMaxPacketSize */
        0x01 /* bInterval */
}};

/**
 *  @brief USB20 Full Speed Configuration Descriptor Data.
 */
LSC_USB20_CFG_DESC __attribute__ ((aligned(4))) u20_config_desc_fs = {{
//Standard Configuration Descriptor
        sizeof(USB_STD_CFG_DESC), /* bLength */
        USB_TYPE_CONFIG_DESC, /* bDescriptorType */
        sizeof(LSC_USB20_CFG_DESC), /* wTotalLength */
        0x01, /* bNumInterfaces */
        0x01, /* bConfigurationValue */
        0x00, /* iConfiguration */
        (USB_CONFIG_SELF_POWERED | USB_CONFIG_REMOTE_WAKEUP), /* bmAttribute */
        0x32 /* bMaxPower  */
},

{
//Standard Interface Descriptor
        sizeof(USB_STD_IF_DESC), /* bLength */
        USB_TYPE_INTERFACE_DESC, /* bDescriptorType */
        0x00, /* bInterfaceNumber */
        0x00, /* bAlternateSetting */
        NUM_OF_ENDPOINT, /* bNumEndPoints */
        0xFF, /* bInterfaceClass */
        0x00, /* bInterfaceSubClass */
        0xFF, /* bInterfaceProtocol */
        0x00 /* iInterface */
},

{
//Bulk In Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x81, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        EP_MAX_PKT_SIZE_64, /* wMaxPacketSize */
        0x01, /* bInterval */
},

{
//Bulk Out Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x01, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        EP_MAX_PKT_SIZE_64, /* wMaxPacketSize */
        0x01 /* bInterval */
}};

/**
 *  @brief USB30 Configuration Descriptor Data.
 */
LSC_USB30_CFG_DESC __attribute__ ((aligned(4))) u30_config_desc = {{
//Standard Configuration Descriptor
        sizeof(USB_STD_CFG_DESC), /* bLength */
        USB_TYPE_CONFIG_DESC, /* bDescriptorType */
        sizeof(LSC_USB20_CFG_DESC), /* wTotalLength */
        0x01, /* bNumInterfaces */
        0x01, /* bConfigurationValue */
        0x00, /* iConfiguration */
        USB_CONFIG_SELF_POWERED, /* bmAttribute */
        0x00 /* bMaxPower  */
},

{
//Standard Interface Descriptor
        sizeof(USB_STD_IF_DESC), /* bLength */
        USB_TYPE_INTERFACE_DESC, /* bDescriptorType */
        0x00, /* bInterfaceNumber */
        0x00, /* bAlternateSetting */
        NUM_OF_ENDPOINT, /* bNumEndPoints */
        0xFF, /* bInterfaceClass */
        0x00, /* bInterfaceSubClass */
        0xFF, /* bInterfaceProtocol */
        0x00 /* iInterface */
},

{
//Bulk In Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x81, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        0x0400, /* wMaxPacketSize */
        0x01 /* bInterval */
},

{
//SS Endpoint Companion descriptor
        sizeof(USB_STD_EP_SS_COMP_DESC),/* bLength */
        USB_TYPE_ENDPOINT_CMP_DESC, /* bDescriptorType */
        0x0F, /* bMaxBurst */
        0x00, /* bmAttributes */
        0x00 /* wBytesPerInterval */
},

{
//Bulk Out Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x02, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        0x0400, /* wMaxPacketSize */
        0x01 /* bInterval */
},

{
//SS Endpoint Companion descriptor
        sizeof(USB_STD_EP_SS_COMP_DESC),/* bLength */
        USB_TYPE_ENDPOINT_CMP_DESC, /* bDescriptorType */
        0x0F, /* bMaxBurst */
        0x00, /* bmAttributes */
        0x00 /* wBytesPerInterval */
}, };

/**
 *  @brief Device Qualifier Descriptor Data.
 */
USB_STD_DEV_QUALIFIER_DESC __attribute__ ((aligned(4))) device_qual_desc = {
        sizeof(USB_STD_DEV_QUALIFIER_DESC), /* bLength */
        USB_TYPE_DEVICE_QUALIFIER, /* bDescriptorType */
        USB20_BCD, /* bcdUSB */
        0xFF, /* bDeviceClass */
        0x00, /* bDeviceSubClass */
        0xFF, /* bDeviceProtocol */
        USB_MAX_PACKET0_HS, /* bMaxPacketSize0 */
        0x1, /* bNumConfiguration */
        0x0 /* bReserved */
};

/**
 *  @brief Other Speed High Speed Configuration Descriptor Data.
 */
LSC_USB20_CFG_DESC __attribute__ ((aligned(4))) u20_oth_speed_cfg_desc_hs = {{
//Standard Configuration Descriptor
        sizeof(USB_STD_CFG_DESC), /* bLength */
        OSD_TYPE_CONFIG_DESCR, /* bDescriptorType */
        sizeof(LSC_USB20_CFG_DESC), /* wTotalLength */
        0x01, /* bNumInterfaces */
        0x01, /* bConfigurationValue */
        0x00, /* iConfiguration */
        (USB_CONFIG_SELF_POWERED | USB_CONFIG_REMOTE_WAKEUP), /* bmAttribute */
        0x32 /* bMaxPower  */
},

{
//Standard Interface Descriptor
        sizeof(USB_STD_IF_DESC), /* bLength */
        USB_TYPE_INTERFACE_DESC, /* bDescriptorType */
        0x00, /* bInterfaceNumber */
        0x00, /* bAlternateSetting */
        NUM_OF_ENDPOINT, /* bNumEndPoints */
        0xFF, /* bInterfaceClass */
        0x00, /* bInterfaceSubClass */
        0xFF, /* bInterfaceProtocol */
        0x00 /* iInterface */
},

{
//Bulk In Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x81, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        0x0200, /* wMaxPacketSize */
        0x01 /* bInterval */
},

{
//Bulk Out Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x02, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        0x0200, /* wMaxPacketSize */
        0x01 /* bInterval */
}};

/**
 *  @brief Other Speed Full Speed Configuration Descriptor Data.
 */
LSC_USB20_CFG_DESC __attribute__ ((aligned(4))) u20_oth_speed_cfg_desc_fs = {{
//Standard Configuration Descriptor
        sizeof(USB_STD_CFG_DESC), /* bLength */
        OSD_TYPE_CONFIG_DESCR, /* bDescriptorType */
        sizeof(LSC_USB20_CFG_DESC), /* wTotalLength */
        0x01, /* bNumInterfaces */
        0x01, /* bConfigurationValue */
        0x00, /* iConfiguration */
        (USB_CONFIG_SELF_POWERED | USB_CONFIG_REMOTE_WAKEUP), /* bmAttribute */
        0x32 /* bMaxPower  */
},

{
//Standard Interface Descriptor
        sizeof(USB_STD_IF_DESC), /* bLength */
        USB_TYPE_INTERFACE_DESC, /* bDescriptorType */
        0x00, /* bInterfaceNumber */
        0x00, /* bAlternateSetting */
        NUM_OF_ENDPOINT, /* bNumEndPoints */
        0xFF, /* bInterfaceClass */
        0x00, /* bInterfaceSubClass */
        0xFF, /* bInterfaceProtocol */
        0x00 /* iInterface */
},

{
//Bulk In Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x81, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        0x040, /* wMaxPacketSize */
        0x01 /* bInterval */
},

{
//Bulk Out Endpoint Descriptor
        sizeof(USB_STD_EP_DESC), /* bLength */
        USB_TYPE_ENDPOINT_CFG_DESC, /* bDescriptorType */
        0x02, /* bEndpointAddress */
        USB_EP_BULK, /* bmAttribute  */
        0x040, /* wMaxPacketSize */
        0x01 /* bInterval */
}};

/**
 *  @brief String Descriptor Data.
 */
static uint8_t string_desc[6][128] = {"Language ID", "Lattice Semiconductor",
        "Lattice USB23", "00000001", "Config 1", "Default Interface"};

/**
 *  @brief BOS Descriptor Data.
 */
LSC_USB_BOS_DESC __attribute__ ((aligned(4))) bos_desc = {{
//BOS descriptor
        sizeof(USB_STD_BOS_DESC), /* bLength */
        USB_TYPE_BOS_DESC, /* DescriptorType */
        sizeof(LSC_USB_BOS_DESC), /* wTotalLength */
        0x02 /* bNumDeviceCaps */
},

{
//USB20 Device Ext Capability descriptor
        sizeof(USB_STD_U20_DEVICE_EXT_DESC), /* bLength */
        USB_DEVICE_CAPABILITY_TYPE, /* bDescriptorType */
        USB20_EXT_DESC, /* bDevCapabiltyType */
        0x02 /*0x06*/ /* bmAttributes */
},

{
//Platform Capability descriptor
        (sizeof(USB_STD_PLATFORM_CAP_DESC)), /* bLength */
        USB_DEVICE_CAPABILITY_TYPE, /* bDescriptorType */
        PLATFORM_CAP_DESC, /*bDevCapabilityType*/
        0x00, /*bReserved*/
        0xDF, 0x60, 0xDD, 0xD8,  // MS_OS_20_Platform_Capability_ID -
        0x89, 0x45, 0xC7, 0x4C, // {D8DD60DF-4589-4CC7-9CD2-659D9E648A9F}
        0x9C, 0xD2, 0x65, 0x9D,  //
        0x9E, 0x64, 0x8A, 0x9F,  //
        /* CapabilityData  */
        0x00, 0x00, 0x03, 0x06, /* dwWindowsVersion  */
        0x4A, 0x01, /* wMSOSDescriptorSetTotalLength - 0x14A */
        WINUSB_REQ, /* bMS_VendorCode  */
        0x00 /* bAltEnumCode  */
}};

#ifdef __cplusplus
}
#endif

#endif /* LSC_USB_DESC_H_ */

/** @} */
