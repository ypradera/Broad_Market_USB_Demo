/**************************************************
* Broad Market Design Engineering Release Rev 1.9.6 *
***************************************************/
 Included in this release: 
     Script: rev04
     FW:     rev1.9.6

   New: - Cleanup of source code and comments
   
   - Python Script can run a Demo if run with no parameters and can also be executed by passing parameters for the independent user use.
	- Usage: *.py interface# Operation# Payload: Separated by spaces 
	- Interface Options: GPIO = 1, I2C = 2, SPI = 3 
	- Operation Options: Read = 0  Write = 1 WriteRead = 2

   - Cleanup FW design and python script.
   - Response 0xe for error related to write operations (Subsequent Read needs to happen to read the response buffer). Omit if dont need.
   
   - Check I2C and SPI 64byte data Packet operation handling  
         I2C ( 1 byte Target Address + 2 byte TX length  + 2 byte RX length +  2byte Offset  + 57byte Data )
         SPI ( 1byte Command + 3byte Offset Address + 60bytes Data ) 
    
   - GPIO Read of Bank status and Write  (GPIO Interface 0 configured)
           - Design contains 2 pins assigned 
                1- GPIO Interface 0 bit 0 routes to pin connected to LED0
                2- GPIO Interface 0 bit 1 routes to pin 7 on J11 (connect to GND or VCC for demostration when reading status from GPIO)

   - I2C Read, Write, Read after Write (I2C Interface 0 configured )
       - SCL Pin 3 of J11
       - SDA Pin 4 of J11
       - An EEPROM with I2C interface was use to verify the functionality 

   - SPI 
       - New: Interrupt base mechanism 
       - Simple SPI functionality check done 
       - Onboard NX33U evaluation board SPI FLASH is being used as a test subject (Model: GD25Q128ESIG)

  Functionality have been checked using the python script provided.
  This Design is using Lattice USB Protocol which utilizes Control Transfer for all the interfaces.
   - At this moment all Configuration related items from Lattice USB Protocol are handled by default in the FW. 
       - Please change in the Riscv FW if you wish to modify the interfaces.
       - Refer to main.c for the initialization of the interfaces.  


   