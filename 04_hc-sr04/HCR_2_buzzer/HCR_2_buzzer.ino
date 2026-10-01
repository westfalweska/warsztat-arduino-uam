const int trigPin = 9;
const int echoPin = 10;
const int buzzerPin = 8;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  // pomiar odległości (jak wcześniej)
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long czas = pulseIn(echoPin, HIGH);
  int odleglosc = czas * 0.034 / 2;

  Serial.print("Odleglosc: ");
  Serial.print(odleglosc);
  Serial.println(" cm");

  if (odleglosc > 0 && odleglosc < 30) {
    tone(buzzerPin, 1000, 50);    // krótkie piknięcie (50 ms)
    delay(odleglosc * 10);        // im bliżej, tym KRÓTSZA przerwa = szybsze pikanie
  } else {
    noTone(buzzerPin);            // daleko -> cisza
    delay(200);
  }
}