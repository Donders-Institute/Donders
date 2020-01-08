/*
  LiquidCrystal Library - display() and noDisplay()

 Demonstrates the use a 16x2 LCD display.  The LiquidCrystal
 library works with all LCD displays that are compatible with the
 Hitachi HD44780 driver. There are many of them out there, and you
 can usually tell them by the 16-pin interface.

 This sketch prints "Hello World!" to the LCD and uses the
 display() and noDisplay() functions to turn on and off
 the display.

 The circuit:
 * LCD RS pin to digital pin 12
 * LCD Enable pin to digital pin 11
 * LCD D4 pin to digital pin 5
 * LCD D5 pin to digital pin 4
 * LCD D6 pin to digital pin 3
 * LCD D7 pin to digital pin 2
 * LCD R/W pin to ground
 * 10K resistor:
 * ends to +5V and ground
 * wiper to LCD VO pin (pin 3)

 Library originally added 18 Apr 2008
 by David A. Mellis
 library modified 5 Jul 2009
 by Limor Fried (http://www.ladyada.net)
 example added 9 Jul 2009
 by Tom Igoe
 modified 22 Nov 2010
 by Tom Igoe
 modified 7 Nov 2016
 by Arturo Guadalupi

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/LiquidCrystalDisplay

*/


// BMx280_I2C.ino
//
// shows how to use the BMP280 / BMx280 library with the sensor connected using I2C.
//
// Copyright (c) 2018 Gregor Christandl
//
// connect the AS3935 to the Arduino like this:
//
// Arduino - BMP280 / BME280
// 3.3V ---- VCC
// GND ----- GND
// SDA ----- SDA
// SCL ----- SCL
// some BMP280/BME280 modules break out the CSB and SDO pins as well: 
// 5V ------ CSB (enables the I2C interface)
// GND ----- SDO (I2C Address 0x76)
// 5V ------ SDO (I2C Address 0x77)
// other pins can be left unconnected.


// include the library code:
#include <LiquidCrystal.h>

#include <Arduino.h>
#include <Wire.h>

#include <BMx280MI.h>

#define I2C_ADDRESS 0x77
#define I2C_ADDRESS_2 0x77

//create a BMx280I2C object using the I2C interface with I2C Address 0x76
BMx280I2C bmx280(I2C_ADDRESS);
BMx280I2C bmx280_2(I2C_ADDRESS_2);

// initialize the library by associating any needed LCD interface pin
// with the arduino pin number it is connected to
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  //lcd.print("Man, man man!");



    // put your setup code here, to run once:
	Serial.begin(9600);

	//wait for serial connection to open (only necessary on some boards)
	while (!Serial);

	Wire.begin();

	//begin() checks the Interface, reads the sensor ID (to differentiate between BMP280 and BME280)
	//and reads compensation parameters.
	if (!bmx280.begin())
	{
		Serial.println("begin() failed. check your BMx280 Interface and I2C Address.");
		while (1);
	}

	if (bmx280.isBME280())
		Serial.println("sensor is a BME280");
	else
		Serial.println("sensor is a BMP280");

	//reset sensor to default parameters.
	bmx280.resetToDefaults();

	//by default sensing is disabled and must be enabled by setting a non-zero
	//oversampling setting.
	//set an oversampling setting for pressure and temperature measurements. 
	bmx280.writeOversamplingPressure(BMx280MI::OSRS_P_x16);
	bmx280.writeOversamplingTemperature(BMx280MI::OSRS_T_x16);

	//if sensor is a BME280, set an oversampling setting for humidity measurements.
	if (bmx280.isBME280())
		bmx280.writeOversamplingHumidity(BMx280MI::OSRS_H_x16);


}

void loop() {

  ///// BMX280 SECTION

      if (!bmx280.measure())
      {
          Serial.println("could not start measurement, is a measurement already running?");
          return;
      }


      do
      {
        delay(10);
      } while (!bmx280.hasValue());

//      Serial.print("Pressure: "); Serial.println(bmx280.getPressure());
//
//      Serial.print("Temperature: "); Serial.println(bmx280.getTemperature());
//
//      if (bmx280.isBME280())
//        Serial.print("Humidity: "); Serial.println(bmx280.getHumidity());
//

        Serial.print(bmx280.getPressure()); Serial.print(" mb\t"); // Pressure in millibars
        Serial.print(bmx280.getHumidity()); Serial.print(" %\t\t");
        Serial.print(bmx280.getTemperature()); Serial.print(" *C\t\n"); 

  ///// END BMX280 SECTION


  ///// DISPLAY LCD SECTION  
      
      // Turn off the display:
      //lcd.noDisplay();
      //delay(500);

      lcd.setCursor(0,0);
      lcd.print(bmx280.getTemperature());
      lcd.setCursor(6,0); 
      lcd.print("deg");
      //lcd.setCursor(15,0);
      //lcd.print("\n");
      lcd.display();

  ///// END DISPLAY LCD SECTION

}
