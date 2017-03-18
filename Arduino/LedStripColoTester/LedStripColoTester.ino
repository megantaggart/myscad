#include <PololuLedStrip.h>

// Create an ledStrip object and specify the pin it will use.
PololuLedStrip<12> ledStrip;

// Create a buffer for holding the colors (3 bytes per color).
#define LED_COUNT 18
rgb_color colors[LED_COUNT];

void setup()
{
  // Start up the serial port, for communication with the PC.
  Serial.begin(115200);
  Serial.println("Ready."); 
}

void test(int l,int r, int g, int b)
{
    l+=LED_COUNT;
    colors[l % LED_COUNT].red=r;
    colors[l % LED_COUNT].green=g;
    colors[l % LED_COUNT].blue=b;
   
}

#define BR  40
void loop()
{
  for(int l=0;l<LED_COUNT;l++)
  {
    for (int i=0;i<LED_COUNT;i++)
    {
      colors[i].red=0;
      colors[i].green=0;
      colors[i].blue=0;
    }


    test(l,BR,0,0);
    test(l-1,BR/2,BR/2,0);
    test(l-2,0,BR,0);
    test(l-3,0,BR/2,BR/2);
    test(l-4,0,0,BR);
    test(l-5,BR/2,0,BR/2);

    // Write to the LED strip.
    ledStrip.write(colors, LED_COUNT);  

    delay(150);
  }
}
