#!/usr/bin/env python3

# sudo pip3 install pyusb
# In order to use this script, may need to change the WinUSB driver for Lattice USB23 to libusb
# use Zadig for easy change

## importing required modules
import usb.core
import usb.util as util
import time
from datetime import datetime
import random
import sys
import errno
import time

res_str = "*"

def usbio_write_x(dev, data, bRequest, wValue, wIndex):
    bmRequestType = util.build_request_type(
                            util.CTRL_OUT,
                            util.CTRL_TYPE_VENDOR,
                            util.CTRL_RECIPIENT_DEVICE)
    wLength = data

    try:
        ret = dev.ctrl_transfer(
                bmRequestType = bmRequestType,
                bRequest = bRequest,
                wValue = wValue,
                wIndex = wIndex,
                data_or_wLength = wLength,
                timeout = 2000)

        global res_str
        #print("Write Return --->>>>  val len",data,ret)
        if ret != len(data):
            res_str = res_str.replace('*','Write Failed')
            return 0
        return ret
    except IOError as e:
        if e.errno == errno.EPIPE:
          print(e)
          if(res_str =='Read Failed'):
            res_str = res_str.replace('Read Failed','Pipe error\n')
          elif(res_str =='*'):
            res_str = res_str.replace('*','Pipe error\n')
          pass
          return 0# Handling of the error


def usbio_read_x(dev, data, bRequest, wValue, wIndex):
    bmRequestType = util.build_request_type(
                            util.CTRL_IN,
                            util.CTRL_TYPE_VENDOR,
                            util.CTRL_RECIPIENT_DEVICE)
    wLength = data

    try:
        ret = dev.ctrl_transfer(
                bmRequestType = bmRequestType,
                bRequest = bRequest,
                wValue = wValue,
                wIndex = wIndex,
                data_or_wLength = wLength,
                timeout = 2000)

        data = wLength
        #print("val len",data,ret)
        global res_str
        if ((data != len(ret)) and (ret[0] != 14)):
           res_str = res_str.replace('*','Read Failed')
           return 0
        return ret

    except IOError as e:
        if e.errno == errno.EPIPE:
          print(e)
          if(res_str =='Read Failed'):
              res_str = res_str.replace('Read Failed','Pipe error\n')
          elif(res_str =='*'):
              res_str = res_str.replace('*','Pipe error\n')
          pass
          return 0# Handling of the error

