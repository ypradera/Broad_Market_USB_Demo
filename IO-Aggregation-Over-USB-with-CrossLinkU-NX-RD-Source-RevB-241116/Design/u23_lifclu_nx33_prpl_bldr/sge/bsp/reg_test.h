
#ifndef REG_TEST_H_
#define REG_TEST_H_

#define reg_test_assert(cond) if (!(cond)) { printf("%s:%d\n",__FILE__,__LINE__);while(1); }

/* lscc_i2cm1_inst register definition */

#define OFFSET_LSCC_I2CM1_INST_TARGET_ADDRL_REG   0X00000004
#define MASK_LSCC_I2CM1_INST_TARGET_ADDRL_REG   0X0000007F
    

/* lscc_spim1_inst register definition */

#define OFFSET_LSCC_SPIM1_INST_CHP_SEL_REG   0X00000004
#define MASK_LSCC_SPIM1_INST_CHP_SEL_REG   0X000000FF
    

/* uart0_inst register definition */

#define OFFSET_UART0_INST_IER   0X00000004
#define MASK_UART0_INST_IER   0X00000007
    

uint8_t access_detect(uint32_t reg_addr,  uint32_t offset, uint32_t mask, char *inst_name, char *reg_name);
uint8_t mem_access_test(void);
#endif
