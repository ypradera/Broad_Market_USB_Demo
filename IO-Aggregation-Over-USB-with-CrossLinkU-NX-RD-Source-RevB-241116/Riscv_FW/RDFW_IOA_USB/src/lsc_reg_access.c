/****************************************************************************/
/**
 *
 * @file lsc_reg_access.c
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#include "lsc_usb_dev.h"

/**
 *  @fn uint8_t lsc_8_read (uint32_t reg_addr)
 *  @brief This function reads 1 byte of data from memory.
 *  @param reg_addr Address from which data to be read
 *
 *  @return Returns 8-bit data on success.
 *
 */
uint8_t lsc_8_read (uint32_t reg_addr)
{
    uint8_t reg_8b_value = 0;
    reg_8b_read(reg_addr, &reg_8b_value);

    return reg_8b_value;
}

/**
 *  @fn uint8_t lsc_8_write (uint32_t reg_addr, uint8_t value)
 *  @brief This function writes 1 byte of data to memory.
 *  @param reg_addr Address to which data to be write
 *  @param value Data to write into memory
 *
 *  @return Returns 0 on success.
 *
 */
uint8_t lsc_8_write (uint32_t reg_addr, uint8_t value)
{
    reg_8b_write(reg_addr, value);

    return 0;
}

/**
 *  @fn uint8_t lsc_16_read (uint32_t reg_addr)
 *  @brief This function reads 2 byte of data from memory.
 *  @param reg_addr Address from which data to be read
 *
 *  @return Returns 16-bit data on success.
 *
 */
uint16_t lsc_16_read (uint32_t reg_addr)
{
    unsigned short reg_16b_value = 0;
    reg_16b_read(reg_addr, &reg_16b_value);

    return reg_16b_value;
}

/**
 *  @fn uint8_t lsc_16_write (uint32_t reg_addr, unsigned short value)
 *  @brief This function writes 2 byte of data to memory.
 *  @param reg_addr Address to which data to be write
 *  @param value Data to write into memory
 *
 *  @return Returns 0 on success.
 *
 */
uint8_t lsc_16_write (uint32_t reg_addr, unsigned short value)
{
    reg_16b_write(reg_addr, value);

    return 0;
}

/**
 *  @fn uint8_t lsc_32_read (uint32_t reg_addr)
 *  @brief This function reads 4 byte of data from memory.
 *  @param reg_addr Address from which data to be read
 *
 *  @return Returns 32-bit data on success.
 *
 */
uint32_t lsc_32_read (uint32_t reg_addr)
{
    uint32_t reg_32b_value = 0;
    reg_32b_read(reg_addr, (uint32_t*)&reg_32b_value);

    return reg_32b_value;
}

/**
 *  @fn uint8_t lsc_32_write (uint32_t reg_addr, uint32_t value)
 *  @brief This function writes 4 byte of data to memory.
 *  @param reg_addr Address to which data to be write
 *  @param value Data to write into memory
 *
 *  @return Returns 0 on success.
 *
 */
uint8_t lsc_32_write (uint32_t reg_addr, uint32_t value)
{
    reg_32b_write(reg_addr, value);

    return 0;
}

extern struct uart_instance *g_stdio_uart;

int lsc_uart_tx(char *c) {
    #ifdef LSCC_STDIO_UART_APB
        int ret = EOF;
        while (*c != '\0') {
            ret = uart_putc(g_stdio_uart, *c++);
        }
        return ret;
    #else
        return EOF;
    #endif
}

/** @} */
