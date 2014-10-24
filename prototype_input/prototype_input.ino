int potentiometerPin = A5;
int weightPin = A0;

int potentiometerVal = 0;  
int weight = 0;

void setup() {
  
 Serial.begin(9600); 
 
}

void loop() {
  potentiometerVal = analogRead(potentiometerPin);    
  weight = analogRead(weightPin);
  
  if(potentiometerVal < 512) {
    
    // off
  } else {
    
    // on
  }
  
  //Serial.println("Potentiometer: ");
  //Serial.println(potentiometerVal);
  
  //Serial.println(" " );
  
  //Serial.println("Flex: ");
  Serial.println(weight);
   
}
