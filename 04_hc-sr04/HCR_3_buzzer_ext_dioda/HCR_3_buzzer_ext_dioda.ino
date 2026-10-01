const int trigPin = 9;
const int echoPin = 10;
const int buzzerPin = 7;    // zewnętrzny buzzer (moduł, pin 7)
const int ledPin = 6;       // dioda z latarni (ta sama co wcześniej)

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // pomiar odległości
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
    // piknięcie + mignięcie diody RAZEM
    digitalWrite(ledPin, HIGH);
    tone(buzzerPin, 1000, 50);
    delay(50);
    digitalWrite(ledPin, LOW);
    delay(odleglosc * 10);     // im bliżej, tym krótsza przerwa = szybsze pikanie i miganie
  } else {
    noTone(buzzerPin);
    digitalWrite(ledPin, LOW);  // daleko -> cisza i ciemno
    delay(200);
  }
}