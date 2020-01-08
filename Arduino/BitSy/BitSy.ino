/*
 * MRI SCAN TRIGGER using Arduino BITSI code and LCD display
 * by Erik van den Boogert 
 *
 * $Id: mriscanV20110804.pde 04 2011-08-01 e.vandenboogert@donders.ru.nl $
 * $Id: mriscanV20120801.ino 04 2012-08-01 u.plones@donders.ru.nl $
 * $Id: mriscanV20121114.ino 04 2012-11-14 
 * $Id: mriscanV20130320.ino 04 2013-03-20 u.plones@donders.ru.nl $
 * $Id: mriscanV20190117.ino 04 2019-01-17 u.plones@donders.ru.nl $
 *
 * Changelog:
 * 2012-11-01 - Added reset button
 * 2012-14-14 - Rewrote the program for use with PinChangeInt library (input interrupt detection).
 *            - used IsTime function to handle debouncing
 *            - Changed display lay-out to lay-out as explained below.
 * 2013-03-20 - original BITSI signal handling (date 2012-11-01) because previous version had timing issues.
 * 2019-01-17 - Added level mode. Pressing button down as DivCount is 0 will enter level mode. LM will show in the display.
 *
 **  LCD Display layout explained:
 **  TriggerInCount   DivCount   TriggerOutCount
 ** 
 **  LCD Display when in level Mode:
 **  TriggerInCount   LM    TriggerOutCount
 **
 **  SyncCount:       The number of triggers to receive before an output trigger is send
 **  DivCount:        Sets the divide-by-n counter
 **  TriggerOutCount: Displays the given number of output triggers 
 **  LM:              LevelMode
 **
 **
 */

#include <LiquidCrystal.h>
 
#define BNC_MRI_TRIGGER 10
#define OPT_MRI_TRIGGER 11
#define BTN_TRIGGER 12
#define BTN_DOWN 14
#define BTN_UP 15
#define BTN_RESET 16
#define SPARE_1 17
#define SPARE_2 18
 
#define TIMECTL_MAXTICKS  4294967295L
#define TIMECTL_INIT      0
      
// the macro sets or clears the appropriate bit in port D if the pin is less than 8 or port B if between 8 and 13
#define fastWrite(_pin_, _state_) ( _pin_ < 8 ? (_state_ ?  PORTD |= 1 << _pin_ : PORTD &= ~(1 << _pin_ )) : (_state_ ?  PORTB |= 1 << (_pin_ -8) : PORTB &= ~(1 << (_pin_ -8)  )))


unsigned long flashTimeMark=0;  //a millisecond time stamp used by the IsTime() function. initialize to 0
unsigned long int flashTimeInterval=1000;  //How many milliseconds we want for the flash cycle. 1000mS is 1 second.

unsigned long TimeoutPulseLength = 30;  /* Output port pulseLength in ms     */
unsigned long TimeoutDebounce    = 8;   /* Debounce interval in ms           */
unsigned long TimeoutPacingLED   = 500; /* Onboard Pacing LED interval in ms */
unsigned long LevelModeStartTime = 0;   //
unsigned long MaxLevelModeTimeOn = 500; // maximum allowed time on in level mode in ms

/* Reserved hardware wiring for enabling/disabling the HCT244 input buffer to I[8] */
int pinEnableBufIn = 13;

/* Reserved hardware wiring for forcing 27KOhm pull-up / pull-down to I[8] */
int pinPullUpDown  = 19;

/* Reserved hardware wiring for TTL MRI Sync Output to D2 */
int pinTTLOut  = 2;

/* There are 8 associated input bits D10=pin10, D11=pin11, D12=pin12
 * A0=pin14/AI0, A1=pin15/AI1 ,A2=pin16/AI2, A3=pin17/AI3, A4=pin18/AI3 */
int I[8] = {10, 11, 12, 14, 15, 16, 17, 18};

/* declare 8 debouncing varables for each input bit.
 * One should remember the time moment when the edge was detected and set a boolean Debouncing_I[n] */
