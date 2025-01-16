################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/lsc_command.c \
../src/lsc_ctrl_xfer.c \
../src/lsc_endpoint.c \
../src/lsc_ep0_handler.c \
../src/lsc_ep_handler.c \
../src/lsc_intr.c \
../src/lsc_reg_access.c \
../src/lsc_usb_ch9.c \
../src/lsc_usb_dev.c \
../src/lsc_usb_event.c \
../src/lsc_usb_vendor.c \
../src/lscusb.c \
../src/main.c \
../src/utils.c 

OBJS += \
./src/lsc_command.o \
./src/lsc_ctrl_xfer.o \
./src/lsc_endpoint.o \
./src/lsc_ep0_handler.o \
./src/lsc_ep_handler.o \
./src/lsc_intr.o \
./src/lsc_reg_access.o \
./src/lsc_usb_ch9.o \
./src/lsc_usb_dev.o \
./src/lsc_usb_event.o \
./src/lsc_usb_vendor.o \
./src/lscusb.o \
./src/main.o \
./src/utils.o 

C_DEPS += \
./src/lsc_command.d \
./src/lsc_ctrl_xfer.d \
./src/lsc_endpoint.d \
./src/lsc_ep0_handler.d \
./src/lsc_ep_handler.d \
./src/lsc_intr.d \
./src/lsc_reg_access.d \
./src/lsc_usb_ch9.d \
./src/lsc_usb_dev.d \
./src/lsc_usb_event.d \
./src/lsc_usb_vendor.d \
./src/lscusb.d \
./src/main.d \
./src/utils.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c src/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-none-embed-gcc -march=rv32imc -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DLSCC_STDIO_UART_APB -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/gpio" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/i2c_controller" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/riscv_mc" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/spi_controller" -I"C:\Users\whan\Documents\AppProject\USB_LIFCL_NX33U\RD_IOA_USB2_REVB\Riscv_FW\RDFW_IOA_USB/src/bsp/driver/uart" -std=gnu11 --specs=picolibc.specs -DPICOLIBC_DOUBLE_PRINTF_SCANF -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


