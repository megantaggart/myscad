#include <PololuLedStrip.h>

// Create an ledStrip object and specify the pin it will use.
PololuLedStrip<12> ledStrip;

// Create a buffer for holding the colors (3 bytes per color).
#define LED_COUNT 10
rgb_color colors[LED_COUNT];


//300 color values times "duration" milliseconds is the time the sunrise goes for.
//The sunset is set to 1/6 of that time. At 6000ms this will take 30mins for a sunrise,
//and 5mins for a sunset. This value can be changed by the slider on the webpage, 
//from 0 to 6000.

#define NUM_BUTTONS 2
#define PRESS_WAIT  50
#define BUTTON_1  4
#define BUTTON_2  8

double p = 0;
double inc = -10;
double r,g,b;
bool inc_from_analog = false;

int button_pins[NUM_BUTTONS]={BUTTON_1,BUTTON_2};
int press_count[NUM_BUTTONS] = {0,0};
bool button_state[NUM_BUTTONS] = {false,false};
bool button_state_changed[NUM_BUTTONS] = {false,false};

void read_buttons(void)
{
  for (int i=0;i<NUM_BUTTONS;i++)
  {
    if (digitalRead(button_pins[i])==0)
    {
      if (button_state[i]==true)
      {
        if (press_count[i]++ > PRESS_WAIT)
        {
          press_count[i]=0;
          button_state[i]=false;
          button_state_changed[i]=true;
        }
      }
    }
    else
    {
      if (button_state[i]==false)
      {
        if (press_count[i]++ > PRESS_WAIT)
        {
          press_count[i]=0;
          button_state[i]=true;
          button_state_changed[i]=true;
        }
      }
    }
  }
}

void handle_buttons(void)
{
  for (int i=0;i<NUM_BUTTONS;i++)
  {
    if (button_state_changed[i]==true)
    {
      button_state_changed[i]=false;
      switch(i)
      {
        case 0:
          if (button_state[i]==true)
          {
            if (inc<0)
            {
              inc_from_analog=false;
              inc = 20;
            }
            else
            {
              inc_from_analog=false;
              inc = -20;
            }
          }
          break;
        case 1:
          if (button_state[i]==true)
          {
            inc_from_analog=true;
            inc = -inc;
          }
          break;
      }
    }
  }
}

void setup()
{
  // Start up the serial port, for communication with the PC.
  Serial.begin(19200);
  Serial.println("Ready."); 
  Serial.println(""); 
  // zero colours
  for(int i = 0; i < LED_COUNT; i++)
  {
    colors[i] = rgb_color{0,0,0};
  }
  for (int i=0;i<NUM_BUTTONS;i++)
  {
    pinMode(button_pins[i],INPUT);
  }
}

void loop() 
{
    if (inc_from_analog)
    {
      if (inc >0)
      {
          inc = (analogRead(A0)/500)+0.05;
      }
      else
      {
          inc = (analogRead(A0)/500)+0.05;
          inc =-inc;
      }
    }
    p+=inc;
    
    if (p < 0) { p=0;}
    if (p>10000) {p=10000;}

    read_buttons();
    handle_buttons();

    getRGBfromTemperature2(&r,&g,&b,p);
    int num_next_r_val = ((double)LED_COUNT)*(r-floor(r));
    int num_next_g_val = ((double)LED_COUNT)*(g-floor(g));
    int num_next_b_val = ((double)LED_COUNT)*(b-floor(b));

    for (int i =0;i<LED_COUNT;i++)
    {
      colors[i].red=r;
      colors[i].green=g;
      colors[i].blue=b;
      if (i<num_next_r_val) {colors[i].red++;}
      if (i<num_next_g_val) {colors[i].green++;}
      if (i<num_next_b_val) {colors[i].blue++;}
    }
    // Write to the LED strip.
    ledStrip.write(colors, LED_COUNT);  

    //delayMicroseconds
    delay(1);
}

double scale_col_val(double v)
{
    v/=1.2;
    if (v <0)   { v=0  ;}
    if (v >255) { v=255;}
    return v;
}

void getRGBfromTemperature2(double *r, double *g, double *b, double tmpKelvin)
{
    double tmpCalc;
    if (tmpKelvin < 0) {tmpKelvin = 0;}
    if (tmpKelvin > 40000) {tmpKelvin = 10000;}
    tmpKelvin = tmpKelvin / 100.0;
 
    //Red
    if (tmpKelvin < 10) 
    {
      tmpCalc=255.0 - ((1.5968*(10-tmpKelvin))*(1.5968*(10-tmpKelvin)));
    }
    else
    {
      tmpCalc = 255;
    }
    *r=scale_col_val(tmpCalc);
    
    //Green
    if (tmpKelvin <= 66)
    {
        //Note: the R-squared value for this approximation is .996
        tmpCalc = tmpKelvin;
        tmpCalc = 99.4708025861 * log(tmpCalc) - 161.1195681661;
    }
    else
    {
        tmpCalc = 255;
    }
    *g=scale_col_val(tmpCalc);
    
    //Blue
    if (tmpKelvin <= 19)
    {
      tmpCalc=0;
    }
    else
    {
        //Note: the R-squared value for this approximation is .998
        tmpCalc = tmpKelvin - 10;
        tmpCalc = 138.5177312231 * log(tmpCalc) - 305.0447927307;
    }
    *b=scale_col_val(tmpCalc);
}

