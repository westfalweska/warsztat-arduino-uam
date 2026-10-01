#include "DHT.h"

#define DHTPIN 4
#define DHTTYPE DHT11

const int ledPin = 6;
const int buzzerPin = 8;           // wbudowany buzzer Maker Uno
const float progTemperatury = 28;  // ustaw wg swojego pokoju!

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  dht.begin();
}

void loop() {
  delay(2000);

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
    digitalWrite(ledPin, HIGH);
    tone(buzzerPin, 1000);           // dzwiek o czestotliwosci 1000 Hz
    Serial.println("   >>> ALARM: za goraco!");
  } else {
    digitalWrite(ledPin, LOW);
    noTone(buzzerPin);               // cisza
  }
}