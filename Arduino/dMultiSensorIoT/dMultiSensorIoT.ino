#include <SoftwareSerial.h>

#include <Wire.h>
#include "BlueDot_BME280.h"

BlueDot_BME280 bme1;                                     //Object for Sensor 1
BlueDot_BME280 bme2;                                     //Object for Sensor 2

int bme1Detected = 0;                                    //Checks if Sensor 1 is available
int bme2Detected = 0;                                    //Checks if Sensor 2 is available

SoftwareSerial esp8266(2,3); // RX, TX

// WiFi instellingen SSID en wachtwoord.
String SSIDstring = ("\"DCCN-TG-WORKSHOP-WLAN\"");
String PASSstring = ("\"ohjeeTG!\"");

// IP and port
String IPstring = ("\"192.168.1.7\"");
String PORTstring = ("\"8883\"");
String PortSendstring = ("\"8883\"");
String PortRecvstring = ("\"8884\"");

// to convert to string a float
static float f_val = 123.6794;
static char outstr[15];

short int timeout = 300;
boolean flag_time_out = false;

boolean flag_udp = true;
boolean flag_mode_1 = false;


void setup() 
{
           Serial.begin(9600); // Start de seriele monitor op 9600 baud.
          
           //ini the bme280
           ini_bme280();
           
           esp8266.begin(9600); // Start de software monitor op 9600 baud

           Serial.println("\r\n----- [ RESET THE MODULE (RST) ] -----");  
           sendData("AT+RST\r\n", 1000, true); // Reset de ESP module. 

                                     
}

void loop() 
{        
           // UDP mode
           if (flag_udp){
               UDP_mode(SSIDstring, PASSstring);
           }  
}


void UDP_mode(String SSIDstring, String PASSstring)
{
           sendData("AT+CWMODE=3\r\n", 1000, true);                                    // softAP+station mode
           sendData("AT+CWJAP=" + SSIDstring + "," + PASSstring + "\r\n", 3000, true); // SSID and password of router      
           sendData("AT+CIFSR\r\n", 2000, true);                                       // which IP? it should give us the IP but we never get it

           sendData("AT+CIPSERVER=1,8889\r\n", 3000, true); //needs to be here otherwise it would not work
           sendData("AT+CIPMODE=1\r\n", 2000, true);        //allow multiple connections                
           sendData("AT+CIPSTART=\"UDP\",\"192.168.1.7\",4001,5001,0\r\n", 1000, true);// we send our data through the port 4001. we receive at 5001. Be carefull at the parameters,after 
                                                                                       // the ports we can put:0,1,2,3. It works with 0 as a parameter not with the others.
           
           sendData("AT+CIPSEND\r\n", 1000, true); // send data, this means will send data without explicetly say it all the time.   
           sendData("AT+CIPDINFO=1\r\n", 1000, true); 
           sendData("AT+CIPSTATUS\r\n", 1000, true);

           float val = -145.00;
           String response = "";
           while(flag_udp)
           {               

               //we read if there is something to read at the esp8266
               String buffer="";
               char c;             

               while (esp8266.available()>0)
               {
                            c= esp8266.read();
                            buffer+=c;
                               
               }
               Serial.print(buffer); 

               if(flag_time_out){
                     long int time = millis(); 
                     while( (time+timeout) > millis())
                     {                
                           while (esp8266.available()>0)
                           {
                                c= esp8266.read();
                                buffer+=c;
                               
                           }
                     }
                     Serial.print(buffer);     
               }      
               else
               {                
                    
               }
            
               // we get the data from the sensors
              if (bme1Detected)
              {
                    val = bme1.readTempC();
              }      
               //delay(10);
               dtostrf( val,7, 2, outstr); //7 is 7 chacters long with 3 characters after the decimal point

               // we pack data and stream it
               esp8266.print('{');Serial.write('{');esp8266.print('{');Serial.write('{');
               for(int i=0;i<7;i++)
               {
                 esp8266.print(outstr[i]);
                 Serial.write(outstr[i]); 
               }
               esp8266.print('}');Serial.write('}'); esp8266.print('}');Serial.write('}');
               Serial.write('\n');
          
           }         
}


