/*   ==================================================================
     >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
     ------------------------------------------------------------------
     Copyright (c) 2006-2024 by Lattice Semiconductor Corporation
     ALL RIGHTS RESERVED
     ------------------------------------------------------------------

     IMPORTANT: THIS FILE IS AUTO-GENERATED BY LATTICE RADIANT Software.

     Permission:

        Lattice grants permission to use this code pursuant to the
        terms of the Lattice Corporation Open Source License Agreement.

     Disclaimer:

        Lattice provides no warranty regarding the use or functionality
        of this code. It is the user's responsibility to verify the
        user Software design for consistency and functionality through
        the use of formal Software validation methods.

     ------------------------------------------------------------------

     Lattice Semiconductor Corporation
     111 SW Fifth Avenue, Suite 700
     Portland, OR 97204
     U.S.A

     Email: techsupport@latticesemi.com
     Web: http://www.latticesemi.com/Home/Support/SubmitSupportTicket.aspx
     ================================================================== */
#include <stddef.h>
#include "i2c_master.h"
#include "i2c_master_regs.h"
//#include "reg_access.h"
#include "../lsc_usb_dev.h"
#include "pic.h"

#define DEBUG_LATT_I2C

#ifdef DEBUG_LATT_I2C
#define LATT_I2C(msg, ...) sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LATT_I2C(msg, ...)
#endif

//extern _Response *resp;



uint8_t i2c_master_read(struct i2cm_instance * this_i2cm,
			uint16_t address,
			uint8_t read_length, uint8_t * data_buffer)
{
	uint8_t fifo_status = 0;
	uint8_t i2c_int2 = 0;
	uint8_t data_count = 0;
	uint8_t i2c_status = 1;
	// assert this_i2cm and data_buffer
	if (NULL == this_i2cm ||NULL == data_buffer )
	{
		return 1;
	}

	// config the register before issue the transaction
	reg_8b_write(this_i2cm->base_address | REG_BYTE_CNT, read_length);

    reg_8b_write(this_i2cm->base_address | REG_SLAVE_ADDR_LOW,
              address & 0x7F);

    if(this_i2cm->addr_mode==I2CM_ADDR_10BIT_MODE)  // 10-bit mode
    {
        reg_8b_write(this_i2cm->base_address | REG_SLAVE_ADDR_HIGH,
                  (address>>7) & 0x03);
    }

    // set ti read mode
    reg_8b_modify(this_i2cm->base_address | REG_MODE, I2C_TXRX_MODE, I2C_TXRX_MODE);


    if(this_i2cm->state == I2CM_STATE_IDLE)
    {
    	this_i2cm->state = I2CM_STATE_READ;
    	reg_8b_write(this_i2cm->base_address | REG_CONFIG, I2C_START);
    }
    else
    {
    	return 1;
    }
	// check i2c status

#if !INT_MODE
    // clear I2C_ERR bits if set
    reg_8b_read(this_i2cm->base_address | REG_INT_STATUS2, &i2c_int2);
    reg_8b_write(this_i2cm->base_address | REG_INT_STATUS2, i2c_int2);

	while(1){
        //Read the FIFO status register
		reg_8b_read(this_i2cm->base_address | FIFO_STATUS_REG, &fifo_status);

		// if rx fifo not empty, read a byte
		if ( (fifo_status & RX_FIFO_EMPTY_MASK) == 0 )
	    {
            if (data_count <= read_length) {

            	reg_8b_read(this_i2cm->base_address |
                        REG_DATA_BUFFER, data_buffer);
            }
            // update the counter and data buffer pointer
            data_buffer++;
            data_count++;
	    }

	    if(read_length == data_count)
	    {
	    	i2c_status = 0;
	    	this_i2cm->state = I2CM_STATE_IDLE;
	    	break;
	    }

	    // check for I2C errors
	    reg_8b_read(this_i2cm->base_address | REG_INT_STATUS2, &i2c_int2);
        if (i2c_int2 & I2C_ERR)
        {
			// reset the i2c master
			reg_8b_modify(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_RESET, I2C_MASTER_RESET);
			reg_8b_modify(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_RESET, ~I2C_MASTER_RESET);

        	i2c_status = 1;
        	this_i2cm->state = I2CM_STATE_IDLE;
            break;
        }
	}
#else
    this_i2cm->rx_buff = data_buffer;
    this_i2cm->rcv_length = 0;
#endif
	return i2c_status;
}