unsigned long TimeOnSet_I[8]  = {0, 0, 0, 0, 0, 0, 0, 0};
boolean       Debouncing_I[8] = {false, false, false, false, false, false, false, false};

/* declare bit state memory booleans to find out if input values have changed since the last looptest */
boolean State_I[8]      = {LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW};
boolean Prev_State_I[8] = {HIGH, HIGH,  HIGH, HIGH, HIGH, HIGH,  HIGH, HIGH};

//int I[8] = {BNC_MRI_TRIGGER, OPT_MRI_TRIGGER, BTN_TRIGGER, BTN_DOWN, BTN_UP, BTN_RESET, SPARE_1, SPARE_2};

//serial buffer
byte SerialInChr;

unsigned long TimeNow = 0;         // start time variable
unsigned long TimeOnsetOut = 0;    // 
boolean       Parallel_Out_Active = false;

/* declare 8 debouncing variables for each input bit.
 * One should remember the time moment when the edge was detected and set a boolean Debouncing_I[n] */
unsigned long IntervalStartTime[7]  = {0};
boolean       DebounceTimePassed[7] = {false};
boolean       LevelMode = false, LevelModeState = LOW;

// declare a default divide by n counter and initialize the SyncCount to 1, supporting 3 modes
  //   a) default mode: every MRI Sync trigger will be forwarded as TTL output
  //   b) single shot mode: only the first MRI Sync trigger will cause a TTL output
  //   c) divide by n mode: first count down from n downto 1 before generating a TTL output   
unsigned DivCount = 1;
unsigned SyncCount = 1;
unsigned TriggerInCount = 0;  //scanner input trigger counter 
unsigned TriggerOutCount = 0;  //output pulse counter
unsigned LMTriggerInCount = 0;
unsigned LMTriggerOutCount = 0;

LiquidCrystal lcd(3, 4, 5, 6, 7, 8, 9); // LiquidCrystal(rs, rw, enable, d4, d5, d6, d7) 
char displaystring[16];


//Function prototype
void LCDPrintDefaultMode(void);
void ButtonDown(void);
void ButtonUp(void);
void ButtonReset(void);
int IsTime(unsigned long, unsigned long);
void ConfigureInputMode(void);
void OutPortWrite(byte);
void LCDUpdate(unsigned&, unsigned, unsigned&);
void LM_LCDUpdate(unsigned&, unsigned&);



/// <-----> interrupts <-----> \\\

const byte interruptPin = 2;
volatile byte state = LOW;
volatile int cnt = 0;

void OptoTriger();

/// <-----> end <-----> \\\


void setup()
{
   

    //if there is a state change at the interruptPin 2 we will interrupt the system
    attachInterrupt(digitalPinToInterrupt(interruptPin), OptoTriger, RISING); //CHANGE RISING
  
    // initialize standard BITSI input bits
    ConfigureInputMode();
  
    // initialize serial port (enabling BITSI alike communication via COM-port)
    Serial.begin(115200);
 
    // enable input buffer
    pinMode(pinEnableBufIn, OUTPUT);
    digitalWrite(pinEnableBufIn, LOW);

    // enable pullup resistors
    pinMode(pinPullUpDown, OUTPUT);
    digitalWrite(pinPullUpDown, LOW);
  
    // initialize TTLOutput
    pinMode(pinTTLOut, OUTPUT);
    digitalWrite(pinTTLOut, LOW);

    //initialize lcd 
    lcd.begin(16,2);
    lcd.clear();
    lcd.print("MRIST 20190117");
    delay(1000);
    lcd.clear();
  
    //lcd.print("Default mode    ");
    LCDPrintDefaultMode();
 
    // show program name and version number in the console
    Serial.println("MRI Scan Trigger $Revision: 20130320, Ready!"); 
}

