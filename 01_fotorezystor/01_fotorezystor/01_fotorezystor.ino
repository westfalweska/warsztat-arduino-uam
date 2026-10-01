void setup() {
  Serial.begin(9600);
}

void loop() {
  int wartosc = analogRead(A0);
  Serial.println(wartosc);
  delay(200);
}
