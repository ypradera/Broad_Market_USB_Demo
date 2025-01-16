/****************************************************************************/
/**
 *
 * @file lsc_spi.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/
/**
 *  @file lsc_spi.c
 *  @brief This file contains initialization and SPI commands processing API's
 *
 *
 */
#include "usbio/spi/lsc_spi.h"
#include "lsc_usb_dev.h"

#if ENABLE_SPI
#define DEBUG_LSC_SPI

#ifdef DEBUG_LSC_SPI
#define LSC_SPI(msg, ...)   sprintf(print_buf, msg, ##__VA_ARGS__); lsc_uart_tx(print_buf)
#else
#define LSC_SPI(msg, ...)
#endif


volatile uint8_t spi_usb_ack,word_count_reg=0;
volatile uint16_t spi_rd_tracker;

volatile uint8_t spi_wr_only;
volatile u_long wr_len, rd_len=0;
extern uint8_t spi_rx_bufr[256];

/**
 *  @fn void spi_isr(void *context)
 *  @brief SPI isr
 *  @param context Pointer to lsc_spi_dev structure context passed in registering IRQ handler
 *
 *  @return void
 *
 */
void spi_isr(void *context) {
  LSC_SPI( "Inside spi isr\r\n");
    volatile lsc_spi_dev *spi_dev = (lsc_spi_dev*) context;
    volatile uint8_t intr_status_reg = 0;
    volatile uint32_t spi_base = spi_dev->spi_base;

    volatile uint8_t fifo_sts = 0,received_data = 0;
    volatile uint16_t rd;

    // Disable Interrupt enable
    // We will enable interrupt again once we process them.
    lsc_8_write((spi_base + SPI_INT_ENABLE_REG), SPI_INT_DIS);

    intr_status_reg = lsc_8_read(spi_base + SPI_INT_STATUS_REG);
    lsc_8_write((spi_base + SPI_INT_STATUS_REG), intr_status_reg);

    spi_dev->spi_intr = intr_status_reg;
    LSC_SPI( "Interrupt Status 0x%x \r\n", spi_dev->spi_intr);
    //0x89 = rx_fifo_ready + tx_fifo_empty+transfer_complete

    if (spi_dev->spi_intr) {

       // Interrupt Status Register
       intr_status_reg = spi_dev->spi_intr;

       // Assign 0 to interrupt
       spi_dev->spi_intr = 0;

       // Transfer Completion bit set
       if (((intr_status_reg & TR_CMP_INT) == TR_CMP_INT)) {
    	   //LSC_SPI( "SPI Transfer Completion bit is set\r\n");
           // If write only, we are done.
           if (spi_wr_only) {
               spi_usb_ack = 1;
               spi_dev->spi_op_ongoing = 0;

               //prepare_spi_bulk_in_resp_buf(&usb_dev); //Commented right now
               // Enable SPI Interrrupt
               lsc_8_write((spi_base + SPI_INT_ENABLE_REG), SPI_INT_EN);
               LSC_SPI( "SPI WRITE DONE! \r\n");

               return;
           } else {
               //read data
        	   LSC_SPI( " SPI IP Read Data: ");
               for (rd = 0; rd < (rd_len + wr_len); rd++) {

                   // Wait until some data is available
                   do {
                    fifo_sts = lsc_8_read(spi_base + SPI_FIFO_STS_REG);
                    //LSC_SPI( "Fifo status = 0x%02x   \r\n", fifo_sts);
                   } while ((fifo_sts & RX_FIFO_EMPTY_INT)
                           == RX_FIFO_EMPTY_INT);
                   // Read received data
                   received_data = lsc_8_read(spi_base + SPI_RD_DATA_REG);
                   //LSC_SPI( "Received data: 0x%02x   \r\n", received_data);

                   if (spi_dev->read_ignore > 0) {
                       spi_dev->read_ignore--;
                   } else {

                       spi_rx_bufr[spi_rd_tracker] = received_data;
                       resp->response_buf[spi_rd_tracker] = received_data;
                       LSC_SPI( " 0x%02x,  ", spi_rx_bufr[spi_rd_tracker]);
                       spi_rd_tracker++;

                   }
               }
               LSC_SPI( "\r\n");
               word_count_reg = lsc_8_read(spi_base + SPI_WORD_CNT_REG);
                   //LSC_SPI( "WORD COUNT %x\r\n", word_count_reg);
//                    printf ("WORD COUNT %x\r\n", word_count_reg);
//                    spi_rd_data_avail = TRUE;
               spi_usb_ack = 1;
               spi_dev->spi_op_ongoing = 0;

               //prepare_spi_bulk_in_resp_buf(&usb_dev);
               // Enable SPI Interrrupt
               lsc_8_write((spi_base + SPI_INT_ENABLE_REG), SPI_INT_EN);
               return;
           }

       } // Transfer completion interrupt service ends here

       // Enable SPI Interrrupt
       lsc_8_write((spi_base + SPI_INT_ENABLE_REG), SPI_INT_EN);
   } // Interrupt event if ends here
}
/**
 *  @fn void spi_init(lsc_spi_dev *pSpiDev,uint32_t spi_base)
 *  @brief Initilization of SPI registers.
 *  @param pSpiDev Pointer to spi device strcuture
 *  @param spi_base Holds SPI base address.
 *
 *  @return void
 *
 */
