#include "DHT.h"

#define DHTPIN 4        // nóżka DATA czujnika -> pin 4
#define DHTTYPE DHT11   // nasz czujnik to DHT11 (nie DHT22!)

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
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
}