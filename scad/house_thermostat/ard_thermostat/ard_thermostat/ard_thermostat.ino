// Include the libraries we need
#include <Wire.h> 
#include <OneWire.h>
#include <DallasTemperature.h>
#include <RtcDS3231.h>
#include <PololuLedStrip.h>

// Data wire is plugged into port 2 on the Arduino
#define ONE_WIRE_BUS 2

#define DISP_OFF   0
#define DISP_SP    1
#define DISP_TEMP  2
#define DISP_TIME  3
#define DISP_MAX   4


bool await_diff=false;
int looper=0;
int display_state = DISP_OFF;
int room_temp = 0;


int set_point_fixed[] = {15,18};
int set_point = 15;

int rtc_dow =0;
int TME_H=0;
int TME_M=0;

int temp_idx = 0;

bool heater_on=false;

int get_current_temp(void)
{
  int ret = 0;  
  int mn=TME_H*100+TME_M;  
  if ((rtc_dow==0) || (rtc_dow==6))
  {
    // weekend
    if (mn > 0530)      { ret = 1; }
    else if (mn > 0715) { ret = 0; }
    else if (mn > 1630) { ret = 1; }
    else if (mn > 2200) { ret = 0; }
  }
  else
  {
    //weekday
    if (mn > 0530)      { ret = 1; }
    else if (mn > 0715) { ret = 0; }
    else if (mn > 1630) { ret = 1; }
    else if (mn > 2200) { ret = 0; }
  }
}

// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature. 
DallasTemperature sensors(&oneWire);

RtcDS3231<TwoWire> Rtc(Wire);

// Create an ledStrip object and specify the pin it will use.
PololuLedStrip<3> ledStrip;

// Create a buffer for holding the colors (3 bytes per color).
#define LED_COUNT 3
rgb_color colors[LED_COUNT];

int digit1 = 4;
int digit2 = 8;
int digit3 = A2;
int digit4 = 7;
int segA = 12;
int segB = 10;
int segC = 5;
int segD = 9;
int segE = 13;
int segF = 11;
int segG = 6;
int dir1 = A0;
int dir2 = A1;
int heater_pin = A3;

void setup() 
{                
  Serial.begin(19200); //choose the serial speed here
  Serial.setTimeout(500);
  pinMode(dir1, INPUT);
  pinMode(dir2, INPUT);
   
  pinMode(segA, OUTPUT);
  pinMode(segB, OUTPUT);
  pinMode(segC, OUTPUT);
  pinMode(segD, OUTPUT);
  pinMode(segE, OUTPUT);
  pinMode(segF, OUTPUT);
  pinMode(segG, OUTPUT);

  pinMode(digit1, OUTPUT);
  pinMode(digit2, OUTPUT);
  pinMode(digit3, OUTPUT);
  pinMode(digit4, OUTPUT);
  
  pinMode(13, OUTPUT);
  pinMode(heater_pin,OUTPUT);
 

  // Start up the library
  sensors.begin();
  sensors.setWaitForConversion(false);  // makes it async

  Rtc.Begin();

    // if you are using ESP-01 then uncomment the line below to reset the pins to
    // the available pins for SDA, SCL
    // Wire.begin(0, 2); // due to limited pins, use pin 0 and 2 for SDA, SCL

    RtcDateTime compiled = RtcDateTime(__DATE__, __TIME__);
    Serial.println();

    if (!Rtc.IsDateTimeValid()) 
    {
        // Common Cuases:
        //    1) first time you ran and the device wasn't running yet
        //    2) the battery on the device is low or even missing

        Serial.println("RTC lost confidence in the DateTime!");

        // following line sets the RTC to the date & time this sketch was compiled
        // it will also reset the valid flag internally unless the Rtc device is
        // having an issue

        Rtc.SetDateTime(compiled);
    }

    if (!Rtc.GetIsRunning())
    {
        Serial.println("RTC was not actively running, starting now");
        Rtc.SetIsRunning(true);
    }

    RtcDateTime now = Rtc.GetDateTime();
    if (now < compiled) 
    {
        Serial.println("RTC is older than compile time!  (Updating DateTime)");
        Rtc.SetDateTime(compiled);
    }
    else if (now > compiled) 
    {
        Serial.println("RTC is newer than compile time. (this is expected)");
    }
    else if (now == compiled) 
    {
        Serial.println("RTC is the same as compile time! (not expected but all is fine)");
    }

    // never assume the Rtc was last configured by you, so
    // just clear them to your needed state
    Rtc.Enable32kHzPin(false);
    Rtc.SetSquareWavePin(DS3231SquareWavePin_ModeNone); 

    Serial.println("Ready");
}

