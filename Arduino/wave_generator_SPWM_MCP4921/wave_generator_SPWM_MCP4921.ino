/* This has been cooked by Jose Garcia-Uceda*/
// OJO seems that is not working the sending part to the MCP421
#include <SPI.h>

// the macro sets or clears the appropriate bit in port D if the pin is less than 8 or port B if between 8 and 13
#define fastWrite(_pin_, _state_) ( _pin_ < 8 ? (_state_ ?  PORTD |= 1 << _pin_ : PORTD &= ~(1 << _pin_ )) : (_state_ ?  PORTB |= 1 << (_pin_ -8) : PORTB &= ~(1 << (_pin_ -8)  )))

// declarations 
const float pi = 3.14;
const float v_max = 5;
const int slaveSelectPin = 10;
int LDAC = 9;
const int initialValue = 12;

void setup() {

      // ini to the MCP421
      MCP4921_init();
      
      pinMode(12, OUTPUT);
      Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  for (int deg=0;deg<360;deg++){wave_generator(deg); }
}



void wave_generator(int deg)
{
    // degrees = (360/256) * divisions_number;
    // 360 (deg) / 256 (possible values) = 1.4 (deg) Step  resolution
    // deg = step *(360/256);
    // step = deg* (256/360);

    float v_out = 2.5+2.5*sin(deg*(pi/180));  

    int(value) = (v_out/v_max)*256; //4096
    Serial.println(value);
    
    //writes on the MCP4921 if you uncomment 
    digitalPortWrite(value,value);
    
    //we know: duty_cycle(%) = (Ton/T)*100; and duty_cycle(%) = (Vout/5v)*100;
    //so we can calculate easily t_on and t_off
    float t_on  = ((v_out*0.0001)/v_max)*1000000;
    float t_off = (0.001*100000)-t_on;
  
    //Serial.println(t_on);

    fastWrite(12, HIGH);          
    delayMicroseconds(t_on);      
    fastWrite(12, LOW);          
    delayMicroseconds(t_off);      
}


void MCP4921_init()
{
      pinMode(LDAC, OUTPUT); 
      pinMode(slaveSelectPin, OUTPUT); 

      digitalWrite(LDAC, HIGH);
      SPI.setDataMode(SPI_MODE2);
      delayMicroseconds(10);  
      SPI.begin();



      digitalPortWrite(highByte(initialValue), lowByte(initialValue));     
}

/*  Write two bytes to slave MCP4921 (12-bit DAC) through SPI
*/
void digitalPortWrite(byte high_byte, byte low_byte)
{
    byte data = high_byte;
    data = 0b00001111 & data;  //clear 4 bit command field
    data = 0b00110000 | data;   //0 = DACA, 0 = unbuffered, 1 = 1x, 1 = output ena
    //  Serial.print("data high:  ");
    //  Serial.println(data, BIN);
    digitalWrite(slaveSelectPin, LOW);
    
    SPI.transfer(data);
    SPI.transfer(low_byte);
    
    digitalWrite(slaveSelectPin, HIGH);
    
    digitalWrite(LDAC, LOW);
    delay(1);
    digitalWrite(LDAC, HIGH);
}
