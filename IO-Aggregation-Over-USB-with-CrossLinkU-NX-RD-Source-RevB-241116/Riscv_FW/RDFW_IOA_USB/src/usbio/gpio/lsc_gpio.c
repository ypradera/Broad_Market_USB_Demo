/****************************************************************************/
/**
 *
 * @file lsc_gpio.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

/**
 *  @file lsc_gpio.c
 *  @brief This file contains GPIO related read/write API's
 *
 *
 */

#include "gpio.h"
#include "gpio_regs.h"
#include "../lsc_usb_dev.h"

#define DEBUG_LSC_GPIO

#ifdef DEBUG_LSC_GPIO
#define LSC_GPIO(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_GPIO(msg, ...)
#endif

volatile uint32_t gpio_rd_val=0,gpio_dir=0,gpio_config=0;

/**
 *  @fn uint32_t gpio_read(uint32_t base)
 *  @brief This function perform GPIO read operation
 *  @param base Holds GPIO base address.
 *
 *  @return uint8_t
 *
 */
uint32_t gpio_read(uint32_t base)
{
    uint32_t status = 0;
    status = lsc_32_read((base));
    LSC_GPIO("status:%lx\r\n",status);
    return status;
}

/**
 *  @fn void gpio_write(uint32_t base,uint32_t write_data)
 *  @brief This function perform GPIO write operation
 *  @param base Holds GPIO base address.
 *  @param write_data Hold write data value
 *
 * @return   None.
 *
 * @note     None.
 *
 */
void gpio_write(uint32_t base,uint32_t write_data)
{
    LSC_GPIO("write_data:%lx\r\n",write_data);
    // At present LEDs have been connected to GPIO and all those are ACTIVE LOW.
    // Hence data received from application should be toggled
    // and then written on GPIO pins.
    lsc_32_write((base+GPIO_WR_DATA),write_data);
}

/**
 *  @fn void set_gpio_direction(uint32_t base, uint32_t gpio_dir)
 *  @brief This function perform GPIO get direction operation
 *  @param base Holds GPIO base address.
 *  @param gpio_dir Represents gpio direction
 *
 * @return   None.
 *
 * @note     None.
 *
 */
void set_gpio_direction(uint32_t base, uint32_t gpio_dir)
{
  LSC_GPIO("gpio_set_dir:0x%02x\r\n",gpio_dir);
        lsc_32_write(base + GPIO_DIRECTION,gpio_dir);
}


/**
 *  @fn uint8_t get_gpio_direction(uint32_t base)
 *  @brief This function perform GPIO get direction operation
 *  @param base Holds GPIO base address.
 *
 *  @return gpio_dir
 *
 */
uint8_t get_gpio_direction(uint32_t base)
{
    uint32_t gpio_dir = 0;
    gpio_dir = lsc_32_read(base + GPIO_DIRECTION);
    LSC_GPIO("gpio_dir:0x%02x\r\n",gpio_dir);
    return gpio_dir;
}


/*
 * Handle the GPIO Operation using Lattice USB Protocol
 *
 * */