void loop() {
    byte index = 0;

    /* Get TimeNow as a reference for all Timeout counters for debouncing inputs and output pulseLength */
    TimeNow = millis();

    /* Process incoming serial characters ***************************************************************
     * The output bits are set immediately to reflect the value of the incoming serial character.
     * After [TimeoutPulseLength] miliseconds the output port is reset to 0.
     */

    // check if data has been sent from the computer 
    if (Serial.available() & !LevelMode) {
        //--- read the most recent byte
        SerialInChr = Serial.read();

        OutPortWrite(SerialInChr);
        /* store the TimeOnSet moment as a reference timestamp for the desired fixed pulseLength */
//        TRInterval = TimeNow - TimeOnsetOut;
        TimeOnsetOut = TimeNow;
        /* Set the Active flag, which enables the pulseLength timeout and returns the outputs to 0
         * after the timeout */
        Parallel_Out_Active = true;
    }
    else if (Parallel_Out_Active & ((TimeNow - TimeOnsetOut) > TimeoutPulseLength)) {
        /* return output bits to zero and reset Active flag */
        OutPortWrite(0);
        Parallel_Out_Active = false;
    }
	//reset output after 500ms in levelmodestate 
	if(LevelModeState & (TimeNow - LevelModeStartTime >= MaxLevelModeTimeOn)) {
	    OutPortWrite(0);
		LevelModeState == LOW;
	}
    
    /* Process input bits *******************************************************************************
     * The input bits are monitored for state changes. If bit 0 goes from low to high, a capital 'A' character
     * is sent back to the PC over the serial line.
     * When it changes back from high to low, a lowercase 'a' character is sent to the PC.
     * For bits 0 to 7, the characters A-H and a-h are sent respectively.
     *
     * It is possible to connect mechanical switches to each of the inputs, because the input bits are debounced.
     * After a bit's state change, it will be ignored for a debouncing interval of [TimeoutDebounce] miliseconds.
     */

    // handle trigger bits

	/* loop over the bits, to check their states */
    for (index = 0; index < 8; index = index + 1) {
        State_I[index] = digitalRead(I[index]);
  
        /* check for bit state change = egde, but not within debouncing interval */
        if ((Prev_State_I[index] != State_I[index]) & !Debouncing_I[index]) {
            /* respond with the corresponding character */
            if (State_I[index] == HIGH) {
                Serial.print(char(97 + index));
        
                // Here add code exceptional for the standard BITSI; I[0], I[1] and I[2] act as an OR port for MRI Sync pulse triggers
                //   so if one of these inputs is detected high at this point, the TTL Output shall be activated, just like it was activated
                //   from a received character from the host PC. (The latter feature by the way is an additional feature, which comes for free
                //   when maintaining maximum code compatibility with the original BITSI code. This feature may be used to send a test
                //   trigger initiated from the host/Presentation PC).
                if ((State_I[0] != 0) | (State_I[1] != 0) | (State_I[2] != 0)) {
				    if(LevelMode) {
					    if (LevelModeState == LOW) {
					        LevelModeStartTime = TimeNow;
						    LevelModeState = HIGH;
					        OutPortWrite(B00000001); //set trigger out
							LMTriggerOutCount++;
						} else {
						    OutPortWrite(0); //reset trigger out
							LevelModeState = LOW;
						}
						LMTriggerInCount++;
					} else {
                        // Only set the TTL output if SyncCount is 1, otherwise discriminate between 
                        //   a) default mode: every MRI Sync trigger will be forwarded as TTL output
                        //   b) single shot mode: only the first MRI Sync trigger will cause a TTL output
                        //   c) divide by n mode: first count down from n downto 1 before generating a TTL output   
                        if (SyncCount == 1 ) {   
                            OutPortWrite(B00000001);
                            /* store the TimeOnSet moment as a reference timestamp for the desired fixed pulseLength */
 //                           TRInterval = TimeNow - TimeOnsetOut;
                            TimeOnsetOut = TimeNow;
						    TriggerOutCount++;
                            /* Set the Active flag, which enables the pulseLength timeout and returns the outputs to 0
                            * after the timeout */
                            Parallel_Out_Active = true; 
                            //
                            // check single shot mode: disable next triggers by setting SyncCount = 0; 
                            if (DivCount == 0) { SyncCount = 0; } 
                            // check divide by n mode, recount loop
                            if (DivCount > 1) { SyncCount = DivCount +1; }   
                        }
            
                        // check divide-by-n mode, decrement(SyncCount)
                        if (SyncCount > 1) { 
					        SyncCount = SyncCount - 1; 	
					    } 
					    TriggerInCount++;
					}
				}
                
                // Check for Button(down)
				if (State_I[3] != 0) { ButtonDown(); }
								
                // Check for Button(up) 
				if (State_I[4] != 0) { ButtonUp(); }
				
	            //Check for Button (reset) 
				if( State_I[5] != 0 ) { 
				    ButtonReset(); 
				    LevelMode = false;	
			    }
		
                if(LevelMode) {
                    //LCDPrintLevelMode();
					LM_LCDUpdate(LMTriggerInCount, LMTriggerOutCount);
                } else {		
			        // Finally update the LCD display:
		            LCDUpdate(TriggerInCount, DivCount, TriggerOutCount);
				}
            }
            else { Serial.print(char(65 + index)); 
			}

            /* start debouncing */
            TimeOnSet_I[index] = millis();
            Debouncing_I[index] = true;

            /* save new previous bit state */
            Prev_State_I[index] = State_I[index];
        }  
    }

    /* reset debouncing status for each bit if the debounce interval has elapsed */
    for (index = 0; index < 8; index = index + 1) {
        if (Debouncing_I[index] & ((TimeNow - TimeOnSet_I[index]) > TimeoutDebounce)) {
            Debouncing_I[index] = false;
        }
    }
    
} //end loop()