uint8_t i2c_master_repeated_start(struct i2cm_instance *this_i2cm,
		uint16_t address,
		uint8_t wr_data_size ,uint8_t * wr_data_buffer , uint8_t rd_data_size , uint8_t * rd_data_buffer)
{

	uint8_t data_count = 0;
	uint8_t i2c_status = 0;
	uint8_t status = 0;
	uint8_t i2c_int2 = 0;
	uint8_t fifo_status = 0;

	if (NULL == this_i2cm || NULL == wr_data_buffer )
	{
		LATT_I2C("I2C Pointer is null or wr_data_buffer is Null\r\n"); //test only
		return 1;
	}

	// config the register before issue the transaction
	reg_8b_write(this_i2cm->base_address | REG_BYTE_CNT, wr_data_size);

	reg_8b_write(this_i2cm->base_address | REG_SLAVE_ADDR_LOW,
		      address & 0x7F);

    if(this_i2cm->addr_mode==I2CM_ADDR_10BIT_MODE)  // 10-bit mode
    {
        reg_8b_write(this_i2cm->base_address | REG_SLAVE_ADDR_HIGH,
	              (address>>8) & 0x03);
    }

    // set to write mode
    reg_8b_modify(this_i2cm->base_address | REG_MODE, I2C_TXRX_MODE, 0);

    // clear status bits
    reg_8b_read(this_i2cm->base_address | REG_INT_STATUS1, &status);
    reg_8b_write(this_i2cm->base_address | REG_INT_STATUS1, status);
    reg_8b_read(this_i2cm->base_address | REG_INT_STATUS2, &i2c_int2);
    reg_8b_write(this_i2cm->base_address | REG_INT_STATUS2, i2c_int2);

    while (data_count < wr_data_size)
    {
    	// check tx fifo level,
        reg_8b_read(this_i2cm->base_address | REG_INT_STATUS1, &status);

		// if tx fifo is full, stop loading fifo for now, resume in interrupt or polling loop
		if ( (status & TX_FIFO_FULL_MASK) != 0 ) {
			break;
		}

        reg_8b_write(this_i2cm->base_address | REG_DATA_BUFFER, *wr_data_buffer);  // push the data into tx buffer

        // update the counter and data buffer pointer
        wr_data_buffer++;
        data_count++;
    }

    if(this_i2cm->state == I2CM_STATE_IDLE)
    {
    	// start the transaction
    	this_i2cm->state = I2CM_STATE_WRITE;
    	reg_8b_write(this_i2cm->base_address | REG_CONFIG, I2C_START | I2C_MASTER_REPEATED_START);


    }
    else
    {
    	LATT_I2C("Failed State == not in IDLE 1 - I2C state = 0x%02x \r\n", this_i2cm->state);
    	return 1;
    }

#if !INT_MODE
    // check the status until transfer done
    while(1)
    {
    	// cycle completes when all bytes are transmitted or a NACK is received or an ERROR is detected
    	reg_8b_read(this_i2cm->base_address | REG_INT_STATUS1, &status);
        if (status & I2C_TRANSFER_COMP_MASK)
        {
        	this_i2cm->state = I2CM_STATE_IDLE;
            break;
        }


    	// still have bytes to send
		if (data_count < wr_data_size)
		{
			// load any additional bytes into tx fifo when it becomes almost empty
			reg_8b_read(this_i2cm->base_address | FIFO_STATUS_REG, &fifo_status);
			if (fifo_status & TX_FIFO_AEMPTY_MASK)	// if tx fifo is almost empty
			{
				reg_8b_write(this_i2cm->base_address | REG_DATA_BUFFER, *wr_data_buffer);  // push the data into tx buffer

				// update the counter and data buffer pointer
				wr_data_buffer++;
				data_count++;
			}
        }

        // check for I2C errors including NACK
    	reg_8b_read(this_i2cm->base_address | REG_INT_STATUS2, &i2c_int2);
        if (i2c_int2 & I2C_ERR)
        {
			// reset the i2c master
			reg_8b_modify(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_RESET, I2C_MASTER_RESET);
			reg_8b_modify(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_RESET, ~I2C_MASTER_RESET);

        	i2c_status = 1;
        	this_i2cm->state = I2CM_STATE_IDLE;
            break;
        }
    }
#endif

    //To perform read transaction of a combined I2C transaction:
	fifo_status = 0;
	i2c_int2 = 0;
	data_count = 0;
	i2c_status = 1;
	//this_i2cm->state = I2CM_STATE_IDLE;


	// assert this_i2cm and data_buffer
	if (NULL == this_i2cm ||NULL == rd_data_buffer )
	{
		LATT_I2C("I2C Pointer is null or rd_data_buffer is Null\r\n"); //test only
		return 1;
	}

	// config the register before issue the transaction
	reg_8b_write(this_i2cm->base_address | REG_BYTE_CNT, rd_data_size);

    reg_8b_write(this_i2cm->base_address | REG_SLAVE_ADDR_LOW,
              address & 0x7F);

    if(this_i2cm->addr_mode==I2CM_ADDR_10BIT_MODE)  // 10-bit mode
    {
        reg_8b_write(this_i2cm->base_address | REG_SLAVE_ADDR_HIGH,
                  (address>>8) & 0x03);
    }

    // set ti read mode
    reg_8b_modify(this_i2cm->base_address | REG_MODE, I2C_TXRX_MODE, I2C_TXRX_MODE);


    if(this_i2cm->state == I2CM_STATE_IDLE)
    {
    	this_i2cm->state = I2CM_STATE_READ;
    	reg_8b_write(this_i2cm->base_address | REG_CONFIG, I2C_START);
    	//reg_8b_write(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_REPEATED_START);//0
    }
    else
    {
    	//LATT_I2C("Failed State == not in IDLE 2 - I2C state = 0x%02x \r\n", this_i2cm->state);
    	return 1;
    }


#if !INT_MODE
    // clear I2C_ERR bits if set
    reg_8b_read(this_i2cm->base_address | REG_INT_STATUS2, &i2c_int2);
    reg_8b_write(this_i2cm->base_address | REG_INT_STATUS2, i2c_int2);

	while(1){

		reg_8b_read(this_i2cm->base_address | FIFO_STATUS_REG, &fifo_status);

		// if rx fifo not empty, read a byte
		if ( (fifo_status & RX_FIFO_EMPTY_MASK) == 0 )
	    {
            if (data_count <= rd_data_size) {

            	reg_8b_read(this_i2cm->base_address |
                        REG_DATA_BUFFER, rd_data_buffer);
            }
            // update the counter and data buffer pointer
            rd_data_buffer++;
            data_count++;
	    }

	    if(rd_data_size == data_count)
	    {
	    	i2c_status = 0;
	    	this_i2cm->state = I2CM_STATE_IDLE;
	    	break;
	    }

	    // check for I2C errors
	    reg_8b_read(this_i2cm->base_address | REG_INT_STATUS2, &i2c_int2);
        if (i2c_int2 & I2C_ERR)
        {
			// reset the i2c master
			reg_8b_modify(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_RESET, I2C_MASTER_RESET);
			reg_8b_modify(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_RESET, ~I2C_MASTER_RESET);

        	i2c_status = 1;
        	this_i2cm->state = I2CM_STATE_IDLE;
            break;
        }
	}
#else
    this_i2cm->rx_buff = rd_data_buffer;
    this_i2cm->rcv_length = 0;
#endif
	return i2c_status;

}