void spi_init(lsc_spi_dev *this_spi_cm, uint32_t spi_base) {

    // Initialize structure members
	this_spi_cm->spi_base = spi_base;

    // Initialize following members to 0.
	this_spi_cm->spi_tx_len = 0;
	this_spi_cm->read_ignore = 0;
	this_spi_cm->spi_op_ongoing = 0;
	this_spi_cm->spi_intr = 0;
	this_spi_cm->event = 0;
	this_spi_cm->spi_config_data=0;


    lsc_8_write((spi_base + SPI_SLAVE_SEL_REG), SLAVE_VALUE); // select slave1

    lsc_8_write((spi_base + SPI_SLV_SEL_POL_REG),SPI_POL_REG_VAL); //slave select polarity ss_o high of slave1

    // Clear pending interrupts if any during initialization.
    lsc_8_write((spi_base + SPI_INT_STATUS_REG), 0xFF);

    lsc_8_write((spi_base + SPI_INT_ENABLE_REG), SPI_INT_EN);//Enable interrupts

}

/**
 *  @fn void spi_read_write(lsc_spi_dev *pSpiDev,
        uint8_t *tx_bufr, u_long write_length,
        uint8_t *rx_bufr, u_long read_length)
 *  @brief This function performs read and write operation on spi registers.
 *  @param pSpiDev Pointer to spi device strcuture
 *  @param tx_bufr is pointer to the transmit buffer
 *  @param write_length Is write data length
 *  @param rx_bufr is pointer to the receive buffer
 *  @param read_length Is read data length
 *
 *  @return void
 *
 */
void spi_read_write(lsc_spi_dev *pSpiDev,
        uint8_t *tx_bufr, u_long write_length,
        uint8_t *rx_bufr, u_long read_length) {
    volatile uint8_t intr_status_reg=0, config_reg=0,/* word_count_reg=0,*/target_word_count=0;
    u_long write_zeros=0;
    volatile uint32_t idx, spi_base = pSpiDev->spi_base;

//    volatile uint8_t fifo_sts = 0,received_data = 0/*,spi_rd_data_avail=0*/;
//    volatile uint8_t spi_wr_only;
//    volatile uint16_t rd/*, spi_rd_tracker*/;
    spi_rd_tracker = 0;
    pSpiDev->spi_op_ongoing = 1;
    write_zeros = rd_len = read_length;
    pSpiDev->read_ignore = wr_len = write_length;
    pSpiDev->spi_tx_len = write_length;

    lsc_8_write((spi_base + SPI_CFG_REG), 0x00);
    config_reg = lsc_8_read(spi_base + SPI_CFG_REG);
    //LSC_SPI( "Config_reg =  %x\r\n", config_reg);

    lsc_8_write((spi_base + SPI_FIFO_RST_REG), 0x03); // Clear TX & RX FIFO
    lsc_8_write((spi_base + SPI_FIFO_RST_REG), 0x00);

    lsc_8_write((spi_base + SPI_WORD_CNT_RST_REG), 0xFF);

    lsc_8_write((spi_base + SPI_TGT_WORD_CNT_REG),
            (write_length + read_length));

    target_word_count = lsc_8_read(spi_base + SPI_TGT_WORD_CNT_REG);
    //LSC_SPI( "TARGET WORD COUNT %x\r\n", target_word_count);

    word_count_reg = lsc_8_read(spi_base + SPI_WORD_CNT_REG);
    //LSC_SPI( "WORD COUNT %x\r\n", word_count_reg);

    if (read_length == 0) {
        spi_wr_only = 1;
        LSC_SPI( "SPI WRITE ONLY \r\n");
    } else {
    	LSC_SPI( "SPI READ or WRITE-READ CASE \r\n");
        spi_wr_only = 0;
    }

    lsc_8_write((spi_base + SPI_INT_ENABLE_REG),SPI_INT_DIS);

    //LSC_SPI( "Write Data to SPI IP: \r\n");
    //write data rcvd from application
    for (idx = 0; idx < write_length; ++idx) {
        lsc_8_write((spi_base + SPI_WR_DATA_REG), tx_bufr[idx]);
      //  LSC_SPI( " 0x%x ", tx_bufr[idx]); // can create issues because of delay
    }
    //LSC_SPI( "\r\n");

    pSpiDev->spi_tx_len = ( pSpiDev->spi_tx_len - write_length );

    // wr-Len = 4 and rd_len = 2 // 0x90 0x00 0x00 0x00
    //we have to write zeros to read data after writing upto valid write length as per SPI protocol
    while (write_zeros > 0) {
        write_zeros--;
        lsc_8_write((spi_base + SPI_WR_DATA_REG), SPI_WRITE_ZERO);
    }
    lsc_8_write((spi_base + SPI_INT_ENABLE_REG),SPI_INT_EN);


}
#endif
/** @} */
