################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/usbio/i2c/lsc_i2c_req_mng.c 

OBJS += \
./src/usbio/i2c/lsc_i2c_req_mng.o 

C_DEPS += \
./src/usbio/i2c/lsc_i2c_req_mng.d 


# Each subdirectory must supply rules for building sources it contributes
src/usbio/i2c/%.o: ../src/usbio/i2c/%.c src/usbio/i2c/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-none-embed-gcc -march=rv32imc -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DLSCC_STDIO_UART_APB -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/gpio" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/i2c_controller" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/riscv_mc" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/spi_controller" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/uart" -std=gnu11 --specs=picolibc.specs -DPICOLIBC_DOUBLE_PRINTF_SCANF -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


