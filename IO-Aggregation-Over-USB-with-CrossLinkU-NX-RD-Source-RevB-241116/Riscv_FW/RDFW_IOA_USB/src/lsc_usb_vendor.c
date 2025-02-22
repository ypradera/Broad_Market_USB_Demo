/**
 *
 * @file lsc_usb_vendor_io.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/
#include "lsc_usb_dev.h"


/*===========================================================================

                 LOCAL CONSTANT AND MACRO DEFINITIONS

===========================================================================*/
#define GPIO_REQUEST               0x0
#define I2C_REQUEST                0x1
#define SPI_REQUEST                0x2


#define DEBUG_LSC_USB_VENDOR

#ifdef DEBUG_LSC_USB_VENDOR
#define LSC_USB_VENDOR(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_USB_VENDOR(msg, ...)
#endif

extern uint8_t v_buf[VENDOR_REQ_MAX_SIZE] __attribute__ ((aligned(32))); //64bytes
extern _Response response;
extern uint8_t *reponse_p;
extern _Response *resp;
uint8_t IN_error_respond = 0, ret = 0;

/*****************************************************************************/
/**
 * This function handles usb device vendor specific requests.
 *
 * @param    usb_dev is a pointer to lsc_usb_dev instance.
 * @param    setup_pkt is a pointer to the data structure containing the
 *           setup request.
 *
 * @return   None.
 *
 * @note     None.
 ******************************************************************************/