def simple_test(dev): 
    for OP in range  (1, 4, 1):#(1, 4, 1):
        #OP = 1; 
        if (OP == 1):
            print("\n ** I2C SIMPLE TEST ** ")
            for x in range (1, 2, 1):
                    
                    #target add, TX len(LSB), TX len(MSB), RX len(LSB), RX len(MSB)
                    i2c_read  =  [0x50, 0, 0, 6, 0]
                    #target add, TX len(LSB), TX len(MSB), RX len(LSB), RX len(MSB), x bytes for TX
                    i2c_write_read_w =  [0x50, 2, 0, 4, 0, 0, 0]
                    
                    #target add, TX len(LSB), TX len(MSB), RX len(LSB), RX len(MSB), x bytes for TX
                    #i2c_write_read_r =  [0x50, 2, 0, 0xf ,0, 0, 0]
                    #target addr, TX len(LSB), TX len(MSB), RX len(LSB), RX len(MSB), offset(LSB), offset(MSB), data bytes
                    i2c_write2  =  [0x50, 6, 0, 0, 0, 0, 0, 3, 9, 8, 2]
                    i2c_write1  =  [0x50, 2, 0, 0, 0, 0, 0]

                    #print("\n  I2C  Write 1 Bank0 \n") #go to 0x00 0x00
                    hsbuf = bytearray(i2c_write1)
                    ret = usbio_write_x(dev,hsbuf,1,0,0)
                    
                    time.sleep(1)

                    print("I2C Write: ")
                    print(" ".join(hex(x) for x in list(i2c_write2[7:])))
                    hsbuf = bytearray(i2c_write2)
                    ret = usbio_write_x(dev,hsbuf,1,0,0)
                
                    #print("\n 2 - I2C  Write/Read Bank0 \n")
                    hsbuf = bytearray(i2c_write_read_w)
                    ret = usbio_write_x(dev,hsbuf,1,0,0)

                    buf = bytearray(4)
                    buf = list(usbio_read_x(dev, len(buf),1,0,0))
                    print("\r\n I2C Read: ")
                    print(" ".join(hex(n) for n in list(buf)))

                

        elif (OP == 2):
            for x in range (1, 2, 1):
                print("\r\n** GPIO SIMPLE TEST ** ")

                ON  =  [1]
                OFF =  [0]

                hscmd = []
                hscmd = ON
                #print("write-Turn_ON ", hscmd)
                print("write-Turn_ON LED ")
                #hsbuf = bytearray(hscmd)
                hsbuf = bytearray(ON)
                ret = usbio_write_x(dev,hsbuf,0,0,0)
                buf = bytearray(int(len(ON)))
                buf = list(usbio_read_x(dev, len(buf),0,0,0))
                print("Response Status: ")
                print(" ".join(hex(n) for n in list(buf)))

                time.sleep(1)

                hscmd = OFF
                #print("write-Turn_OFF ", hscmd)
                print("write-Turn_OFF LED")
                hsbuf = bytearray(OFF)
                ret = usbio_write_x(dev, hsbuf,0,0,0)
                buf = bytearray(int(len(OFF)))
                buf = list(usbio_read_x(dev, len(buf), 0,0,0))
                print("Response Status: ")
                print(" ".join(hex(n) for n in list(buf)))
                
                time.sleep(1)

        elif(OP == 3): 
        
            print("\r\n** Simple SPI TEST utilizing onboard FLASH ** ")
            print("Read SPI FLash Device ID ")
            spi_flash_id = [0x04, 0x00, 0x02, 0x00, 0x90,  0x00, 0x00, 0x00]
            hsbuf = bytearray(spi_flash_id)
            ret = usbio_write_x(dev,hsbuf,2,0,0)
            #Read portion 
            buf = bytearray(spi_flash_id[2])
            buf = list(usbio_read_x(dev, len(buf),2,0,0))
            print("Response : ")
            print(" ".join(hex(n) for n in list(buf)))

            print("\r\n")
            
            
            ### SPI SE Test ###
            # Targeted SPI device is SPI flash, in order to perform this test,
            # following operations should be perf
            
            # (1) Send Write Enable command.
            # (2) Send Sector erase command.
            # (3) Poll write in progress (WIP) flag from read status register until WIP becomes 0.
            # (4) Send Write Enable command.
            # (5) Send Page program command with some known data to be written in memory.
            # (6) Poll write in progress (WIP) flag from read status register until WIP becomes 0.
            # (7) Send Page Read command and read from offset that was used during page program command.
            
            spi_write    = [0x0E, 0x00, 0x00, 0x00, 0x02, 0xFE, 0x00, 0x00, 0x08, 0x07, 0x06, 0x05, 0x04 ,0x03, 0x02, 0x01, 0x0A, 0x0B]
            spi_w_read   = [0x04, 0x00, 0x0A, 0x00, 0x03, 0xFE, 0x00, 0x00, 0x00]
            write_en     = [0x01, 0x00, 0x00, 0x00, 0x06]
            sector_erase = [0x04, 0x00, 0x00, 0x00, 0x20, 0xFE, 0x00, 0x00]
            wip          = [0x01, 0x00, 0x01, 0x00, 0x05]
            for x in range (1, 2, 1):

                
                # (1) Send Write Enable command.
                #print("Write EN \r\n")
                hsbuf = bytearray(write_en)
                ret = usbio_write_x(dev,hsbuf,2,0,0)
                
                # (2) Send Sector erase command.
                hsbuf = bytearray(sector_erase)
                ret = usbio_write_x(dev,hsbuf,2,0,0)

                # (3) Poll write in progress (WIP) flag from read status register until WIP becomes 0.
                while(1): 
                    
                    hsbuf = bytearray(wip)
                    ret = usbio_write_x(dev,hsbuf,2,0,0)
                    
                    buf = bytearray(1)
                    buf = list(usbio_read_x(dev, len(buf),2,0,0))
                    #print("Read: ")
                    #print(" ".join(hex(n) for n in list(buf)))
                
                    if((buf[0] & 0x1 ) == 0):
                        break; 
                
                # (4) Send Write Enable command.
                #print("Write EN \r\n")
                hsbuf = bytearray(write_en)
                ret = usbio_write_x(dev,hsbuf,2,0,0)

                # (5) Send Page program command with some known data to be written in memory.
                #print("Page Program \r\n")
                print("SPI Write: ")
                print(" ".join(hex(x) for x in list(spi_write[8:])))
                hsbuf = bytearray(spi_write)
                ret = usbio_write_x(dev,hsbuf,2,0,0)

                # (6) Poll write in progress (WIP) flag from read status register until WIP becomes 0.
                while(1): 
                    
                    hsbuf = bytearray(wip)
                    ret = usbio_write_x(dev,hsbuf,2,0,0)
                    buf = bytearray(1)
                    buf = list(usbio_read_x(dev, len(buf),2,0,0))
                    #print("\r\nRead: ")
                    #print(" ".join(hex(n) for n in list(buf)))
                
                    if((buf[0] & 0x1 )== 0):
                        break; 
                
                # (7) Send Page Read command and read from offset that was used during page program command.
                #print("Write-Read to check the data\r\n")
                hsbuf = bytearray(spi_w_read)
                ret = usbio_write_x(dev,hsbuf,2,0,0)
                #Read portion 
                buf = bytearray(spi_w_read[2])
                buf = list(usbio_read_x(dev, len(buf),2,0,0))
                print("\r\n SPI Read: ")
                print(" ".join(hex(n) for n in list(buf)))
                