uint8_t perform_gpio_operation_LATTICE(void *dev,  uint8_t *buf, uint8_t dir){
	
	//LSC_GPIO( " PERFORM GPIO OPERATION !! \r\n");

    struct lsc_usb_dev *usb_dev= dev;

    uint8_t gpio_index =0, set_gpio_dir_req = 0, get_gpio_dir_req = 0, rcvd_payload_len=0;
    uint32_t gpio_write_data = 0, gpio_read_data = 0, gpio_dir = 0, transfer_len = 0;;


	gpio_index = (usb_dev->setup_data.wIndex & 0xFF); //GPIO Controller Index Lower Byte
	rcvd_payload_len = usb_dev->setup_data.wLength;

	if( usb_dev->setup_data.wIndex >= NUM_GPIO_CONTROLLER )
    {
		LSC_GPIO( " Invalid GPIO Controller Index \r\n");
		resp->response_buf[0] = 0xe;
        return 1;
    }
    
	//LSC_GPIO("((usb_dev->setup_data.wValue) >> 8) = 0x%02x \r\n", ((usb_dev->setup_data.wValue) >> 8));
	//LSC_GPIO("((usb_dev->setup_data.wIndex) >> 8) Set/Get when Value is 1 = 0x%02x \r\n", ((usb_dev->setup_data.wIndex) >> 8));
	//LSC_GPIO("((usb_dev->setup_data.wIndex) << 8) Controller Index = 0x%02x \r\n", ((usb_dev->setup_data.wIndex) >> 8));

    if (dir == LSC_EP_DIR_OUT){
    	LSC_GPIO( " H2D <------ \r\n");

            if((usb_dev->setup_data.wValue) == GPIO_CONFIG_REQUEST){

            	//LSC_GPIO( " SET GPIO Configuration \r\n");
            	LSC_GPIO( " SET GPIO Configuration Not Supported at the moment\r\n");
            	LSC_GPIO( " Configure the GPIO as needed by modifying the FW\r\n");
            	resp->response_buf[0] = 0xe;
                return 1;

            }// Data Write 
            else if((usb_dev->setup_data.wValue) == GPIO_DATA_REQUEST){
            	LSC_GPIO(" GPIO_DATA_REQUEST \r\n ");
                for(uint8_t i = 0; i < usb_dev->setup_data.wLength; i ++){
                	//LSC_GPIO("buf[%x] = 0x%x \r\n", i, buf[i] );
                    //retrive received data depending on the request length selected by user
                    gpio_write_data = (buf[i] << (i*8)) | gpio_write_data;  //retrieve received data depending on the request length selected by user
                    //LSC_GPIO("gpio_write_data = %x \r\n", gpio_write_data );
                }
                
                //Write to IP
                gpio_output_write(&gpio_inst[gpio_index],gpio_index, gpio_write_data);
            }
            else {
                //Not expected case for Upper wValue 0x02..0xFF are Reserved at the moment
            	LSC_GPIO(" Not expected case for Upper wValue 0x02..0xFF are Reserved at the moment \r\n ");
            	resp->response_buf[0] = 0xe;
                return 1;
            }
    }
    else if (dir == LSC_EP_DIR_IN){ //D2H
    	LSC_GPIO( " ------- > D2H  \r\n");
            //GET GPIO Configuration //Upper Value has the Descriptor Type and Lower byte is not used at the moment
			if((usb_dev->setup_data.wValue) == GPIO_CONFIG_REQUEST ){

            	LSC_GPIO( " Get GPIO Configuration Not Supported at the moment\r\n");
            	resp->response_buf[0] = 0xe;
                return 1;
            }//GPIO READ
            else if((usb_dev->setup_data.wValue) == GPIO_DATA_REQUEST){
                
                //Read        
            	//LSC_GPIO("  GPIO Index = 0x%x", gpio_index);
                if(gpio_index > NUM_GPIO_CONTROLLER){
                    gpio_read_data = 0;
                    LSC_GPIO( "GPIO Index is invalid.\r\n");
                    resp->response_buf[0] = 0xe;
                    return 1;
                }
                else{
                    //read
                    gpio_input_get(&gpio_inst[gpio_index], gpio_index, (uint32_t *) &gpio_read_data);
                    LSC_GPIO("  GPIO Read DATA: 0x%02x \r\n", gpio_read_data);
                    //Fill response 
#ifdef BIG_ENDIAN_FORMAT
           resp->response_buf[0] = gpio_read_data>>24   & 0xFF;
           resp->response_buf[1] = (gpio_read_data>>16) & 0xFF;
           resp->response_buf[2] = (gpio_read_data>>8)  & 0xFF;
           resp->response_buf[3] = (gpio_read_data      & 0xFF);
#else
                    resp->response_buf[0] = gpio_read_data & 0xFF;
                    resp->response_buf[1] = (gpio_read_data >> 8)  & 0xFF; 
                    resp->response_buf[2] = (gpio_read_data >> 16) & 0xFF;
                    resp->response_buf[3] = (gpio_read_data >> 24) & 0xFF; 
#endif
                }
            }
    }
    //O.K
 return 0;
}
