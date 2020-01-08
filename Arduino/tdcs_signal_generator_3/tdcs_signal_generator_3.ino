/* This has been cooked by Jose Garcia-Uceda*/

/*
AD9833 Waveform Module 

When a 1Hz signal is adjusted to produce a 1V output signal, then the following trimpot settings will
produve a 1V signal while increasing the frequency to 10Hz in 1Hz steps:
1Hz - 1V @ 255
2Hz - 1V @ 210
3Hz - 1V @ 200
4Hz - 1V @ 200
5Hz - 1V @ 198
6Hz - 1V @ 196
7Hz - 1V @ 196
8Hz - 1V @ 196
9Hz - 1V @ 196
10Hz - 1V @ 196
*/

#include <SPI.h>

// the macro sets or clears the appropriate bit in port D if the pin is less than 8 or port B if between 8 and 13
#define fastWrite(_pin_, _state_) ( _pin_ < 8 ? (_state_ ?  PORTD |= 1 << _pin_ : PORTD &= ~(1 << _pin_ )) : (_state_ ?  PORTB |= 1 << (_pin_ -8) : PORTB &= ~(1 << (_pin_ -8)  )))


#define RESET_CMD			0x0100		// Reset enabled (also CMD RESET)
/*		Sleep mode
 * D7	1 = internal clock is disabled
 * D6	1 = put DAC to sleep
 */
#define SLEEP_MODE			0x00C0		// Both DAC and Internal Clock
#define DISABLE_DAC			0x0040
#define DISABLE_INT_CLK		0x0080

#define PHASE_WRITE_CMD		0xC000		// Setup for Phase write
#define PHASE1_WRITE_REG	0x2000		// Which phase register
#define FREQ0_WRITE_REG		0x4000		// 
#define FREQ1_WRITE_REG		0x8000
#define PHASE1_OUTPUT_REG	0x0400		// Output is based off REG0/REG1
#define FREQ1_OUTPUT_REG	0x0800		// ditto


// declarations 
const byte ledPin = 13;
const byte interruptPin = 2;
const float pi = 3.14;

volatile byte state = LOW;

// pwm pins 3, 5, 6, 10 or 11
int LED_pin = 11;
int step = 0; // 0=< y_sin < 256

// counters
volatile int cnt_T = 0;         //time
volatile int cnt_H = 0;         //HIGH
volatile int cnt_L = 0;         //LOW
volatile int cnt_time = 0;
volatile int cnt_serial = 0;
volatile int cnt_sine_off = 0;
volatile int cnt_sine_on  = 0;

// flags
volatile boolean flag_sine = false;

const int RESET_INI = 0x0100;            //coplete word, reset = 1

const int RESET = 0x2100;            //coplete word, reset = 1
const int ENABLE = 0x2000;           //complete word, reset = 0
const int OUTPUT_SWITCH_OFF = 0X2022;


const int SINE_REG_0 = 0x2000;             // Define AD9833's waveform register value.
const int SINE_REG_1 = 0x2800;             // Define AD9833's waveform register value.
const int SQUARE = 0x2028;
const int TRIANGLE = 0x2002;
const int HALFSQUARE = 0x2020;

const int PHASEWRITE = 0xC000;
const float BITS_PER_DEG = 11.3777777777778;  //4096 / 360

const int16_t initFreq = 4;         //initial frequency = 4Hz
 
int32_t refFreq = 25000000;         // On-board crystal reference frequency
const int FSYNC = 10;               // Standard SPI pins for the AD9833 waveform generator.
const int CLK = 13;                 // CLK for signal generator (green) and pin 2 MCP4251 digipot
const int DATA = 11;                //MOSI: 5V->3V->Yellow->sdata signal generator
                                    //MOSI: SDI pin3 MC4251

const int CSPot = 7;                //Chip select MCP4251 digipot
const int SHUTDOWN_POT = 6;         //Shutdown digipot. Should be high
//const int secondAmpWriteAddr = B00000000;  //wiper0writeAddr
const int firstAmpWriteAddr = B00010000;  //wiper1writeAddr

//flags
boolean flag_pass   = true;
boolean flag_serial = false;
boolean flag_test   = false;
boolean flag_AD9833 = true;

//buffers
float x[101];
float stats[10];


void setup() 
{   
      // set the timer0 2kHz interrupt
      // the timer0 has to be comment otherwise the AD9833 is not working properly and is intruducing a pulse.
      //set_timer0();         
 
      // Input commands via serial channel 
      software_control_ini();
      
      // AD9833 init
      AD9833_init();

      //if there is a state change at the interruptPin 2 we will interrupt the system
      attachInterrupt(digitalPinToInterrupt(interruptPin), OptoTriger, RISING); //CHANGE RISING
 }

// main 
void loop() 
{
      // our tasks  
      scheduler();
}