String sendData(String command, const int timeout, boolean debug) 
{
           String response = "";
           esp8266.print(command); 
           long int time = millis();
           while( (time+timeout) > millis()) 
           {
                while(esp8266.available()) 
                { 
                  char c = esp8266.read(); 
                  Serial.write(c);
                  response+=c;
                }
           }

           //esp8266.flush(); 
           return response;
}





/////////////////////////// HERE THE TE bme280


// TO HAVE IN ACCOUNT!
// SD0 has to be connected to vdd(0x76) or gnd (0x77) in order to use both sensors in the same bus.
// Jose




void ini_bme280()
{

  //Serial.begin(9600); //I comment this because I actually set it at the beginning
  Serial.println(F("Basic Weather Station"));

  //*********************************************************************
  //*************BASIC SETUP - SAFE TO IGNORE**************************** 
  
  //This program is set for the I2C mode

    bme1.parameter.communication = 0;                    //I2C communication for Sensor 1 (bme1)
    bme2.parameter.communication = 0;                    //I2C communication for Sensor 2 (bme2)
    

  
  //*********************************************************************
  //*************BASIC SETUP - SAFE TO IGNORE****************************
    
  //Set the I2C address of your breakout board  

    bme1.parameter.I2CAddress = 0x76;                    //I2C Address for Sensor 1 (bme1)
    bme2.parameter.I2CAddress = 0x77;                    //I2C Address for Sensor 2 (bme2)

    
  
  //*********************************************************************
  //*************ADVANCED SETUP - SAFE TO IGNORE*************************
    
  //Now choose on which mode your device will run
  //On doubt, just leave on normal mode, that's the default value

  //0b00:     In sleep mode no measurements are performed, but power consumption is at a minimum
  //0b01:     In forced mode a single measured is performed and the device returns automatically to sleep mode
  //0b11:     In normal mode the sensor measures continually (default value)
  
    bme1.parameter.sensorMode = 0b11;                    //Setup Sensor mode for Sensor 1
    bme2.parameter.sensorMode = 0b11;                    //Setup Sensor mode for Sensor 2 


                  
  //*********************************************************************
  //*************ADVANCED SETUP - SAFE TO IGNORE*************************
  
  //Great! Now set up the internal IIR Filter
  //The IIR (Infinite Impulse Response) filter suppresses high frequency fluctuations
  //In short, a high factor value means less noise, but measurements are also less responsive
  //You can play with these values and check the results!
  //In doubt just leave on default

  //0b000:      factor 0 (filter off)
  //0b001:      factor 2
  //0b010:      factor 4
  //0b011:      factor 8
  //0b100:      factor 16 (default value)

    bme1.parameter.IIRfilter = 0b100;                   //IIR Filter for Sensor 1
    bme2.parameter.IIRfilter = 0b100;                   //IIR Filter for Sensor 2

    

  //*********************************************************************
  //*************ADVANCED SETUP - SAFE TO IGNORE*************************

    //Next you'll define the oversampling factor for the humidity measurements
  //Again, higher values mean less noise, but slower responses
  //If you don't want to measure humidity, set the oversampling to zero

  //0b000:      factor 0 (Disable humidity measurement)
  //0b001:      factor 1
  //0b010:      factor 2
  //0b011:      factor 4
  //0b100:      factor 8
  //0b101:      factor 16 (default value)

    bme1.parameter.humidOversampling = 0b101;            //Humidity Oversampling for Sensor 1
    bme2.parameter.humidOversampling = 0b101;            //Humidity Oversampling for Sensor 2

    

  //*********************************************************************
  //*************ADVANCED SETUP - SAFE TO IGNORE*************************
  
  //Now define the oversampling factor for the temperature measurements
  //You know now, higher values lead to less noise but slower measurements
  
  //0b000:      factor 0 (Disable temperature measurement)
  //0b001:      factor 1
  //0b010:      factor 2
  //0b011:      factor 4
  //0b100:      factor 8
  //0b101:      factor 16 (default value)

    bme1.parameter.tempOversampling = 0b101;              //Temperature Oversampling for Sensor 1
    bme2.parameter.tempOversampling = 0b101;              //Temperature Oversampling for Sensor 2

    

  //*********************************************************************
  //*************ADVANCED SETUP - SAFE TO IGNORE*************************
  
  //Finally, define the oversampling factor for the pressure measurements
  //For altitude measurements a higher factor provides more stable values
  //On doubt, just leave it on default
  
  //0b000:      factor 0 (Disable pressure measurement)
  //0b001:      factor 1
  //0b010:      factor 2
  //0b011:      factor 4
  //0b100:      factor 8
  //0b101:      factor 16 (default value)  

    bme1.parameter.pressOversampling = 0b101;             //Pressure Oversampling for Sensor 1
    bme2.parameter.pressOversampling = 0b101;             //Pressure Oversampling for Sensor 2 

     
  
  //*********************************************************************
  //*************ADVANCED SETUP - SAFE TO IGNORE*************************
  
  //For precise altitude measurements please put in the current pressure corrected for the sea level
  //On doubt, just leave the standard pressure as default (1013.25 hPa);
  
    bme1.parameter.pressureSeaLevel = 1013.25;            //default value of 1013.25 hPa (Sensor 1)
    bme2.parameter.pressureSeaLevel = 1013.25;            //default value of 1013.25 hPa (Sensor 2)

  //Also put in the current average temperature outside (yes, really outside!)
  //For slightly less precise altitude measurements, just leave the standard temperature as default (15°C and 59°F);
  
    bme1.parameter.tempOutsideCelsius = 15;               //default value of 15°C
    bme2.parameter.tempOutsideCelsius = 15;               //default value of 15°C
  
    bme1.parameter.tempOutsideFahrenheit = 59;            //default value of 59°F
    bme2.parameter.tempOutsideFahrenheit = 59;            //default value of 59°F

  
    
  //*********************************************************************
  //*************ADVANCED SETUP IS OVER - LET'S CHECK THE CHIP ID!*******

  if (bme1.init() != 0x60)
  {    
    Serial.println(F("Ops! First BME280 Sensor not found!"));
    bme1Detected = 0;
  }

  else
  {
    Serial.println(F("First BME280 Sensor detected!"));
    bme1Detected = 1;
  }

  if (bme2.init() != 0x60)
  {    
    Serial.println(F("Ops! Second BME280 Sensor not found!"));
    bme2Detected = 0;
  }

  else
  {
    Serial.println(F("Second BME280 Sensor detected!"));
    bme2Detected = 1;
  }

  if ((bme1Detected == 0)&(bme2Detected == 0))
  {
    Serial.println();
    Serial.println();
    Serial.println(F("Troubleshooting Guide"));
    Serial.println(F("*************************************************************"));
    Serial.println(F("1. Let's check the basics: Are the VCC and GND pins connected correctly? If the BME280 is getting really hot, then the wires are crossed."));
    Serial.println();
    Serial.println(F("2. Did you connect the SDI pin from your BME280 to the SDA line from the Arduino?"));
    Serial.println();
    Serial.println(F("3. And did you connect the SCK pin from the BME280 to the SCL line from your Arduino?"));
    Serial.println();
    Serial.println(F("4. One of your sensors should be using the alternative I2C Address(0x76). Did you remember to connect the SDO pin to GND?"));
    Serial.println();
    Serial.println(F("5. The other sensor should be using the default I2C Address (0x77. Did you remember to leave the SDO pin unconnected?"));

    Serial.println();
    
    while(1);
  }
    
  Serial.println();
  Serial.println();

}