uint8_t i2c_master_write(struct i2cm_instance * this_i2cm,
			 uint16_t address,
			 uint8_t data_size, uint8_t * data_buffer)
{
	uint8_t data_count = 0;
	uint8_t i2c_status = 0;
	uint8_t status = 0;
	uint8_t i2c_int2 = 0;
	uint8_t fifo_status = 0;
	uint8_t data_temp_buff[64] = {0};

	for(int z = 0; z < data_size; z++){

		data_temp_buff[z] = data_buffer[z];
	}


	if (NULL == this_i2cm || NULL == data_buffer )
	{
		LATT_I2C("NULL /r/n");
		return 1;
	}

	// config the register before issue the transaction
	reg_8b_write(this_i2cm->base_address | REG_BYTE_CNT, data_size);

	reg_8b_write(this_i2cm->base_address | REG_SLAVE_ADDR_LOW,
		      address & 0x7F);



	if(this_i2cm->addr_mode==I2CM_ADDR_10BIT_MODE)  // 10-bit mode
    {
        reg_8b_write(this_i2cm->base_address | REG_SLAVE_ADDR_HIGH,
	              (address>>8) & 0x03);
    }

    // set to write mode
    reg_8b_modify(this_i2cm->base_address | REG_MODE, I2C_TXRX_MODE, 0);



    // clear status bits
    reg_8b_read(this_i2cm->base_address | REG_INT_STATUS1, &status);
    reg_8b_write(this_i2cm->base_address | REG_INT_STATUS1, status);
    reg_8b_read(this_i2cm->base_address | REG_INT_STATUS2, &i2c_int2);
    reg_8b_write(this_i2cm->base_address | REG_INT_STATUS2, i2c_int2);

    while (data_count < data_size)
    {
    	// check tx fifo level,
        reg_8b_read(this_i2cm->base_address | REG_INT_STATUS1, &status);

		// if tx fifo is full, stop loading fifo for now, resume in interrupt or polling loop
		if ( (status & TX_FIFO_FULL_MASK) != 0 ) {
			LATT_I2C(" TX FIFO full \r\n");
			break;
		}

		reg_8b_write(this_i2cm->base_address | REG_DATA_BUFFER, data_temp_buff[data_count]);

        // update the counter and data buffer pointer
        data_buffer++;
        data_count++;
    }
    LATT_I2C("\r\n");


    LATT_I2C("STATE: 0x%x \r\n", this_i2cm->state);

    if(this_i2cm->state == I2CM_STATE_IDLE)
    {
    	LATT_I2C("START I2C transaction \r\n");
    	// start the transaction
    	this_i2cm->state = I2CM_STATE_WRITE;
    	reg_8b_write(this_i2cm->base_address | REG_CONFIG, I2C_START);
    }
    else
    {
    	LATT_I2C("Not IDLE while attempting Write state\r\n");
    	return 1;
    }

#if !INT_MODE

    LATT_I2C("Polling Mode Activated \r\n");
    // check the status until transfer done
    while(1)
    {
    	// cycle completes when all bytes are transmitted or a NACK is received or an ERROR is detected
    	reg_8b_read(this_i2cm->base_address | REG_INT_STATUS1, &status);
        if (status & I2C_TRANSFER_COMP_MASK)
        {
        	LATT_I2C(" Transfer complete check= 0x%02x EXITING......\r\n", status);
        	this_i2cm->state = I2CM_STATE_IDLE;
            break;
        }


    	// still have bytes to send
		if (data_count < data_size)
		{
			// load any additional bytes into tx fifo when it becomes almost empty
			reg_8b_read(this_i2cm->base_address | FIFO_STATUS_REG, &fifo_status);
			if (fifo_status & TX_FIFO_AEMPTY_MASK)	// if tx fifo is almost empty
			{
				reg_8b_write(this_i2cm->base_address | REG_DATA_BUFFER, *data_buffer);  // push the data into tx buffer

				// update the counter and data buffer pointer
				data_buffer++;
				data_count++;
			}
        }

        // check for I2C errors including NACK
    	reg_8b_read(this_i2cm->base_address | REG_INT_STATUS2, &i2c_int2);
    	LATT_I2C(" I2C Error Check = 0x%02x \r\n", i2c_int2);


        if (i2c_int2 & I2C_ERR)
        {
        	LATT_I2C(" I2C Error Exiting.... \r\n");
        	if(i2c_int2 & 0x01){
        		LATT_I2C(" Timeout Error \r\n");
        	}

        	if(i2c_int2 & 0x02){
        		LATT_I2C(" ARB_LOST ERROR \r\n");

        	}
        	if(i2c_int2 & 0x04){
        		LATT_I2C(" ABORT_ACK ERROR \r\n");

        	}
        	if(i2c_int2 & 0x08){
        		LATT_I2C(" NACK ERROR \r\n");
        	}
			// reset the i2c master
			reg_8b_modify(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_RESET, I2C_MASTER_RESET);
			reg_8b_modify(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_RESET, ~I2C_MASTER_RESET);

        	i2c_status = 1;
        	this_i2cm->state = I2CM_STATE_IDLE;
            break;
        }
    }
#endif


    LATT_I2C("i2c_status: 0x%x \r\n", i2c_status);
	return i2c_status;
}