void config_generator(float  freq, float phase, int16_t wave, int16_t enable)
{
         // reset
         int16_t reset = RESET;
         
         float aux = freq;

         // frequency   
         int32_t FreqWord = (freq * 268435456L) / (float)refFreq;
            
         int16_t MSB = (int16_t)((FreqWord & 0xFFFC000) >> 14);    //Only lower 14 bits are used for data
         int16_t LSB = (int16_t)(FreqWord & 0x3FFF);
            

         LSB |= 0x4000;  //Set control bits 15 ande 14 to 0 and 1, respectively, for frequency register 0
         MSB |= 0x4000;
         

         // phase
         phase = fmod(phase, 360);
         if (phase < 0) phase += 360;
      
         //Phase is in float degrees (0.0 - 360.0)
         //Convert to a number 0 - 4096 respectively, by masking
         uint16_t phaseVal = (uint16_t)(BITS_PER_DEG * phase) & 0x0FFF; //convert to propper register value
      
         phaseVal = phaseVal | PHASEWRITE;   //add phase register 0 to it

         digitalWrite(FSYNC, LOW);            // Start comunication - Set FSYNC low before writing to AD9833 registers
         
         // delayMicroseconds(5);               // Give AD9833 time to get ready to receive data.

         SPI.transfer(highByte(0x2000));       // reset and SINE
         SPI.transfer(lowByte(0x2000)); 

         SPI.transfer(highByte(phaseVal));    // phase  
         SPI.transfer(lowByte(phaseVal)); 
  
         SPI.transfer(highByte(LSB));         // frequency setting
         SPI.transfer(lowByte(LSB));    

         SPI.transfer(highByte(MSB));        
         SPI.transfer(lowByte(MSB));     
 
         // SPI.transfer(highByte(wave));        // wave type
         // SPI.transfer(lowByte(wave));
        
      //    SPI.transfer(highByte(enable));      // output OK 
      //    SPI.transfer(lowByte(enable));  
        
         digitalWrite(FSYNC, HIGH);          // End sending data - Write done. Set FSYNC high
}

// Set the frequency 
int setFrequency(float frequency) 
{
      //int32_t FreqWord = (frequency * pow(2, 28)) / (float)refFreq; 
      int32_t FreqWord = (frequency * 268435456L) / (float)refFreq;
      
      int16_t MSB = (int16_t)((FreqWord & 0xFFFC000) >> 14);    //Only lower 14 bits are used for data
      int16_t LSB = (int16_t)(FreqWord & 0x3FFF);
      
      //Set control bits 15 ande 14 to 0 and 1, respectively, for frequency register 0
      LSB |= 0x4000;
      MSB |= 0x4000;
      
      WriteSigGenRegister(RESET);               // write complete word, reset = 1
      WriteSigGenRegister(LSB);                 // Phase register
      WriteSigGenRegister(MSB);                 // no phase shift
      WriteSigGenRegister(ENABLE); 
      return 0;
}

int setWaveform(int waveform) 
{
      WriteSigGenRegister(RESET);               //write complete word, reset = 1
      WriteSigGenRegister(waveform);            // 
      return 0;
}

int setPhase(float phaseInDeg) 
{
      phaseInDeg = fmod(phaseInDeg, 360);
      if (phaseInDeg < 0) phaseInDeg += 360;
      
      //Phase is in float degrees (0.0 - 360.0)
      //Convert to a number 0 - 4096 respectively, by masking
      uint16_t phaseVal = (uint16_t)(BITS_PER_DEG * phaseInDeg) & 0x0FFF; //convert to propper register value
      
      phaseVal = phaseVal | PHASEWRITE;   //add phase register 0 to it
      WriteSigGenRegister(phaseVal);
      return 0;
}

int WriteSigGenRegister(int16_t dat) 
{  
      
      digitalWrite(FSYNC, LOW);             // Set FSYNC low before writing to AD9833 registers
      delayMicroseconds(10);              // Give AD9833 time to get ready to receive data.
      
      SPI.transfer(highByte(dat));        // Each AD9833 register is 32 bits wide and each 16
      SPI.transfer(lowByte(dat));         // bits has to be transferred as 2 x 8-bit bytes.

      digitalWrite(FSYNC, HIGH);          //Write done. Set FSYNC high
      //SPI.endTransaction();
      
      return 0;
}

// AD9833 init
 void AD9833_init()
 {
      pinMode(FSYNC, OUTPUT);             //define FSYNC as output pin (for AD9833)
      digitalWrite(FSYNC,HIGH);           //set FSYNC high
      
      SPI.begin();                        //initialize SPI
      delay(100);
      
      SPI.setDataMode(SPI_MODE2);
      delayMicroseconds(10);  


      // SPI 
      digitalWrite(FSYNC, LOW);            // Start comunication - Set FSYNC low before writing to AD9833 registers   
      delayMicroseconds(10);               // Give AD9833 time to get ready to receive data.
      
      SPI.transfer(highByte(0x100));       // reset - recommended  
      SPI.transfer(lowByte(0x100));

      digitalWrite(FSYNC, HIGH);          // End sending data - Write done. Set FSYNC high
 }


