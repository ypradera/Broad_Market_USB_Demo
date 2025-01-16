/**
 *  @file i2c_req_mng.h
 *  @brief This file contains macros, device structures and function
 *         definition related to I2C request management.
 */

#ifndef I2C_REQ_MNG_H_
#define I2C_REQ_MNG_H_
#include "sys_platform.h"
#include <sys/types.h>
#include "i2c_master.h"
#include "i2c_master_regs.h"
#include "../lsc_usb_dev.h"

extern struct lsc_usb_dev *usb_dev;

///////////////////////////////////////
//Might not need
#define I2C_DEINIT                 0x0
#define I2C_INIT                   0x1
#define I2C_READ                   0x2
#define I2C_WRITE                  0x3
#define I2C_WRITE_READ             0x4
//////////////////////////////////////////
/////////////////////////////////////////
#define I2C_CONF_PARAM0            0x00
#define I2C_CONF_PARAM1            0x01
#define I2C_CONF_PARAM2            0x02
/////////////////////////////////////////
#define I2C_MSTR1_IRQ                3


// In different I2C commands, there is one config field which is of 2 bytes.
// Bit 15 in that indicates following:
// 0: 7-bit address mode
// 1: 10-bit address mode
#define ADDR_MODE_7BIT             0
#define ADDR_MODE_10BIT            1

#define ADDR_MSK_7BIT              0x7f
#define ADDR_MSK_10BIT             0x3ff

#define ICP_10BIT_ADDR_MODE 0x8000

// Payload start position in I2C Write packet structure
#define I2C_WR_PAYLOAD_POSITION 10

// Payload start position in I2C WriteRead packet structure
#define I2C_WR_RD_PAYLOAD_POSITION 12

// I2C Read packet maximum read size
//#define I2C_MAX_RD_SIZE         255
#define I2C_RD_PKT_MAX_RD_SIZE 54
#define I2C_RD_PKT_PAYLOAD_HEADER 5
#define I2C_WR_RD_PKT_MAX_RD_SIZE 52
#define I2C_WR_RD_PKT_PAYLOAD_HEADER 7

#define NUM_I2C_CONTROLLER         1 // Update if want to include more I2C controllers
#define I2C_TRANSFER_REQUEST       0x00
#define LAST_I2C_TRANSFER_RESULT   0x01
#define I2C_CONFIG_REQUEST         0x02

//extern struct i2cm_instance i2c_master_core;

//Control Transfer I2C request
uint8_t processI2CRequest(struct lsc_usb_dev *usb_dev, uint8_t *buff, uint8_t dir);

#endif /* I2C_REQ_MNG_H_ */
/**
 * @}
 */