void i2c_master_isr(void *ctx)
{

	LATT_I2C("Inside I2C ISR subroutine! \r\n");
	uint8_t i2c_int1 = 0;
	uint8_t i2c_int2 = 0;

	volatile struct i2cm_instance* this_i2cm = (struct i2cm_instance *)ctx;

	reg_8b_read(this_i2cm->base_address | REG_INT_STATUS1, &i2c_int1);
	reg_8b_read(this_i2cm->base_address | REG_INT_STATUS2, &i2c_int2);

	reg_8b_write(this_i2cm->base_address | REG_INT_STATUS1, i2c_int1);
	reg_8b_write(this_i2cm->base_address | REG_INT_STATUS2, i2c_int2);

	if(i2c_int1 & I2C_TRANSFER_COMP_MASK)
	{
		this_i2cm->state = I2CM_STATE_IDLE;
	}

	if(i2c_int1 & RX_FIFO_RDY_MASK)
	{
		if((this_i2cm->state == I2CM_STATE_READ) && (this_i2cm->rx_buff != NULL))
		{
			reg_8b_read(this_i2cm->base_address |
			                        REG_DATA_BUFFER, this_i2cm->rx_buff);
			LATT_I2C(" I2C ISR response =  0x%02x \r\n",  this_i2cm->rx_buff);
			this_i2cm->rx_buff ++;
			this_i2cm->rcv_length ++;
		}
	}

	if(i2c_int2 & I2C_ERR)
	{
		// reset the i2c master
		reg_8b_modify(this_i2cm->base_address | REG_CONFIG, I2C_MASTER_RESET, I2C_MASTER_RESET);

		this_i2cm->state = I2CM_STATE_IDLE;

	}
}

