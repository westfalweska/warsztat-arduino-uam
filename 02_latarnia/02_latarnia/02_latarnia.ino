const int ledPin = 6;
const int prog = 400;

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  int poziomSwiatla = analogRead(A0);
  Serial.println(poziomSwiatla);
  if (poziomSwiatla < prog) {
    digitalWrite(ledPin, HIGH);
  } else {
    digitalWrite(ledPin, LOW);
  }
  delay(200);
}
