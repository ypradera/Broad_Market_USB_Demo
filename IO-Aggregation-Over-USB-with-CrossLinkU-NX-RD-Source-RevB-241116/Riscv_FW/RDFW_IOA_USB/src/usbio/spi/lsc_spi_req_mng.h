/****************************************************************************/
/**
 *
 * @file lsc_spi_req_mng.h
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#ifndef LSC_SPI_REQ_MNG_H_
#define LSC_SPI_REQ_MNG_H_
#include "sys_platform.h"
#include <sys/types.h>
#include "lsc_usb_dev.h"
#include "lsc_spi.h"

#define SPI_IO_DEBUG                0x2 /**< SPI_IO_DEBUG macro set debug level of prints in SPI management commands */
#define SPI_BULK_EP_NO              0x2



// Flags
#define NO_ERR_FULL_RESP_FLAGS 0x6                /**< Indicates No Error Full Response Flag value. */

#define ERR_FULL_RESP_FLAGS 0xE                   /**< Indicates Error Full Response Flag value. */

#define NO_ERR_PARTIAL_RESP_FLAGS 0x2             /**< Indicates No Error Partial Response Flag value. */

#define ERR_PARTIAL_RESP_FLAGS 0xA                /**< Indicates Error Partial Response Flag value. */

#define PKT_COMPLETE_FLAG_MSK 0x4                /**< Indicates Complete packet flag mask. */

// 2.2.2 Data Packet Type Description
/**
 * @name Data Packet Type
 * @{
 */
#define SPI_CMD_TYPE 0x5
/**
 * @}
 */

// Section 2.4.2 SPI Commands
/**
 * @name Different SPI commands
 * @{
 */
#define SPI_DEINIT                 0x0
#define SPI_INIT                   0x1
#define SPI_READ                   0x2
#define SPI_WRITE                  0x3
#define SPI_WRITE_READ             0x4
/**
 * @}
 */

// In different SPI commands, there is one config field which is of 1 bytes.
// Bit 7 in that indicates following:
// 0: 4 Wire mode
// 1: 3 Wire mode
#define SPI_3_WIRE_MODE            0x80

//Bit 1 and 0 are chip select fields
//bit 1..0: Chip Select 0, 1, 2 or 3
#define SPI_CHIP_SEL               0x3

#define CHIP_SEL_0                 0x0
#define CHIP_SEL_1                 0x1
#define CHIP_SEL_2                 0x2
#define CHIP_SEL_3                 0x3

// SPI Read packet maximum read size
#define SPI_RD_PKT_MAX_RD_SIZE 55
#define SPI_RD_PKT_PAYLOAD_HEADER 4
#define SPI_WR_RD_PKT_MAX_RD_SIZE 53
#define SPI_WR_RD_PKT_PAYLOAD_HEADER 6

// Payload start position in SPI Write packet structure
#define SPI_WR_PAYLOAD_POSITION     9

// Payload start position in SPI Read packet structure
#define SPI_RD_PAYLOAD_POSITION     9

// Payload start position in SPI WriteRead packet structure
#define SPI_WR_RD_PAYLOAD_POSITION  11

// SPI Read Packet Header size
// It includes following items: Type, Command, Flags, Payload Length (2),
//     BusId, Config, ReadSize(2)
#define SPI_RD_PKT_HDR_SIZE 9

// SPI Write Packet Header size
// It includes following items: Type, Command, Flags, Payload Length (2),
//     BusId, Config, WriteSize(2)
#define SPI_WR_PKT_HDR_SIZE 9

// SPI Write Read Packet Header size
// It includes following items: Type, Command, Flags, Payload Length (2),
//     BusId, Config, WriteSize(2), ReadSize(2)
#define SPI_WR_RD_PKT_HDR_SIZE 11

// SPI Packet Header size
// It includes following items: Type, Command, Flags, Payload Length (2)
#define SPI_PKT_HDR_SIZE 5
//change:void
uint8_t process_spi_request(struct lsc_usb_dev *usb_dev,  uint8_t *buf, uint8_t dir);


#endif /* LSC_SPI_REQ_MNG_H_ */
/**
 * @}
 */