int8_t lattice_i2c_mastr_tx_rx(struct i2cm_instance *this_i2cm, uint16_t address, uint8_t wr_data_size ,uint8_t * wr_data_buffer , uint8_t rd_data_size , uint8_t * rd_data_buffer)
{ 
	LATT_I2C(" Handle I2C Operation\r\n");

    if ( ( wr_data_size != 0) && ( rd_data_size != 0) ) {
        LATT_I2C("Write-Read I2C Op\r\n");
        if ((i2c_master_repeated_start(this_i2cm, address, wr_data_size,  wr_data_buffer, rd_data_size, rd_data_buffer)) == 0){

            LATT_I2C(" Write-Read-Data: ");
            for(uint8_t y =0 ; y < rd_data_size; y++){
                LATT_I2C(" 0x%x ", rd_data_buffer[y]);
                resp->response_buf[y] = rd_data_buffer[y];
             }
             LATT_I2C("\r\n");
        }
        else{

        	LATT_I2C(" ** ERROR I2C Write Read Op\r\n");
            return 1;

        }
    }
    else if ( ( wr_data_size > 0) && ( rd_data_size == 0) ) {
          LATT_I2C(" Write I2C Op\r\n");
          if ((i2c_master_write(this_i2cm, address, wr_data_size, wr_data_buffer)) == 0)
          {
        	      LATT_I2C(" Write-Data O.K: ");
				  for(uint8_t x =0 ; x < wr_data_size; x++){
						  LATT_I2C(" 0x%x ", wr_data_buffer[x]);
					   }
					   LATT_I2C("\r\n");
          }
          else{
        	  LATT_I2C(" ** ERROR I2C Write Op\r\n");
                return 1;
          }
    }
    else if ( ( wr_data_size == 0) && ( rd_data_size > 0) ) {
           LATT_I2C(" Read I2C Op\r\n");
           if ((i2c_master_read (this_i2cm, address, rd_data_size, rd_data_buffer))==0){

               LATT_I2C(" Read-Response: ");
               for(uint8_t a =0 ; a < rd_data_size; a++){
                  LATT_I2C(" 0x%x ", rd_data_buffer[a]);
                  resp->response_buf[a] = rd_data_buffer[a];
               }
               LATT_I2C("\r\n");

           }
           else{

        	   LATT_I2C(" ** ERROR I2C Read Op\r\n");
                return 1;
           }
    }

    return 0; 
}