bool read_ring_changed(void)
{
  int d1=digitalRead(dir1);
  int d2=digitalRead(dir2);
  if (await_diff)
  {
    if (d1!=d2)
    {
        if (d1>0)
        {
          if (set_point < 30)
          {
            set_point++;
          }
        }
        else
        {
          i 00000sf (set_point > 0)
          {
            set_point--;
          }
        }
        await_diff=false;
        return true;
    }
  }
  if ((d1==1) && (d2==1))
  {
    await_diff=true;
  }  
  return false;
}


void do_display(void)
{
  int tme=0;
  switch(display_state)
  {
    case DISP_SP:
        displayNumbers(13,14,set_point/10,set_point%10);
        set_sp_colour();
        break;
    case DISP_TEMP:
        displayNumbers(room_temp/10,room_temp%10,11,12);
        set_temp_colour();
        break;
    case DISP_TIME:
        tme = TME_H;
        tme*=100;
        tme+=TME_M;
        displayNumber(tme);
        set_day_of_week_colour();
        break;
    case DISP_OFF:
        set_temp_colour();
    default:
        displayOff();
        break;
  }
}

void do_heater_control()
{
  if (heater_on==true)
  {
    Serial.print(millis());
    Serial.println("Heater On");
    digitalWrite(heater_pin,HIGH);
  }
  else
  {
    Serial.print(millis());
    Serial.println("Heater Off");
    digitalWrite(heater_pin,LOW);
  }
}

void set_day_of_week_colour(void)
{
    if (( rtc_dow ==0 ) || (rtc_dow == 6))
    {
      colors[0]=rgb_color{0,20,0};
      colors[1]=rgb_color{0,0,0};
      colors[2]=rgb_color{0,20,0};
    }
    else
    {
      colors[0]=rgb_color{0,0,0};
      colors[1]=rgb_color{6,0,14};
      colors[2]=rgb_color{0,0,0};
    }
   ledStrip.write(colors, LED_COUNT);  
}

void set_temp_colour(void)
{
  if (temp_idx==0)
  {
      colors[1]=rgb_color{0,0,10};
  }
  else
  {
      colors[1]=rgb_color{10,0,0};
  }
   if (room_temp < set_point)
   {
      colors[0]=rgb_color{20,0,0};
      colors[2]=rgb_color{20,0,0};
   }
   else if (room_temp > set_point)
   {
      colors[0]=rgb_color{0,0,20};
      colors[2]=rgb_color{0,0,20};
   }
   else
   {
      colors[0]=rgb_color{10,10,0};
      colors[2]=rgb_color{10,10,0};
   }
   ledStrip.write(colors, LED_COUNT);  
}

void set_sp_colour(void)
{
  set_temp_colour();
}

void do_temperature(void)
{
   //Serial.print("T:");
   room_temp=sensors.getTempCByIndex(0);
   //Serial.println(room_temp);
   sensors.requestTemperatures();

    int gt= get_current_temp();
    if (gt != temp_idx)
    {
      temp_idx=gt;
      set_point=set_point_fixed[temp_idx];
    }
   if (room_temp < set_point)
   {
      heater_on=true;
   }
   else if (room_temp > set_point)
   {
      heater_on=false;
   }
   else
   {
    // leav alone for hysterisis
   }
   set_temp_colour();
}

