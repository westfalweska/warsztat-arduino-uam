const int trigPin = 9;
const int echoPin = 10;
const int buzzerPin = 7;    // zewnętrzny buzzer pasywny (MOD-02963), pin 7
const int ledPin = 6;       // dioda z latarni, pin 6

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // --- pomiar odległości ---
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

  // --- alarm parkowania: ton + rytm + dioda ---
  if (odleglosc > 0 && odleglosc < 30) {
    int ton = map(odleglosc, 0, 30, 2000, 200);  // blisko = wyższy ton (2000 Hz), daleko = niższy (200 Hz)

    digitalWrite(ledPin, HIGH);
    tone(buzzerPin, ton, 50);     // piknięcie o danej wysokości, przez 50 ms
    delay(50);
    digitalWrite(ledPin, LOW);
    delay(odleglosc * 10);        // im bliżej, tym krótsza przerwa = szybszy rytm
  } else {
    noTone(buzzerPin);            // daleko -> cisza i ciemno
    digitalWrite(ledPin, LOW);
    delay(200);
  }
}