// ISR init
void init_interrupts()
{
      //if there is a state change at the interruptPin 2 we will interrupt the system
      attachInterrupt(digitalPinToInterrupt(interruptPin), OptoTriger, RISING); //CHANGE RISING
}

// ISR service
void OptoTriger()
{
      flag_sine = !flag_sine;
}

// protection
void protection()
{
     if( (flag_sine == true) && (cnt_T >= 500) ) //500 ms
     { 
        flag_sine = 0;
        cnt_T = 0;
     }
}

// set timer0 interrupt at 2kHz
// source: https://jaimedearcos.github.io/arduino/2017/01/04/Timers/
void set_timer0()
{        
      //set pins as outputs
      pinMode(8, OUTPUT);  

      cli();//stop interrupts

      //set timer0 interrupt at 2kHz
      TCCR0A = 0;// set entire TCCR0A register to 0
      TCCR0B = 0;// same for TCCR0B
      TCNT0  = 0;//initialize counter value to 0
      // set compare match register for 2khz increments
      OCR0A = 124;// = (16*10^6) / (2000*64) - 1 (must be <256)
      // turn on CTC mode
      TCCR0A |= (1 << WGM01);
      // Set CS01 and CS00 bits for 64 prescaler
      TCCR0B |= (1 << CS01) | (1 << CS00);   
      // enable timer compare interrupt
      TIMSK0 |= (1 << OCIE0A);
      
      sei();//allow interrupts
}

//timer0 interrupt 2kHz toggles pin 8
boolean toggle0 = 0;
ISR(TIMER0_COMPA_vect)
{
      //generates pulse wave of frequency 2kHz/2 = 1kHz (takes two cycles for full wave- toggle high then toggle low)
      cnt_T = cnt_T +1;

      //generic counter
      cnt_time = cnt_time +1;
      if(cnt_time == 2000){cnt_time = 0;} // every second we clean the counter

      //serial counter
      cnt_serial = cnt_serial +1;
      if(cnt_serial == 200){cnt_serial = 0; flag_serial = true;} // every second we clean the counter
}

//serial comunication
void software_control()
{
    if(Serial.available()>0)
    {
          int inByte = Serial.read();
          //do something
        
          //Serial.write(" Hey man ");
    }

}

void software_control_ini()
{
       Serial.begin(9600);
}

// AD9833 testing
void AD9833_test()
{
            setPhase(0); 
            setFrequency(31400);
            setWaveform(SINE_REG_0);   
            WriteSigGenRegister(ENABLE);
      
            delay(10000);
            setFrequency(0);
            setWaveform(SINE_REG_0);   
            WriteSigGenRegister(OUTPUT_SWITCH_OFF);
            delay(10000);
}

// AD9833 set program
void AD9833_program()
{
            if (flag_sine && flag_pass)
            {
                  cli();//stop interrupts   
                        
                  config_generator(31400, 0, SINE_REG_0, ENABLE);

                  flag_pass = false;  
                  cnt_T = 0;

                  sei();//allow
            }
            if (!flag_sine && !flag_pass)
            {
                  cli();//stop interrupts  

                  config_generator(0, 0, SINE_REG_1, OUTPUT_SWITCH_OFF);

                  flag_pass = true;     
                  
                  sei();
            }

            // more than 600 ms running a sine, we cut off  
            if( (flag_sine == true) && (cnt_T >= 600) ) //1200*0.5= 600ms. timer0 freq 2kHz
            { 
                  cli();//stop interrupts   
                  
                  setFrequency(0);
                  WriteSigGenRegister(OUTPUT_SWITCH_OFF); 
                  
                  sei();

                  cnt_T = 0;
            }

}

void test()
{
    int i; 
    for(i=1; i<101;i++)
    {
       x[i]=i;
    }

    sd_mean(i);

}

void sd_mean(int total_samples)
{
            //we perform a copy   
            float sample[total_samples];
            for(int s=1; s<101;s++)
            {
               sample[s] =x[s];
            }

            //we calculate the mean
            float mean = sample[1];
            for(int j =2; j<(total_samples+1); j++)
            {
                  mean = mean + sample[j];
            }
            
            mean = mean/total_samples;

            //we get the sd
            float sd = (sample[1]-mean)* (sample[1]-mean);
            for(int j =2; j<(total_samples+1); j++)
            {
                  sd = sd + (sample[j]-mean)* (sample[j]-mean);
            }
            
            sd = sqrt(sd/(total_samples-1));

            //we store our statistics 
            stats[1] = mean;
            stats[2] = sd;
            
            Serial.print("mean ");
            Serial.println(mean);

            Serial.print("sd ");
            Serial.println(sd);
}

void scheduler()
{      
    if(flag_serial){ software_control();flag_serial = false;} // we check if there is something every on the serial buffer every 100 ms
    if(flag_test){ AD9833_test();} 
    if(flag_AD9833){ AD9833_program();}

    //testing the statistics
    //if(cnt_time == 1500){ test();}
}
