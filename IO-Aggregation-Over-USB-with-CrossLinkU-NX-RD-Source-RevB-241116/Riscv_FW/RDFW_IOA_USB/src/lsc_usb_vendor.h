/**
 *
 * @file lsc_usb_vendor.h
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#ifndef LSC_USB_VENDOR_H_
#define LSC_USB_VENDOR_H_

#include "lsc_usb_dev.h"

//Enabled below macro if user wants to use big endian format for GPIO related vendor requests.
//Otherwise keep it commented.
//#define BIG_ENDIAN_FORMAT

//Enabled below macro if user wants to send requested bytes of data with padding of zero.
//Otherwise keep it commented.
//#define PADDING_EN

//#define VENDOR_REQ_MAX_SIZE    0x0200
#define VENDOR_REQ_MAX_SIZE    0x40//64 bytes

#define HEADER_LEN             0x04
#define I2C_PKT_HEADER_LEN     0x05

//cmd_type
#define CONTROL_CMD_TYPE       0x01
#define IO_REQ_CMD_TYPE        0x03

#define PARTIAL_PKT_MSK        0x0
#define ACK_FLAG_MSK           0x1
#define RESP_FLAG_MSK          0x2
#define COMPLETE_FLAG_MSK      0x4
#define ERR_FLAG_MSK           0x8




/**
 * This structure holds platform related information for I2C, and SPI
 * @{
 */
struct plat {
	  struct i2cm_instance *pI2cDev[NUM_I2C_CONTROLLER];
	  lsc_spi_dev *pSpiDev[NUM_SPI_CONTROLLER];
};
/**
 * @}
 */

#endif /* LSC_USB_VENDOR_H_ */
/** @} */
