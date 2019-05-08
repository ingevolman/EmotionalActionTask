//#include <Time.h>

/*-----------------------------------------------------------------------------
 * SingleTact Multisensor I2C Demo
 * 
 * Copyright (c) 2017 Pressure Profile Systems
 * Licensed under the MIT license. This file may not be copied, modified, or
 * distributed except according to those terms.
 * 
 * 
 * Demonstrates sensor input by reading I2C and display value on comm port.
 * 
 * The circuit: as described in the manual for PC interface using Arduino. 
 * 
 * To compile: Sketch --> Verify/Compile
 * To upload: Sketch --> Upload
 * 
 * For comm port monitoring: Click on Tools --> Serial Monitor
 * Remember to set the baud rate at 57600.
 * 
 * March 2017
 * ----------------------------------------------------------------------------- */


#include <Wire.h> //For I2C/SMBus
#include <TimeLib.h> // added by Inge 03-2018

#define TIME_HEADER "T" // Header tag for serial time sync message  // added by Inge 03-2018
#define TIME_REQUEST 7 // ASCII bell character requests a time sync message  // added by Inge 03-2018
//#define TIMELIB_ENABLE_MILLIS // to use millisecond,  this value can jump when time is synchronized, it is however always consistent with current time

//int m;
//int minute(time_t t);
//int second();
//int second(time_t t);
//int millisecond();

void setup()
{
  Wire.begin(); // join i2c bus (address optional for master)
  //TWBR = 12; //Increase i2c speed if you have Arduino MEGA2560, not suitable for Arduino UNO
  Serial.begin(57600);  // start serial for output
  Serial.flush();
  
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  //pinMode(13, OUTPUT);   // added by Inge 03-2018
  //setSyncProvider( requestSync);  //set function to call when sync required   // added by Inge 03-2018
  //Serial.println("Waiting for sync message");   // added by Inge 03-2018

  Serial.println("PPS UK: SingleTact multiple sensor value in PSI.");
  Serial.println("Refer manual for any other calculation.");
  Serial.println("----------------------------------------");	

}

void loop()
{
    byte i2cAddress; // Slave address (SingleTact), default 0x04
    short data;

 // if (Serial.available()) {
 //   processSyncMessage();
 // }  // added by Inge 03-2018
  
  
	/* Note: No sensor should be addressed with default 0x04 value */	
    // Reading data from sensor 1
    i2cAddress = 0x06;
    data = readDataFromSensor(i2cAddress);
    //time_t t = now(uint32_t& m);   // added by Inge 03-2018
    //time_t now();
    //time_t now(uint32_t& sysTimeMillis);
    //m = millisecond(); // added by Inge
    //Serial.print(m); // added by Inge 2017
    Serial.print(millis()); // added by Inge 2017
    //digitalClockDisplay();   // added by Inge 03-2018
    Serial.print("\t"); // added by Inge 2017
    Serial.print("1"); // adjusted by Inge 2017 for easier read in for Matlab
    Serial.print("\t"); // added by Inge 2017
    Serial.print(data);    
    Serial.print("\n");
    //delay(10); // Change this if you are getting values too quickly - commented out by Inge 2017

    // Reading data from sensor 2
    i2cAddress = 0x08;
    data = readDataFromSensor(i2cAddress);
    Serial.print(millis()); // added by Inge 2017
    //digitalClockDisplay();   // added by Inge 03-2018
    Serial.print("\t"); // added by Inge 2017
    Serial.print("2"); // adjusted by Inge 2017 for easier read in for Matlab
    Serial.print("\t"); // added by Inge 2017
    Serial.print(data);    
    Serial.print("\n");
    delay(1); // Change this if you are getting values too quickly - adjusted by Inge 2017
}


short readDataFromSensor(short address)
{
  byte i2cPacketLength = 6;//i2c packet length. Just need 6 bytes from each slave
  byte outgoingI2CBuffer[3];//outgoing array buffer
  byte incomingI2CBuffer[6];//incoming array buffer

  outgoingI2CBuffer[0] = 0x01;//I2c read command
  outgoingI2CBuffer[1] = 128;//Slave data offset
  outgoingI2CBuffer[2] = i2cPacketLength;//require 6 bytes

  Wire.beginTransmission(address); // transmit to device 
  Wire.write(outgoingI2CBuffer, 3);// send out command
  byte error = Wire.endTransmission(); // stop transmitting and check slave status
  if (error != 0) return -1; //if slave not exists or has error, return -1
  Wire.requestFrom(address, i2cPacketLength);//require 6 bytes from slave

  byte incomeCount = 0;
  while (incomeCount < i2cPacketLength)    // slave may send less than requested
  {
    if (Wire.available())
    {
      incomingI2CBuffer[incomeCount] = Wire.read(); // receive a byte as character
      incomeCount++;
    }
    else
    {
      delayMicroseconds(10); //Wait 10us 
    }
  }

  short rawData = (incomingI2CBuffer[4] << 8) + incomingI2CBuffer[5]; //get the raw data

  return rawData;
}

//void digitalClockDisplay(){
//  // digital clock display of the time
//  Serial.print(hour());
//  printDigits(minute());
//  printDigits(second());
  
  //int32_t x32 = 0;
  //unsigned long n = millis();
  //while (n == millis()){};
  //n = millis();
  //while (n == millis()) {
  //  x32++;
  //}
  //Serial.print("int32_t: ");
  //Serial.println(x32); // this part was added to deal with ms problem

  //int64_t x64 = 0;
  //n = millis();
  //while (n == millis()){};
  //n = millis();
  //while (n == millis()) {
  //  x64++;
  //}
 // x32 = (int32_t)x64;
 // Serial.print("int64_t: ");
  //Serial.println(x32); // this part was added to deal with ms problem

//  printDigits(millis());
//}

//void printDigits(int digits){
//  // utility function for digital clock display: prints preceding colon and leading 0
//  Serial.print(":");
//  //if(digits < 10)
///  //  Serial.print('0');
//  Serial.print(digits);
//}

//void processSyncMessage() {
//  unsigned long pctime;
//  const unsigned long DEFAULT_TIME = 1357041600; // Jan 1 2013

//  if(Serial.find(TIME_HEADER)) {
//     pctime = Serial.parseInt();
//     if( pctime >= DEFAULT_TIME) { // check the integer is a valid time (greater than Jan 1 2013)
//       setTime(pctime); // Sync Arduino clock to the time received on the serial port
//     }
//  }
//}

//time_t requestSync()
//{
//  Serial.write(TIME_REQUEST);  
//  return 0; // the time will be sent later in response to serial mesg
//}

