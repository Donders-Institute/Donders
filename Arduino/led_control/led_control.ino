//Serial RGB led strip controller
//Author: Uriel Plones
//Date 2019-01-21
//Version: 0.0

#include <ParseSerial.h>

#define DEBUG 0           //enable/disable debug information

//pin definitions.  must be PWM-capable pins!
const int redPin = 9;
const int greenPin = 10;
const int bluePin = 11;

//maximum duty cycle to be used on each led for color balancing.  
//if "white" (R=255, G=255, B=255) doesn't look white, reduce the red, green, or blue max value.
const int max_red =   255;      //255;
const int max_green = 255;      //90;
const int max_blue =  255;      //100;

boolean up_down = 1; //declared for testFunction()

//byte colors[3] = {0, 0, 0}; //array to store led brightness values
const int defaultRGBValue = 100;
const int defaultSeqTime = 1000;
const int defaultPulses = 3;
int colors[3] = {defaultRGBValue, defaultRGBValue, defaultRGBValue};
int sequenceTime = defaultSeqTime, numberOfPulses = defaultPulses; //total blink time

int argcount = 0, spacePos1, spacePos2;
char c;
String S = "", firstString, secondString, thirdString;
ParseSerial parse;                 //create an object of class ParseSerial
const char* cpCommand = NULL;

unsigned long startTime = 0, currentMillis = 0;

void setup(){
    //set all three of our led pins to output
    pinMode(redPin, OUTPUT);
    pinMode(greenPin, OUTPUT);
    pinMode(bluePin, OUTPUT);
  
    //start the Serial connection
    Serial.begin(115200);
	Serial.println("Program: led_control.ino version 0.0 2019-01-21 by Uriel Plones @Donders Institute.");
	Serial.println("The program controls a LED light strip. All commands must be passed between an opening dollar sign ('$') and a closing percentage sign ('%').");
    Serial.println("Entering three integer values {0 - 255] control the brightness settings of the RGB LEDs."); 
	Serial.println("Entering two integer values will control the total blinking time and the number of blinks whitin that time."); 
	Serial.println("The default is 1000 milliseconds and 3 blinks.");
	Serial.println("The integer values can be seperated by space, comma or dash."); 
	Serial.println("Three seperate keywords can be used as stated below:");
	Serial.println("1. go: Start the blinking sequence");
	Serial.println("2. on: Turn the LED's on with predefined settings");
	Serial.println("3. clr: Switch off the LED's");
	Serial.println("4. rst: Reset to default values.");
	Serial.println("5. tst: Test function.");
}

void loop(){
    while( Serial.available() != 0 ) {  //check serial input buffer    
         
		c = Serial.read();   
		//if( DEBUG ) Serial.print( c );  //prints incoming characters
        argcount = parse.ParseString(c);
		//if( DEBUG ) Serial.println( argcount );
    } 
    
    cpCommand = parse.GetCommand();       //Command is char pointer
    S = String( cpCommand );              
    
	if (cpCommand > 0) {
	    if(DEBUG) Serial.println(S);
		if(DEBUG) {Serial.print("Argcount: "); Serial.println(argcount);}
		if (argcount == 1) {
		    if (S == "go"){
                Blink( sequenceTime, numberOfPulses);
			}
			if(S == "clr") {
			    clearLedStrip();
			}
			if(S == "on") {
			    write2LedStrip();
			}
			if(S == "tst") {
			    testFunction();
			}
			if(S == "rst") {
			    reset();
			}
		}
		if (argcount == 2) {
			setPulse();	
		}
	    if (argcount == 3) {
		    setColor();
	    }
    }
}

//Function: Read three arguments and set the RGB values accordingly
void setColor(void) {
    spacePos1 = S.indexOf(' ', 0);
    firstString = S.substring(0, spacePos1);
	colors[0] = firstString.toInt();
		
    spacePos2 = S.indexOf(' ', spacePos1 + 1);
	secondString = S.substring(spacePos1 + 1, spacePos2);
	colors[1] = secondString.toInt();
		
	thirdString = S.substring(spacePos2 + 1);
	colors[2] = thirdString.toInt();

    //write2LedStrip();
}
//Functon: Set pulse variables
//Read two arguments. First argument = sequence time in milli seconds
//2nd argument = number of pulses whitin the sequence time
void setPulse(void) {
    spacePos1 = S.indexOf(' ', 0);
    firstString = S.substring(0, spacePos1);
	sequenceTime = firstString.toInt();
	
	spacePos2 = S.indexOf(' ', spacePos1 + 1);
	secondString = S.substring(spacePos1 + 1, spacePos2);
	numberOfPulses = secondString.toInt();
}

//Function: Blink the led strip with the predefined settings
void Blink( float totalBlinkTime, int numberOfBlinks) {
    float halfPeriod = totalBlinkTime / (2 * numberOfBlinks);
	for(int i = 0; i < numberOfBlinks; i++) {
	    write2LedStrip();   //turn on the led strip
	    delay(halfPeriod);
		clearLedStrip();    //clear the led strip
		delay(halfPeriod);
	}
}

//Function: Write colormapping values to controller
void write2LedStrip(void) {
    //set the three PWM pins according to the data read from setColor()
    //also scale the values with map() so that the R, G, and B brightnesses are balanced.
    analogWrite(redPin, map(colors[0], 0, 255, 0, max_red));
    analogWrite(greenPin, map(colors[1], 0, 255, 0, max_green));
    analogWrite(bluePin, map(colors[2], 0, 255, 0, max_blue));
}

//Function: Reset colormapping value to 0 and write to controller
void clearLedStrip (void) {
    analogWrite(redPin, map(0, 0, 255, 0, max_red));
    analogWrite(greenPin, map(0, 0, 255, 0, max_green));
    analogWrite(bluePin, map(0, 0, 255, 0, max_blue));
}

//Function: Reset to default values
void reset(void) {
    colors[0] = defaultRGBValue;
    colors[1] = defaultRGBValue;
	colors[2] = defaultRGBValue;
    sequenceTime = defaultSeqTime, numberOfPulses = defaultPulses; 
}

//Function Testfunction not related to the rest of the program
void testFunction (void) {
//    if(up_down == 1) {
        for(int i =0 ; i <256; i++) {
            analogWrite(redPin, i);
            analogWrite(greenPin, i);
            analogWrite(bluePin, i);
            delay(10);
			if( i == 255) up_down = 0;
        }
//    } 
//	if(up_down == 0) {
        for(int j = 255 ; j >= 0; j--) {
            analogWrite(redPin, j);
            analogWrite(greenPin, j);
            analogWrite(bluePin, j);
            delay(10);
			if( j == 1) up_down = 1;
		}
//	}
	
}





