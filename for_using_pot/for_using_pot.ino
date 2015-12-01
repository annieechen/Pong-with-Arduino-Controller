/*
  AnalogReadSerial
  Reads an analog input on pin 0, prints the result to the serial monitor.
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.

 This example code is in the public domain.
 */
// Define pins
const int button_pinA = 2;    // pushbutton 1

const int led_pin =  13;    // LED pin

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  
  // Push button pin is an INPUT:
  pinMode(button_pinA, INPUT);

  // LED pin is an OUTPUT:
  pinMode(led_pin, OUTPUT);      
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 0:
  int sensorValue = analogRead(A0);
  int buttonA = digitalRead(button_pinA);
  // print out the value you read:
  Serial.println(sensorValue);
  Serial.print(buttonA);
  Serial.print("x");
  delay(100);        // delay in between reads for stability
  // button states

  

  // Read the state of the button:
  //   Pushed: connected to GND, STATE is LOW
  //   Not pushed: connected to 5V through pull-up resistor, STATE is HIGH
  buttonA = digitalRead(button_pinA);

  
  // Turn the LED on if only one button is pushed
  // otherwise turn the LED off.
  if (buttonA == LOW) { 
    digitalWrite(led_pin, HIGH);  // turn on LED
  }
  else {
    digitalWrite(led_pin, LOW);   // turn off LED
  }
}