//--- General methods --------------------------------

void LCDPrintDefaultMode(void) {
    lcd.print(" #IN  Div  #OUT ");
    lcd.setCursor(0,1);
  
    //lcd.print(" 1  1 STOP     0");
    lcd.print("   1    1     0 ");
}

void LCDPrintLevelMode(void) {
    lcd.setCursor(0,1);
	lcd.print("   1   LM     0 ");
}

// Decrement DivCount 
void ButtonDown(void) {
    if (DivCount >= 0) {   
        if (DivCount > 0) {
	        DivCount --; 
            SyncCount = DivCount +1;
	    } else if (DivCount == 0) {
	        SyncCount = 1;
			DivCount = 0;
			LevelMode = true;
	    }
	}
}

// Increment DivCount set SynCount to 1
void ButtonUp(void) {
    if(DivCount == 0 & LevelMode == true) {
	    ButtonReset();
	} else if(DivCount < 99) {			
        DivCount++;
        SyncCount = 1;
	}
}

// Reset Display values
void ButtonReset(void) {
    SyncCount = 1;
	DivCount = 1;
	TriggerOutCount = 0;
	TriggerInCount = 0;
	LMTriggerInCount = 0;
	LMTriggerOutCount = 0;
	LevelModeState == LOW;
	LevelMode = false;
	OutPortWrite(0);
}

int IsTime(unsigned long *timeMark, unsigned long timeInterval){
    unsigned long timeCurrent;
    unsigned long timeElapsed;
    int result=false;
  
    timeCurrent=millis();
    if(timeCurrent<*timeMark) {  //Rollover detected
        timeElapsed=(TIMECTL_MAXTICKS-*timeMark)+timeCurrent;  //elapsed=all the ticks to overflow + all the ticks since overflow
    }
    else {
        timeElapsed=timeCurrent-*timeMark;  
    }

    if(timeElapsed>=timeInterval) {
        *timeMark=timeCurrent;
        result=true;
    }
    return(result);     
}

