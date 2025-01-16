/****************************************************************************/
/**
 *
 * @file lsc_spi.h
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#ifndef LSC_SPI_H_
#define LSC_SPI_H_

#include <sys/types.h>

//Enable below macro if user need to enable SPI related functionality in HAL.
#define ENABLE_SPI                  0x1
#define SPI_CONTROLLER_0            0x00041400
//#define SPI_CONTROLLER_1          //Base Address 

#define SPISR_IRQ1                  4 //defined in propel builder for SPI                                    /**< SPISR_IRQ1 */
//#define SPISR_IRQ#                # Configured in Propel Builder

#define NUM_SPI_CONTROLLER          1

#define SLAVE_VALUE                 0x01

#define SPI_READ_WRITE              1
#define SPI_REQUEST                 0x2

#define SPI_WRITE_ZERO              0x00

#define SPI_POL_REG_VAL             0x00

#define SPI_INT_EN                  0xff
#define SPI_INT_DIS                 0x00

#define SPI_CONF_PARAM0             0x00
#define SPI_CONF_PARAM1             0x01
#define SPI_CONF_PARAM2             0x02

#define FIFO_DEPTH                  256                                  /**< SPI IP FIFO DEPTH. */
#define HALF_FIFO_DEPTH             128                                  /**< SPI IP HALF_FIFO_DEPTH. */

#define SPI_TRANSFER_REQUEST        0x00
#define SPI_CONFIG_REQUEST          0x01

#define TRUE                        1
/**
 * @name SPI master IP core register offset.
 * @{
 */
#define SPI_WR_DATA_REG             0x00
#define SPI_RD_DATA_REG             0x00
#define SPI_SLAVE_SEL_REG           0x04
#define SPI_CFG_REG                 0x08
#define SPI_FIFO_RST_REG            0x2c
#define SPI_CLK_PRESCL_REG          0x0c
#define SPI_FIFO_STS_REG            0x34
#define SPI_CLK_PRESCH_REG          0x10
#define SPI_INT_STATUS_REG          0x14
#define SPI_INT_ENABLE_REG          0x18
#define SPI_INT_SET_REG             0x1c
#define SPI_WORD_CNT_REG            0x20
#define SPI_WORD_CNT_RST_REG        0X24
#define SPI_TGT_WORD_CNT_REG        0X28
#define SPI_SLV_SEL_POL_REG         0x30

/**
 * @name SPI register access command codes.
 * @{
 */
#define epcs_read                    0x03
#define epcs_pp                      0x02
#define epcs_wren                    0x06
#define epcs_wrdi                    0x04
#define epcs_rdsr                    0x05
#define epcs_wrsr                    0x01
#define epcs_se                      0x20
#define epcs_be                      0xC7
#define epcs_dp                      0xB9
#define epcs_res                     0xAB
#define epcs_rdid                    0x9F

/**
 * @name SPI IP core interrupt indicator mask for SPI_INT_STATUS_REG.
 * @{
 */
#define TR_CMP_INT                   (1<<7)
#define TX_FIFO_ALMOST_EMPTY_INT     (1<<4)
#define TX_FIFO_EMPTY_INT            (1<<3)
#define RX_FIFO_ALMOST_FULL_INT      (1<<1)
#define RX_FIFO_EMPTY_INT            (1<<0)

/**
 * @name SPI IP core interrupt enable mask for SPI_INT_ENABLE_REG.
 * @{
 */
#define TX_FIFO_ALMOST_EMPTY_INT_EN  (1<<4)
#define TX_FIFO_EMPTY_INT_EN         (1<<3)


/**
 * This typedef defines spi device structure to hold various information.
 * @{
 */
typedef struct spi_dev{
    void (*spi_isr)(void);
    volatile uint32_t spi_irq;
    volatile uint32_t spi_base;
    uint32_t spi_tx_len;
    uint32_t read_ignore;
    uint8_t *tx_buf;
    uint8_t spi_rx_bufr[256];
    uint8_t spi_op_ongoing;
    volatile uint8_t spi_intr;
    uint32_t event;
    volatile uint8_t spi_config_data;
}lsc_spi_dev;
/**
 * @}
 */

//spi related functions.
void spi_init(lsc_spi_dev *pSpiDev,uint32_t spi_base);
void spi_isr(void *context);
void spi_read_write(lsc_spi_dev *pSpiDev,
        uint8_t *tx_bufr,u_long write_length,uint8_t *rx_bufr, u_long read_length) ;
//uint32_t processSpiRequest(void *USB20DEV, int8_t stage);
#endif /* LSC_SPI_H_ */
/**
 * @}
 */