def print_menu():
    print("Usage: *.py interface# Operation# Payload: Separated by spaces \r\n")
    print(" Interface Options: GPIO = 1, I2C = 2, SPI = 3 ")
    print(" Operation Options: Read = 0  Write = 1 WriteRead = 2")
    print(" Max size 64 bytes per transactions ")



#interface = 0
#operation = 0
#payload = [0]

def main():
    print("*" * 45)
    print("*** BROAD MARKET USB23 TEST APPLICATION ***")
    print("*" * 45)
    print_menu()

    #parameters = param()

    # find our device
    dev = usb.core.find(idVendor=0x2AC1, idProduct=0xFD00)

    # was it found?
    if dev is None:
        raise ValueError('\r\n ** Device not found **')
    else:
        print(" ** Device found! **")
        #print(dev)
        #print(util.get_string(dev, dev.iManufacturer))
        #print(util.get_string(dev, dev.iProduct))
        print("\r\n")

        if len(sys.argv) == 1:
            simple_test(dev)
        
        elif len(sys.argv) > 1:
            interface  = sys.argv[1]
            operation  = sys.argv[2]
            payload    = sys.argv[3:]
            payload  = list(map(int, payload))
            print("interface = ", interface )
            print("Operation = ", operation)
            print("Payload = ",   payload )
            
            if interface == '1': #GPIO
                        print("Handling GPIO ")
                        if operation == '0': #Read
                            buf = bytearray(int(len(payload)))
                            buf = list(usbio_read_x(dev, len(buf),0,0,0))
                            print("GPIO Status: "+ " ".join(hex(n) for n in list(buf)))
                            
                        elif operation == '1': #Write
                            print("GPIO Write: "+" ".join(hex(x) for x in list(payload)))                        
                            hsbuf = bytearray(list(payload))
                            ret = usbio_write_x(dev,hsbuf,0,0,0) 
                        else: 
                            print("Operation Not Supported for GPIO")

            elif interface == '2': #I2C
                    if operation == '0': # Read
                        print("Read bytes = ",((payload[4]<<8) | payload[3]))                      
                        buf = bytearray(((payload[4]<<8) | payload[3]))                    
                        buf = list(usbio_read_x(dev, len(buf),1,0,0))
                        print("\r\n I2C Read: " + " ".join(hex(n) for n in list(buf))) 

                    elif operation == '1': # Write
                        print("I2C Write: "+" ".join(hex(x) for x in list(payload))) 
                        hsbuf = bytearray(list(payload))
                        ret = usbio_write_x(dev,hsbuf,1,0,0)

                    elif operation == '2': # Write-Read
                        print("I2C Write-Read: "+" ".join(hex(x) for x in list(payload))) 
                        hsbuf = bytearray(payload)
                        ret = usbio_write_x(dev,hsbuf,1,0,0)
                        
                        print("Read bytes " ,((payload[4]<<8) | payload[3]))
                        buf = bytearray((payload[4]<<8) | payload[3])# TX len LSB
                        buf = list(usbio_read_x(dev, len(buf),1,0,0))
                        print("\r\n I2C Read: " + " ".join(hex(n) for n in list(buf)))
                    
                    else: 
                        print("Operation Not Supported for I2C")

            elif interface == '3': #SPI
                
                if operation == '0': # Read
                        print("Read bytes = ",((payload[3]<<8) | payload[2]))
                        buf = bytearray((payload[3]<<8) | payload[2])
                        buf = list(usbio_read_x(dev, len(buf),2,0,0))
                        print("\r\n SPI Read: " + " ".join(hex(n) for n in list(buf)))

                elif operation == '1': #Write
                        print("SPI Write: "+" ".join(hex(x) for x in list(payload))) 
                        hsbuf = bytearray(payload)
                        ret = usbio_write_x(dev,hsbuf,2,0,0)

                elif operation == '2': #Write_Read
                        print("SPI Write-Read: "+" ".join(hex(x) for x in list(payload))) 
                        hsbuf = bytearray(payload)
                        ret = usbio_write_x(dev,hsbuf,2,0,0)

                        #Read portion 
                        buf = bytearray(((payload[3]<<8)| payload[2]))
                        buf = list(usbio_read_x(dev, len(buf),2,0,0))
                        print("\r\n SPI Read: "+" ".join(hex(n) for n in list(buf)))
                else: 
                    print("Operation Not Supported for SPI")
        else:
            print(" Interface not Supported")
            print_menu()


if __name__ == "__main__":
    main()
            
    
            


