/****************************************************************************/
/**
 *
 * @file lsc_gpio.h
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#ifndef GPIO_LSC_GPIO_H_
#define GPIO_LSC_GPIO_H_

#include "gpio.h"
#include "gpio_regs.h"
#include <sys/types.h>

#define NUM_GPIO_CONTROLLER                      1 //Index 0 only configured at this moment

#define PRESERVE_CONFIG                          1
#define DEFAULT_CONFIG                           0

//#define GPIO_REQUEST                             0x0
#define GPIO_DATA_REQUEST                        0x00
#define GPIO_CONFIG_REQUEST                      0x01

#define GPIO_INDEX0_LINE_NUM                     2
//#define GPIO_INDEX1_LINE_NUM                   5
//#define GPIO_INDEX2_LINE_NUM                   5
//#define GPIO_INDEX3_LINE_NUM                   1

#define GPIO_INDEX0_DIR                            0x02 //Pin 0 = output , Pin 1 = input
#define GPIO_INDEX0_DIR_TEST                       0x03 //Pin 0 = input , Pin 1 = input
//#define GPIO_INDEX1_DIR                          0x1F
//#define GPIO_INDEX2_DIR                          0x1F
//#define GPIO_INDEX3_DIR                          0x1

#define GPIO_DEINIT                              0x00
#define GPIO_INIT                                0x01
#define GPIO_READ                                0x02
#define GPIO_WRITE                               0x03
#define GPIO_INT_EVENT                           0x04
#define GPIO_INT_MASK                            0x05
#define GPIO_INT_UNMASK                          0x06

#define PIN_MODE_MSK                             0x03
#define PIN_CONFIG_MSK                           0x0c
#define GPIO_INPUT_DIR_MSK                       0x01
#define GPIO_OUTPUT_DIR_MSK                      0x02

#define GPIO_RD_DATA                    (0x00)
#define GPIO_WR_DATA                    (0x01*4)
#define GPIO_SET_DATA                   (0x02*4)
#define GPIO_CLEAR_DATA                 (0x03*4)
#define GPIO_DIRECTION                  (0x04*4)
#define GPIO_INT_TYPE                   (0x05*4)
#define GPIO_INT_METHOD                 (0x06*4)
#define GPIO_INT_STATUS                 (0x07*4)
#define GPIO_INT_ENABLE                 (0x08*4)
#define GPIO_INT_SET                    (0x09*4)

/**
 *  @brief USBIO control packet header structure
 */

typedef struct ctrl_packet_header{
    uint8_t cmd_type;
    uint8_t cmd;
    uint8_t flags;
    uint8_t payload_len;
}__attribute__ ((packed,aligned(1))) _ctrl_packet_header;


/**
 *  @brief USBIO response format
 */
typedef union response_format
 {
    _ctrl_packet_header pkt_hd;
    uint8_t response_buf[64];
}__attribute__ ((packed,aligned(1))) _Response;

extern struct gpio_instance gpio_inst[NUM_GPIO_CONTROLLER];

//gpio related functions
uint32_t gpio_read(uint32_t base);
void gpio_write(uint32_t base,uint32_t write_data);
uint8_t get_gpio_direction(uint32_t base);
void set_gpio_direction(uint32_t base, uint32_t gpio_dir);
void perform_gpio_operation (uint8_t *buf);
uint8_t perform_gpio_operation_LATTICE(void *dev,  uint8_t *buf, uint8_t dir);
int8_t verify_gpio_bank_id(uint8_t bank_id);
#endif /* GPIO_LSC_GPIO_H_ */
/**
 * @}
 */
