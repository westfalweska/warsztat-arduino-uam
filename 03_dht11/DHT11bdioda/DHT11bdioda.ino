#include "DHT.h"

#define DHTPIN 4
#define DHTTYPE DHT11

const int ledPin = 13;             // wbudowana dioda na pinie 13 - zero okablowania
const float progTemperatury = 28;  // prog alarmu w st.C - ustaw wg swojego pokoju!

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  dht.begin();
}

void loop() {
  delay(2000);  // DHT11 to wolny czujnik - min. 2 s między odczytami

  float wilgotnosc = dht.readHumidity();
  float temperatura = dht.readTemperature();

  if (isnan(wilgotnosc) || isnan(temperatura)) {
    Serial.println("Blad odczytu z czujnika!");
    return;
  }

  Serial.print("Wilgotnosc: ");
  Serial.print(wilgotnosc);
  Serial.print("%   Temperatura: ");
  Serial.print(temperatura);
  Serial.println(" st.C");

  if (temperatura > progTemperatury) {
    digitalWrite(ledPin, HIGH);          // za goraco -> alarm
    Serial.println("   >>> ALARM: za goraco!");
  } else {
    digitalWrite(ledPin, LOW);           // temperatura ok -> dioda zgaszona
  }
}