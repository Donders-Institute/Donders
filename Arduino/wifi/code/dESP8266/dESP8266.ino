#include <SoftwareSerial.h>
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
           esp8266.begin(9600); // Start de software monitor op 9600 baud
                    
           Serial.println("\r\n----- [ RESET THE MODULE (RST) ] -----");  
           sendData("AT+RST\r\n", 1000, true); // Reset de ESP module. 
                                     
}

void loop() 
{        
           
           // mode_1
           if (flag_mode_1){
              ATCommands(SSIDstring, PASSstring);
                
           }   


           // UDP mode
           if (flag_udp){
               UDP_mode(SSIDstring, PASSstring);
           }

           // Waiting for comands via serie
           if(Serial.available())
           {               
                    
                      String ch;
                      ch = Serial.readString();
                      ch.trim();
                      if(ch=="on"||ch=="ON"){

                         flag_udp = true;
                      }
                      else
                      {
                         // send some command to the esp8266
                         esp8266.write( Serial.read() );  
                      }
                      
           }
           if ( esp8266.available())   
           {
                Serial.write( esp8266.read() );
           }

           
}

void ATCommands(String SSIDstring, String PASSstring)
{
  
  
          Serial.println("\r\n----- [ PUT ESP IN STATION MODE (CWMODE) ] -----");  
          sendData("AT+CWMODE=3\r\n", 1000, true); // Configureer de ESP in "station mode" (1=Station, 2=AP, 3=Station+AP).
         
          Serial.println("\r\n----- [ LOG IN ON WIFI (CWJAP) ] -----");
          sendData("AT+CWJAP=" + SSIDstring + "," + PASSstring + "\r\n", 5000, true); // Inloggen op de WiFi met wachtwoord.
         
          Serial.println("\r\n----- [ DUMMY RULE TO CATCH THE ERROR ] -----");
          sendData("AT+CIPSTATUS\r\n", 1000, true); // Alles wat na de bovenste regel komt geeft "ERROR", vandaar deze dummy regel!
         
          Serial.println("\r\n----- [ PUT MULTIPLEX MODE ON MULTIPLE CONNECTIONS (CIPMUX) ] -----");
          // Zet multiplex in "multiple mode, zo kan de server meerdere verbindingen accepteren, dit is nodig om de server te starten.
          sendData("AT+CIPMUX=1\r\n", 1000, true);
         
          Serial.println("\r\n----- [ STARTING SERVER (CIPSERVER) ] -----"); 
          sendData("AT+CIPSERVER=1,80\r\n", 1000, true); // Zet de server actief op poort 80.
          
          Serial.println("\r\n----- [IP ADRESS] -----");
          sendData("AT+CIFSR\r\n", 1000, true); // Geef het verkregen IP adres weer.


}


void UDP_mode(String SSIDstring, String PASSstring)
{
           sendData("AT+CWMODE=3\r\n", 1000, true);                                    // softAP+station mode
           sendData("AT+CWJAP=" + SSIDstring + "," + PASSstring + "\r\n", 3000, true); // SSID and password of router      
           sendData("AT+CIFSR\r\n", 2000, true);                                       // which IP? it should give us the IP but we never get it
           sendData("AT+CIFSR\r\n", 2000, true);                                       // which IP? it should give us the IP but we never get it
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
//                     while (esp8266.available()>0)
//                     {
//                            c= esp8266.read();
//                            buffer+=c;
//                               
//                     }
//                     Serial.print(buffer); 
//
////                     String ch_esp;
////                     ch_esp = esp8266.readString();
////                     ch_esp.trim();
////                      
////                      if(buffer=="off"){
////                        // here some logic
////                        timeout=2000;
////                      }

                       
               }
            
               // we generate toy data
               val = val+1;
               if(val == 145){val = -145;}
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



      

               if(Serial.available())
               {
                      delay(100);
                      String ch;
                      ch = Serial.readString();
                      ch.trim();
                      
                      if(ch=="off"||ch=="OFF"){
                        // we stop data flow
                         sendData("+++", 1500, true); // disable UART-WIFI
                         sendData("AT+CIPMODE=0", 1500, true); // disable UART-WIFI
                         sendData("AT+CIPCLOSE", 1500, true);  // Delete UDP transmission
                         flag_udp = false;
                      }
               }
          
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
