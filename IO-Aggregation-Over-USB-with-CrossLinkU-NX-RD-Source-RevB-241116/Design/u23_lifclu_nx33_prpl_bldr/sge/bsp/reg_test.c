
#include "stdio.h"
#include "stdint.h"
#include "reg_access.h"
#include "reg_test.h"
#include "sys_platform.h"

#if REG_TEST_ENABLE
uint8_t access_detect(uint32_t reg_addr,uint32_t offset,uint32_t mask,  char *inst_name, char *reg_name)
{
    uint8_t access_success = 0;
    uint32_t reg_32b_value = 0;

    reg_32b_write( reg_addr + offset, 0x5A5A5A5A & mask);
    reg_32b_read(reg_addr + offset, &reg_32b_value);

    if( reg_32b_value == (0x5A5A5A5A & mask))
    {
        reg_32b_write( reg_addr + offset, 0xA5A5A5A5 & mask);
        reg_32b_read(reg_addr + offset, &reg_32b_value);
        if( reg_32b_value == (0xA5A5A5A5 & mask))
            access_success = 1;
    }
    else
    {
        access_success = 0;
        printf("access_detect fail, inst: %s, register: %s, 0x%lx\n", inst_name, reg_name, (reg_addr + offset));
    }
    return access_success;
}

uint8_t mem_access_test(void)
{
    uint8_t ret = 1;
    
#ifdef LSCC_I2CM1_INST_BASE_ADDR    

    ret *= access_detect(LSCC_I2CM1_INST_BASE_ADDR, OFFSET_LSCC_I2CM1_INST_TARGET_ADDRL_REG, MASK_LSCC_I2CM1_INST_TARGET_ADDRL_REG, "lscc_i2cm1_inst", "TARGET_ADDRL_REG");
#endif 

#ifdef LSCC_SPIM1_INST_BASE_ADDR    

    ret *= access_detect(LSCC_SPIM1_INST_BASE_ADDR, OFFSET_LSCC_SPIM1_INST_CHP_SEL_REG, MASK_LSCC_SPIM1_INST_CHP_SEL_REG, "lscc_spim1_inst", "CHP_SEL_REG");
#endif 

#ifdef UART0_INST_BASE_ADDR    

    ret *= access_detect(UART0_INST_BASE_ADDR, OFFSET_UART0_INST_IER, MASK_UART0_INST_IER, "uart0_inst", "IER");
#endif 

    return ret;
}
#endif
