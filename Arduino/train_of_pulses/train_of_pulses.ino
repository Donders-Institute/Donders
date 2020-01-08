/* This has been cooked by Jose Garcia-Uceda*/

// the macro sets or clears the appropriate bit in port D if the pin is less than 8 or port B if between 8 and 13
#define fastWrite(_pin_, _state_) ( _pin_ < 8 ? (_state_ ?  PORTD |= 1 << _pin_ : PORTD &= ~(1 << _pin_ )) : (_state_ ?  PORTB |= 1 << (_pin_ -8) : PORTB &= ~(1 << (_pin_ -8)  )))

// declarations 
const float pi = 3.14;

//functions
void Pulse_micro_mili(double on, double off);

void setup()
{    
      //here our train of pulses
      pinMode(12, OUTPUT);
      pinMode(9, OUTPUT);  
}


boolean flag_pass = true;

int i = 0;
void loop()
{
      Pulse_micro_mili(10, 300); // train: 10 microsecond up 500 ms down                     
}

// we generate a train of pulses
void Pulse_micro_mili(double on, double off)
{
      fastWrite(12, HIGH);         // set Pin high
      delayMicroseconds(on);       // waits "on" microseconds
      fastWrite(12, LOW);          // set pin low
      delay(off);                  // wait "off" mili
}

// wave generator sine using PWM
void wave_generator(int deg)
{
    // degrees = (360/256) * divisions_number;
    // 360 (deg) / 256 (possible values) = 1.4 (deg) Step  resolution
    // deg = step *(360/256);
    // step = deg* (256/360);

    float v_out = 2.5+2.5*sin(deg*(pi/180));  
    
    //we know: duty_cycle(%) = (Ton/T)*100; and duty_cycle(%) = (Vout/5v)*100;
    //so we can calculate easily t_on and t_off
    float t_on  = ((v_out*0.0001)/5)*1000000;
    float t_off = (0.001*100000)-t_on;

    Serial.println(t_on);

    fastWrite(9, HIGH);          
    delayMicroseconds(t_on);      
    fastWrite(9, LOW);          
    delayMicroseconds(t_off);      
}