void lsc_usb_vendor_req(void *dev,void *setup)
{
	LSC_USB_VENDOR(" USB VENDOR REQUEST DECODING \r\n");
    uint32_t transfer_len = 0;
    uint8_t  bmRequestType = 0, bRequest = 0; 
    uint16_t wValue = 0; 
    uint16_t wIndex = 0; 
    uint16_t wLength = 0; 
    
    struct lsc_usb_dev *usb_dev= dev;
    setup_pkt *setup_pkt = setup;
    /*
     * Direction -- USB_EP_DIR_IN or USB_EP_DIR_OUT
     *  bRequestType:
        *  D7: Data transfer direction
        *  0 = Host-to-device
        *  D6..5: Type
        *  2 = Vendor Specific
        *  D4..0: Recipient
        *  0 = Device
     */
    uint8_t dir = !!(setup_pkt->bRequestType & LSC_USB_DIR_IN);



    if (dir == LSC_EP_DIR_OUT) { //H2D 
        LSC_USB_VENDOR(" Vendor OUT Req\r\n");
        LSC_USB_VENDOR(" EP0 STATE: %x \r\n", usb_dev->ep0_state );

        switch (usb_dev->ep0_state) {

			case LSC_EP0_SETUP_PHASE:
					LSC_USB_VENDOR("Setup Phase \r\n");


					if ((setup_pkt->bRequest == 0) || \
						(setup_pkt->bRequest == 1) || \
						(setup_pkt->bRequest == 2) ) {

						lsc_usb_ep0_rcv(usb_dev, v_buf, setup_pkt->wLength);
					}else{
                        LSC_USB_VENDOR("  Invalid bRequest \r\n");
                    	lsc_usb_ep0_stall_restart(usb_dev);
					}
					break;

			case LSC_EP0_DATA_PHASE:
					LSC_USB_VENDOR("Data Parsing Phase \r\n");
					/* Operation bRequest
					* GPIO = 0x00
					* I2C = 0x01
					* SPI = 0x02
					*/

					LSC_USB_VENDOR( " <---- H2D \r\n");
					LSC_USB_VENDOR( " bRequestType =  0x%02x \r\n", usb_dev->setup_data.bRequestType); //1byte
					LSC_USB_VENDOR( " bRequest =      0x%02x \r\n", usb_dev->setup_data.bRequest);// 1 byte
					LSC_USB_VENDOR( " wValue =        0x%02x \r\n", usb_dev->setup_data.wValue);// 2 bytes
					LSC_USB_VENDOR( " wIndex =        0x%02x \r\n", usb_dev->setup_data.wIndex);// 2 bytes
					LSC_USB_VENDOR( " wLength =       0x%02x \r\n", usb_dev->setup_data.wLength);// 2 bytes

					printf("Received data from Host: ");
					for (uint32_t p = 0; p < setup_pkt->wLength; p++) {
						LSC_USB_VENDOR( " 0x%02x ", v_buf[p]);
					}
					printf("\r\n");

				   // Initialize response buffer with zero.
				   // This ensures that data filled for previous command is not
				   // returned while sending data for new command and padded bytes
				   // are always 0.
				   for (uint32_t idx = 0; idx < 64; idx++) {
					   resp->response_buf[idx] = 0;
				   }

					/////////////////////////////////////////////////////////
					switch (usb_dev->setup_data.bRequest){
						   case I2C_REQUEST:

							   LSC_USB_VENDOR("\r\n H2D I2C Request <----\r\n");
							   if (processI2CRequest(usb_dev, v_buf, dir) != 0){
								         LSC_USB_VENDOR("Returning Error\r\n");
									    //resp->response_buf[0] = 0x0E;
									    IN_error_respond = 1;
									    lsc_usb_ep0_stall_restart(usb_dev);
							   }
							   break;

						   case GPIO_REQUEST:
							       LSC_USB_VENDOR("\r\n H2D GPIO Request <----\r\n");

								   if(perform_gpio_operation_LATTICE(usb_dev, (uint8_t*)v_buf, dir) != 0){
									   LSC_USB_VENDOR("\r\n ERROR setting variable\r\n");
									   IN_error_respond = 1;
									   lsc_usb_ep0_stall_restart(usb_dev);

								   }

							   break;

						   case SPI_REQUEST:
							   LSC_USB_VENDOR("\r\n H2D SPI Request <----\r\n");

                               if ((process_spi_request(usb_dev, (uint8_t*)v_buf, dir))!= 0){

                            	   LSC_USB_VENDOR("\r\n  SPI Error <----\r\n");
                            	   IN_error_respond = 1;
                            	   lsc_usb_ep0_stall_restart(usb_dev);

                               }

							   break;

						   default: //Not Valid Vendor request
							    LSC_USB_VENDOR(" ~ Invalid bRequest ~\r\n\n");
								//USB_setStall restart EP
								lsc_usb_ep0_stall_restart(usb_dev);

						}
						break;
			default:
				break;
			}

    } else { //D2H Case
        LSC_USB_VENDOR(" Vendor IN Req\r\n");
        LSC_USB_VENDOR("----> D2H \r\n");
        LSC_USB_VENDOR( " bRequestType =  0x%02x \r\n", setup_pkt->bRequestType); //1byte
        LSC_USB_VENDOR( " bRequest =      0x%02x \r\n", setup_pkt->bRequest);// 1 byte
        LSC_USB_VENDOR( " wValue =        0x%02x \r\n", setup_pkt->wValue);// 2 bytes
        LSC_USB_VENDOR( " wIndex =        0x%02x \r\n", setup_pkt->wIndex);// 2 bytes
        LSC_USB_VENDOR( " wLength =       0x%02x \r\n", setup_pkt->wLength);// 2 bytes

           if ((setup_pkt->bRequest == 0) || \
               (setup_pkt->bRequest == 1) || \
               (setup_pkt->bRequest == 2) ) {
                    // At the moment, we only support vendor specific control transfer request
                    // wLength less than or equals to 64 bytes. This applies to vendor specific
                    if ((setup_pkt->wLength > VENDOR_REQ_MAX_SIZE) || (IN_error_respond == 1)) {
                        LSC_USB_VENDOR("Error, please check uart logs\r\n");
						IN_error_respond = 0;
                 	    resp->response_buf[0] = 0xe;
         		        reponse_p = (uint8_t*) &response;
         		        lsc_usb_ep0_send(usb_dev, reponse_p, 1);
                        lsc_usb_ep0_stall_restart(usb_dev);

                    } else {
                    	//Handle read after write response when the write failed
                    	if(setup_pkt->bRequest == 0){
                            LSC_USB_VENDOR(" ----> GPIO IN Req D2H\r\n");
							ret = perform_gpio_operation_LATTICE(usb_dev, (uint8_t*)v_buf, dir);
							if(ret == 0){transfer_len = setup_pkt->wLength;}
							else{
								transfer_len = 1;
								resp->response_buf[0] = 0x0E;
							}

                        	reponse_p = (uint8_t*) &response;
                        	LSC_USB_VENDOR("GPIO RESPONSE: ");
							for(int x = 0; x < transfer_len; x ++){
								LSC_USB_VENDOR("  0x%02x ", reponse_p[x]);
							}
							LSC_USB_VENDOR("/r/n");

                        	lsc_usb_ep0_send(usb_dev, reponse_p, transfer_len);
                        }
                        else if(setup_pkt->bRequest == 1){

                            LSC_USB_VENDOR(" ----> I2C IN Req D2H\r\n");
                            reponse_p = (uint8_t*) &response;
							transfer_len = setup_pkt->wLength;
							LSC_USB_VENDOR("I2C RESPONSE: ");
							for(int x = 0; x < transfer_len; x ++){
								LSC_USB_VENDOR("  0x%02x ", reponse_p[x]);
							}
							LSC_USB_VENDOR("/r/n");
							lsc_usb_ep0_send(usb_dev, reponse_p, transfer_len);
                        }
                        else if(setup_pkt->bRequest == 2){
                            //SPI response.. 
                            LSC_USB_VENDOR(" ----> SPI IN Req D2H\r\n");
                            if (((setup_pkt->wIndex >> 8 ) > NUM_SPI_CONTROLLER ) || \
                            	((setup_pkt->wLength) > 64)  || \
                                ((setup_pkt->wLength) == 0))
                            {
                                    LSC_USB_VENDOR("  Error in SPI D2H command\r\n");
                                    //Error conditions that can be returned on Read
                                	resp->response_buf[0] = 0x0E;
                                	reponse_p = (uint8_t*) &response;
                                	lsc_usb_ep0_send(usb_dev, reponse_p, 1);
                                	lsc_usb_ep0_stall_restart(usb_dev);
							}
							else{
								reponse_p = (uint8_t*) &response;
								transfer_len = setup_pkt->wLength;
								LSC_USB_VENDOR("  SPI RESPONSE: ");
								for(int x = 0; x < transfer_len; x ++){
									LSC_USB_VENDOR("  0x%02x ", reponse_p[x]);
								}
								LSC_USB_VENDOR("/r/n");
								lsc_usb_ep0_send(usb_dev, reponse_p, transfer_len);
                              }

                          }//end of bRequest2
                        }
           	   }//end of bRequest check
				else{
					LSC_USB_VENDOR("  Invalid bRequest \r\n");
					lsc_usb_ep0_stall_restart(usb_dev);
				}

    	}//end of D2H else case

}//end of the function

/** @} */