int disp_loop=0;
void loop() 
{
  do_display();

  if (read_ring_changed()== true)
  {
    //Serial.print("Num : ");
    //Serial.println(set_point);    
    display_state = DISP_SP;
    looper=101;
  }
  
  
  if (looper==0)
  {
     RtcDateTime now = Rtc.GetDateTime();
     rtc_dow = now.DayOfWeek();
     do_temperature();
     TME_H = now.Hour();
     TME_M = now.Minute();
     display_state = DISP_OFF;
   
  }
  else if (looper==100)
  {
    display_state = disp_loop;
    disp_loop++;
    if (disp_loop >= DISP_MAX)
    {
      do_heater_control();
      disp_loop=0;
    }
  }
  
  looper++;
  if (looper==4000)
  {
    looper=0;
  }
//  delay(10);  
}

//Given a number, we display 10:22
//After running through the 4 numbers, the display is left turned off

//Display brightness
//Each digit is on for a certain amount of microseconds
//Then it is off until we have reached a total of 20ms for the function call
//Let's assume each digit is on for 1000us
//Each digit is on for 1ms, there are 4 digits, so the display is off for 16ms.
//That's a ratio of 1ms to 16ms or 6.25% on time (PWM).
//Let's define a variable called brightness that varies from:
//5000 blindingly bright (15.7mA current draw per digit)
//2000 shockingly bright (11.4mA current draw per digit)
//1000 pretty bright (5.9mA)
//500 normal (3mA)
//200 dim but readable (1.4mA)
//50 dim but readable (0.56mA)
//5 dim but readable (0.31mA)
//1 dim but readable in dark (0.28mA)


void displayOff(void) 
{
  digitalWrite(segA, LOW);
  digitalWrite(segB, LOW);
  digitalWrite(segC, LOW);
  digitalWrite(segD, LOW);
  digitalWrite(segE, LOW);
  digitalWrite(segF, LOW);
  digitalWrite(segG, LOW);
  digitalWrite(digit1, LOW);
  digitalWrite(digit2, LOW);
  digitalWrite(digit3, LOW);
  digitalWrite(digit4, LOW);}


void displayNumber(int toDisplay) 
{

#define DISPLAY_WAIT        5
#define DISPLAY_BRIGHTNESS  200

#define DIGIT_ON  LOW
#define DIGIT_OFF  HIGH

  long beginTime = millis();

  for(int digit = 4 ; digit > 0 ; digit--) {

    //Turn on a digit for a short amount of time
    switch(digit) {
    case 1:
      digitalWrite(digit1, DIGIT_ON);
      break;
    case 2:
      digitalWrite(digit2, DIGIT_ON);
      break;
    case 3:
      digitalWrite(digit3, DIGIT_ON);
      break;
    case 4:
      digitalWrite(digit4, DIGIT_ON);
      break;
    }

    //Turn on the right segments for this digit
    lightNumber(toDisplay % 10);
    toDisplay /= 10;

    delayMicroseconds(DISPLAY_BRIGHTNESS); 
    //Display digit for fraction of a second (1us to 5000us, 500 is pretty good)

    //Turn off all segments
    lightNumber(10); 

    //Turn off all digits
    digitalWrite(digit1, DIGIT_OFF);
    digitalWrite(digit2, DIGIT_OFF);
    digitalWrite(digit3, DIGIT_OFF);
    digitalWrite(digit4, DIGIT_OFF);
  }

  while( (millis() - beginTime) < DISPLAY_WAIT) ; 
  //Wait for 20ms to pass before we paint the display again
}


void displayNumbers(int A,int B, int C, int D) 
{

#define DISPLAY_WAIT        5
#define DISPLAY_BRIGHTNESS  200

#define DIGIT_ON  LOW
#define DIGIT_OFF  HIGH

  long beginTime = millis();

  for(int digit = 4 ; digit > 0 ; digit--) {

    //Turn on a digit for a short amount of time
    switch(digit) {
    case 1:
      digitalWrite(digit1, DIGIT_ON);
      lightNumber(A);
      break;
    case 2:
      digitalWrite(digit2, DIGIT_ON);
      lightNumber(B);
      break;
    case 3:
      digitalWrite(digit3, DIGIT_ON);
      lightNumber(C);
      break;
    case 4:
      digitalWrite(digit4, DIGIT_ON);
      lightNumber(D);
      break;
    }


    delayMicroseconds(DISPLAY_BRIGHTNESS); 
    //Display digit for fraction of a second (1us to 5000us, 500 is pretty good)

    //Turn off all segments
    lightNumber(10); 

    //Turn off all digits
    digitalWrite(digit1, DIGIT_OFF);
    digitalWrite(digit2, DIGIT_OFF);
    digitalWrite(digit3, DIGIT_OFF);
    digitalWrite(digit4, DIGIT_OFF);
  }

  while( (millis() - beginTime) < DISPLAY_WAIT) ; 
  //Wait for 20ms to pass before we paint the display again
}

