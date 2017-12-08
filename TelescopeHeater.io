int ThermistorPin = A0;
int ThermistorPin2 = A1;
int relayPin = 2;
int activeLight = 4;
int powerLight = 3;
int Vo;
float R1 = 10000;
float logR2, R2, T, T2, targetTemp;
float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07;

void setup() {
Serial.begin(9600);
  pinMode(relayPin, OUTPUT);
  pinMode(activeLight, OUTPUT);
  pinMode(powerLight, OUTPUT);
        digitalWrite(powerLight, HIGH); 
        digitalWrite(activeLight, LOW);

}

float getTemp() {
  Vo = analogRead(ThermistorPin);
  R2 = R1 * (1023.0 / (float)Vo - 1.0);
  logR2 = log(R2);
  T = (1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2));
  T = T - 273.15;
  T = (T * 9.0)/ 5.0 + 32.0; 

  Serial.print("Ambient: "); 
  Serial.print(T);
  Serial.println(" F");
  return T;
}

float getTemp2() {
  Vo = analogRead(ThermistorPin2);
  R2 = R1 * (1023.0 / (float)Vo - 1.0);
  logR2 = log(R2);
  T2 = (1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2));
  T2 = T2 - 273.15;
  T2 = (T2 * 9.0)/ 5.0 + 32.0; 

  Serial.print("Scope: "); 
  Serial.print(T2);
  Serial.println(" F");
  return T2;
}

void Regulate(float targetTemp, unsigned long interval) {
  float currentTemp;
  interval= interval * 1000;
  unsigned long initialTime = millis();
    while ((millis()-initialTime) < (interval)) {
      currentTemp=getTemp2();
      if(currentTemp <= targetTemp) {
        digitalWrite(relayPin, HIGH); 
        digitalWrite(activeLight, HIGH); 
      }
      else {
        digitalWrite(relayPin, LOW);
        digitalWrite(activeLight, LOW);
      }
      delay(1000);
    }
}

void loop() {

 targetTemp = getTemp()+2;
 Regulate(targetTemp, 5);

 
}