void ConfigureInputMode(void) 
{
  // configure all the pins of the input port as inputs
  pinMode(BNC_MRI_TRIGGER, INPUT);  
  pinMode(OPT_MRI_TRIGGER, INPUT);
  pinMode(BTN_TRIGGER, INPUT);
  pinMode(BTN_DOWN, INPUT);
  pinMode(BTN_UP, INPUT);
  pinMode(BTN_RESET, INPUT);
//  pinMode(SPARE_1, INPUT);
//  pinMode(SPARE_2, INPUT);

  // enable/disable internal pullup
  digitalWrite(BNC_MRI_TRIGGER, HIGH);
  digitalWrite(OPT_MRI_TRIGGER, HIGH);
  digitalWrite(BTN_TRIGGER, HIGH);
  digitalWrite(BTN_DOWN, HIGH);
  digitalWrite(BTN_UP, HIGH);
  digitalWrite(BTN_RESET, HIGH);
//  digitalWrite(SPARE_1, HIGH);
//  digitalWrite(SPARE_2, HIGH);
} 


void OutPortWrite(byte code)
{
  if ((code & B00000001) > 0)
  { digitalWrite(pinTTLOut, HIGH); } 
  else
  { digitalWrite(pinTTLOut, LOW); }
}


/** Function: Updates two row 16 character LCD Display
 *            First row displays the headers and remains static. 
 *			  2nd row displays the argument counts
 *			  all counters rollover			  
 *  arguments: TrigInc: Incoming trigger pulses
 *             DivC:    Devide by n counter
 *             TRC:     Trigger out count  */
void LCDUpdate(unsigned &TrigInC, unsigned DivC, unsigned &TRC) {
    lcd.setCursor(0, 1);      //setCursor(col, row) 
    if ((TrigInC > 0) && (TrigInC < 10000)) {
        sprintf(displaystring, "%4i", TrigInC); 
    } else { 
	    //sprintf(displaystring, "-----"); 
          TrigInC = 0;
          sprintf(displaystring, "%4i", TrigInC);
    }
    lcd.print(displaystring);
    
    lcd.setCursor(7, 1);
    if ((DivC >= 0) && (DivC < 100)) {
        sprintf(displaystring, "%2i", DivC); 
    } else { 
	    sprintf(displaystring, "--"); 
    }
    lcd.print(displaystring);
    
    lcd.setCursor(11, 1);    
    if ((TRC >= 0) && (TRC < 10000)) {
        sprintf(displaystring, "%4i", TRC); 
    } else { 
	//sprintf(displaystring, "-----"); 
        TRC= 0;
    }
    lcd.print(displaystring);
}
//Copied from the above function for a quick fix
//Function used for updating the level mode display
/** Function: Updates two row 16 character LCD Display
 *            First row displays the headers and remains static. 
 *			  2nd row displays the argument counts
 *			  all counters rollover			  
 *  arguments: TrigInc: Incoming trigger pulses
 *             DivC:    Devide by n counter
 *             TRC:     Trigger out count  */
void LM_LCDUpdate(unsigned &TrigInC, unsigned &TRC) {
    lcd.setCursor(0, 1);      //setCursor(col, row) 
    if ((TrigInC > 0) && (TrigInC < 10000)) {
        sprintf(displaystring, "%4i", TrigInC); 
    } else { 
	    //sprintf(displaystring, "-----"); 
          TrigInC = 0;
          sprintf(displaystring, "%4i", TrigInC);
    }
    lcd.print(displaystring);
    
    lcd.setCursor(7, 1);    //One position to the left in comparison to the above function
    sprintf(displaystring, "LM"); 
    lcd.print(displaystring);
    
    lcd.setCursor(11, 1);    
    if ((TRC >= 0) && (TRC < 10000)) {
        sprintf(displaystring, "%4i", TRC); 
    } else { 
	//sprintf(displaystring, "-----"); 
        TRC= 0;
    }
    lcd.print(displaystring);
}


/*This recipe has been cooked by Jose Garcia-Uceda*/
void OptoTriger()
{
       state = !state; 
       if (state)
       {
          fastWrite(13, HIGH);         // set Pin high  SINE ON  during 500 ms         
       }
       if (!state)
       {
          fastWrite(13, LOW);         //  set Pin low   SINE OFF during 500 ms
       }
}








