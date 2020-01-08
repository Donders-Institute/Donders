/* This has been cooked by Jose Garcia-Uceda*/

#include <SPI.h>

// the macro sets or clears the appropriate bit in port D if the pin is less than 8 or port B if between 8 and 13
#define fastWrite(_pin_, _state_) ( _pin_ < 8 ? (_state_ ?  PORTD |= 1 << _pin_ : PORTD &= ~(1 << _pin_ )) : (_state_ ?  PORTB |= 1 << (_pin_ -8) : PORTB &= ~(1 << (_pin_ -8)  )))

// declarations 
const float pi = 3.14;
const float v_max = 5;

void setup() {
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

    int(value) = (v_out/v_max)*256; 
    //Serial.println(value);

    
    //we know: duty_cycle(%) = (Ton/T)*100; and duty_cycle(%) = (Vout/5v)*100;
    //so we can calculate easily t_on and t_off
    float t_on  = ((v_out*0.0001)/v_max)*1000000;
    float t_off = (0.001*100000)-t_on;
  
    Serial.println(t_on);

    fastWrite(12, HIGH);          
    delayMicroseconds(t_on);      
    fastWrite(12, LOW);          
    delayMicroseconds(t_off);      
}
