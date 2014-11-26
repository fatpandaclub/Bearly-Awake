#include "HX711.h"

HX711 scale(A1, A0);

int buttonPin = 0;
int buttonVal;
void setup() {
  Serial.begin(38400);
  scale.set_scale(39887.75f);
  scale.tare();
  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
  Serial.println(scale.get_units(5));
  
  buttonVal = digitalRead(buttonPin);
  if( buttonVal == LOW) {
  Serial.println("9999");
  } 
  //delay(50);
}

/*

2 kg: 73113,4
Scale: 36556,7
4 kg: 159551,0
Scale: 39887,75

*/