uint8_t i2c_master_init(struct i2cm_instance *this_i2c_m,
			uint32_t base_addr)
{
	if (NULL == this_i2c_m) {
        return 1;
	}

	this_i2c_m->base_address = base_addr;
	this_i2c_m->addr_mode = 0;
	this_i2c_m->state = I2CM_STATE_IDLE;
	this_i2c_m->interrupts_en = 0;
	this_i2c_m->rx_buff = NULL;
	this_i2c_m->rcv_length = 0;
	this_i2c_m->i2c_irq = 0;

	return 0;
}

uint8_t i2c_master_config(struct i2cm_instance * this_i2cm)
{
	uint8_t ret = 0;
	if (NULL == this_i2cm) {
        return 1;
	}

	uint16_t I2C_interrupts = this_i2cm->interrupts_en;
	uint8_t i2c_mode = this_i2cm->addr_mode;

	reg_8b_write(this_i2cm->base_address | REG_INT_ENABLE1,I2C_interrupts);
	reg_8b_write(this_i2cm->base_address | REG_INT_ENABLE2,I2C_interrupts >> 8);

    // address mode set, 7-bit/10-bit mode
	if(this_i2cm->addr_mode != i2c_mode)
	{
		this_i2cm->addr_mode = i2c_mode;
		if (i2c_mode == I2CM_ADDR_10BIT_MODE) {
			reg_8b_modify(this_i2cm->base_address | REG_MODE,
					I2C_ADDR_MODE, I2C_ADDR_MODE);
		}
	}

    // Register I2C ISR into Interrupt Controller
    if (!(ret = pic_isr_register(this_i2cm->i2c_irq, i2c_master_isr, this_i2cm))) {
    	LATT_I2C( "i2c_isr success\r\n");
    } else {
    	LATT_I2C( "i2c_isr FAILED! r\n");
        return 1;
    }

	return 0;
}