//Given a number, turns on those segments
//If number == 10, then turn off number
void lightNumber(int numberToDisplay) {

#define SEGMENT_ON  HIGH
#define SEGMENT_OFF LOW

  switch (numberToDisplay){

  case 0:
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_ON);
    digitalWrite(segE, SEGMENT_ON);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_OFF);
    break;

  case 1:
    digitalWrite(segA, SEGMENT_OFF);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_OFF);
    digitalWrite(segE, SEGMENT_OFF);
    digitalWrite(segF, SEGMENT_OFF);
    digitalWrite(segG, SEGMENT_OFF);
    break;

  case 2:
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_OFF);
    digitalWrite(segD, SEGMENT_ON);
    digitalWrite(segE, SEGMENT_ON);
    digitalWrite(segF, SEGMENT_OFF);
    digitalWrite(segG, SEGMENT_ON);
    break;

  case 3:
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_ON);
    digitalWrite(segE, SEGMENT_OFF);
    digitalWrite(segF, SEGMENT_OFF);
    digitalWrite(segG, SEGMENT_ON);
    break;

  case 4:
    digitalWrite(segA, SEGMENT_OFF);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_OFF);
    digitalWrite(segE, SEGMENT_OFF);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_ON);
    break;

  case 5:
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_OFF);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_ON);
    digitalWrite(segE, SEGMENT_OFF);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_ON);
    break;

  case 6:
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_OFF);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_ON);
    digitalWrite(segE, SEGMENT_ON);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_ON);
    break;

  case 7:
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_OFF);
    digitalWrite(segE, SEGMENT_OFF);
    digitalWrite(segF, SEGMENT_OFF);
    digitalWrite(segG, SEGMENT_OFF);
    break;

  case 8:
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_ON);
    digitalWrite(segE, SEGMENT_ON);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_ON);
    break;

  case 9:
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_ON);
    digitalWrite(segE, SEGMENT_OFF);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_ON);
    break;

  case 10:
    digitalWrite(segA, SEGMENT_OFF);
    digitalWrite(segB, SEGMENT_OFF);
    digitalWrite(segC, SEGMENT_OFF);
    digitalWrite(segD, SEGMENT_OFF);
    digitalWrite(segE, SEGMENT_OFF);
    digitalWrite(segF, SEGMENT_OFF);
    digitalWrite(segG, SEGMENT_OFF);
    break;
  case 11: // degree
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_OFF);
    digitalWrite(segD, SEGMENT_OFF);
    digitalWrite(segE, SEGMENT_OFF);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_ON);
    break;
  case 12: // C
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_OFF);
    digitalWrite(segC, SEGMENT_OFF);
    digitalWrite(segD, SEGMENT_ON);
    digitalWrite(segE, SEGMENT_ON);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_OFF);
    break;
  case 13: // S
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_OFF);
    digitalWrite(segC, SEGMENT_ON);
    digitalWrite(segD, SEGMENT_ON);
    digitalWrite(segE, SEGMENT_OFF);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_ON);
    break;
  case 14: // P
    digitalWrite(segA, SEGMENT_ON);
    digitalWrite(segB, SEGMENT_ON);
    digitalWrite(segC, SEGMENT_OFF);
    digitalWrite(segD, SEGMENT_OFF);
    digitalWrite(segE, SEGMENT_ON);
    digitalWrite(segF, SEGMENT_ON);
    digitalWrite(segG, SEGMENT_ON);
    break;
  }
}



