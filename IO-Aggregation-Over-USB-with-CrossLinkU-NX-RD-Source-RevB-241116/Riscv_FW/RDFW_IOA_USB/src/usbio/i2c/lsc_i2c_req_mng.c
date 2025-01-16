


#include "lsc_usb_dev.h"

#define DEBUG_LATT_I2C_REQ_MNG

#ifdef DEBUG_LATT_I2C_REQ_MNG
#define LATT_I2C_REQ_MNG(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LATT_I2C_REQ_MNG(msg,x...)
#endif

uint8_t i2c_rx_bufr[256] __attribute__ ((aligned(32))) = { 0 };
uint16_t i2c_tx_len = 0;

uint8_t i2c_tx_bufr[256] __attribute__ ((aligned(32))) = { 0 };
uint16_t i2c_rx_len = 0;


uint8_t processI2CRequest(struct lsc_usb_dev *usb_dev, uint8_t *buff, uint8_t dir){
	
    uint16_t i2c_tx_len = 0, i2c_rx_len = 0;
    uint8_t index = 0;
    uint8_t slave_addr = 0;

    //LATT_I2C_REQ_MNG( " Direction: 0x%02x  \r\n", dir);
    LATT_I2C_REQ_MNG( "  bRequestType =  0x%02x \r\n", usb_dev->setup_data.bRequestType); //1byte
	LATT_I2C_REQ_MNG( "  bRequest =      0x%02x \r\n", usb_dev->setup_data.bRequest);// 1 byte
	LATT_I2C_REQ_MNG( "  wValue =        0x%02x \r\n", usb_dev->setup_data.wValue);// 2 bytes
	LATT_I2C_REQ_MNG( "  wIndex =        0x%02x \r\n", usb_dev->setup_data.wIndex);// 2 bytes
	LATT_I2C_REQ_MNG( "  wLength =       0x%02x \r\n", usb_dev->setup_data.wLength);// 2 bytes


    index = (usb_dev->setup_data.wValue & 0xFF);


    if( index > NUM_I2C_CONTROLLER) {
        LATT_I2C_REQ_MNG(  "Invalid I2C master index\r\n" );
        resp->response_buf[0] = 0x0E;
        return 1; 
    }    
    
    if (dir == LSC_EP_DIR_OUT){ //H2D
    	LATT_I2C_REQ_MNG(  "I2C H2D handling \r\n" );
       if(usb_dev->setup_data.wLength == 0){
    	LATT_I2C_REQ_MNG(  "Data Len is zero\r\n" );
        resp->response_buf[0] = 0x0E;
        return 1; 
       }
       
       // I2C Set Configuration // Not supported at the moment !
       //When wValue  == 2 Upper byte of wIndex is used for configuration parameter: 
       // 0x00 - I2C Config Parameter 0 
       // 0x01 - I2C Config Parameter 1
       // 0x02 - I2C Config Parameter 2
       // This Parameters are related to I2C Master IP core which can be configured by user

       if((usb_dev->setup_data.wValue >> 8) == I2C_CONFIG_REQUEST){
            
            //** Temporarly not supported hence stall this request **
            LATT_I2C_REQ_MNG( "I2C Config Request\r\n" );
            if( ( usb_dev->setup_data.wIndex >> 8 ) == I2C_CONF_PARAM0 ){                    
                    LATT_I2C_REQ_MNG(  "configuration parameter1 selected\r\n" );
                    LATT_I2C_REQ_MNG(  "Not supported at the moment.\r\n" );
                    resp->response_buf[0] = 0x0E;
                    return 1;
                }
                else if( ( usb_dev->setup_data.wIndex >> 8 ) == I2C_CONF_PARAM1 ){
                    LATT_I2C_REQ_MNG(  "configuration parameter1 selected\r\n" );
                    LATT_I2C_REQ_MNG(  "Not supported at the moment.\r\n" );
                    resp->response_buf[0] = 0x0E;
                    return 1;

                }
                else if( ( usb_dev->setup_data.wIndex >> 8 ) == I2C_CONF_PARAM2 ){
                    LATT_I2C_REQ_MNG(  "configuration parameter2 selected\r\n" );
                    LATT_I2C_REQ_MNG(  "Not supported at the moment.\r\n" );
                    resp->response_buf[0] = 0x0E;
                    return 1;
                }
                else{
                    LATT_I2C_REQ_MNG(  "Invalid configuration parameter\r\n" );
                    resp->response_buf[0] = 0x0E;
                    return 1;
                }
       }//Transfer Request Case for I2C
       else if ((usb_dev->setup_data.wValue >> 8) == I2C_TRANSFER_REQUEST ){

           LATT_I2C_REQ_MNG( " --> I2C Transfer Request\r\n" );
           slave_addr = buff[0]; 
           i2c_tx_len = ((buff[2] << 8) | (buff[1]));
           i2c_rx_len = ((buff[4] << 8) | (buff[3]));

           LATT_I2C_REQ_MNG("  SLV_ADD = 0x%02x : TX_LEN = 0x%02x : RX_LEN = 0x%02x \r\n", slave_addr, i2c_tx_len, i2c_rx_len);

           if(((i2c_tx_len + i2c_rx_len) == 00) || ((i2c_tx_len + i2c_rx_len)> 0x40)){
                LATT_I2C_REQ_MNG(  " Invalid Length \r\n ");
                resp->response_buf[0] = 0x0E;
                return 1; 
           }

           //Issue I2C Operation
           if ((lattice_i2c_mastr_tx_rx(pdata->pI2cDev[index],
                                        slave_addr,
                                        i2c_tx_len , &buff[5] ,
                                        i2c_rx_len , &buff[5])) != 0 )
            {
                LATT_I2C_REQ_MNG(" I2C Operation Failed.. \r\n ");
                resp->response_buf[0] = 0x0E;
                return 1; 

            }

       }//END of transfer request  
       else if (((usb_dev->setup_data.wValue) >> 8) == LAST_I2C_TRANSFER_RESULT){
               LATT_I2C_REQ_MNG("LAST_I2C_TRANSFER_RESULT not supported at the moment\r\n" );
                resp->response_buf[0] = 0x0E;
                return 1;
       }
       else {
           LATT_I2C_REQ_MNG(" Wrong I2C Request.. \r\n ");
           resp->response_buf[0] = 0x0E;
           return 1;
       }//////////////////////
    }
    else if (dir == LSC_EP_DIR_IN){ //D2H
       LATT_I2C_REQ_MNG("I2C :: Device to Host \r\n ");
       if(usb_dev->setup_data.wLength == 0){
            LATT_I2C_REQ_MNG("Length cannot be zero \r\n ");
            resp->response_buf[0] = 0x0E;
            return 1; 
       }

       if((usb_dev->setup_data.wValue >> 8) == I2C_CONFIG_REQUEST){
                // At present, there is no configuration parameter within the I2C
                // core which can be configured via USB Host.
                // Still we have kept logic for 3 parameters for future use.
                //** Temporarly not supported hence stall this request **
                LATT_I2C_REQ_MNG( "Last I2C Transfer request\r\n" );
                if( ( usb_dev->setup_data.wIndex >> 8 ) == I2C_CONF_PARAM0 ){                    
                        LATT_I2C_REQ_MNG(  "configuration parameter1 selected\r\n" );
                        LATT_I2C_REQ_MNG(  "Not supported at the moment.\r\n" );
                        resp->response_buf[0] = 0x0E;
                        return 1;
                    }
                    else if( ( usb_dev->setup_data.wIndex >> 8 ) == I2C_CONF_PARAM1 ){
                        LATT_I2C_REQ_MNG(  "configuration parameter1 selected\r\n" );
                        LATT_I2C_REQ_MNG(  "Not supported at the moment.\r\n" );
                        resp->response_buf[0] = 0x0E;
                        return 1;
                    }
                    else if( ( usb_dev->setup_data.wIndex >> 8 ) == I2C_CONF_PARAM2 ){
                        LATT_I2C_REQ_MNG(  "configuration parameter2 selected\r\n" );
                        LATT_I2C_REQ_MNG(  "Not supported at the moment.\r\n" );
                        resp->response_buf[0] = 0x0E;
                        return 1;
                    }
                    else{
                        LATT_I2C_REQ_MNG(  "Invalid configuration parameter\r\n" );
                        resp->response_buf[0] = 0x0E;
                        return 1;
                    }
 
       }
       else if (((usb_dev->setup_data.wValue) >> 8) == LAST_I2C_TRANSFER_RESULT){
               LATT_I2C_REQ_MNG("LAST_I2C_TRANSFER_RESULT not supported at the moment\r\n" );
                resp->response_buf[0] = 0x0E;
                return 1;
       }
       //check if need to account for I2C transfer request
       else if (((usb_dev->setup_data.wValue) >> 8) == I2C_TRANSFER_REQUEST){
                 LATT_I2C_REQ_MNG(  "******  Transfer request D2H\r\n" );
                 //////////////////////////////////////////////////////////////////////////////
                 LATT_I2C_REQ_MNG( " --> I2C Transfer Request\r\n" );
                          slave_addr = buff[0];
                          i2c_tx_len = ((buff[2] << 8) | (buff[1]));
                          i2c_rx_len = ((buff[4] << 8) | (buff[3]));

                          LATT_I2C_REQ_MNG("  SLV_ADD = %x : TX_LEN = %x : RX_LEN = %x \r\n", slave_addr, i2c_tx_len, i2c_rx_len);

                          if(((i2c_tx_len == 0) && (i2c_rx_len == 0)) || i2c_rx_len > 64 || i2c_tx_len > 64){
                               LATT_I2C_REQ_MNG(  " Invalid Length \r\n ");
                               resp->response_buf[0] = 0x0E;
                               return 1;
                          }

                          //Issue I2C Operation
                          if ((lattice_i2c_mastr_tx_rx(pdata->pI2cDev[index],
                                                       slave_addr,
                                                       i2c_tx_len , &buff[5] ,
                                                       i2c_rx_len , &buff[5])) != 0 )
                           {
                               LATT_I2C_REQ_MNG(" I2C Operation Failed.. \r\n ");
                               resp->response_buf[0] = 0x0E;
                               return 1;

                           }
                 //Todo: ADD single read response
                          /////////////////////////////////////////////////////////////////////////////
       }
    }
    LATT_I2C_REQ_MNG(" Exiting the I2C Request ----> \r\n ");
  //O.K
  return  0;
}
