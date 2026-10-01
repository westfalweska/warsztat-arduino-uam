const int trigPin = 9;
const int echoPin = 10;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);   // Trig: my wysyłamy
  pinMode(echoPin, INPUT);    // Echo: my słuchamy
}

void loop() {
  // 1. krótki impuls wyzwalający na Trig
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // 2. zmierz, jak długo Echo jest w stanie HIGH (czas lotu dźwięku, w mikrosekundach)
  long czas = pulseIn(echoPin, HIGH);

  // 3. przelicz czas na odległość w cm
  int odleglosc = czas * 0.034 / 2;

  Serial.print("Odleglosc: ");
  Serial.print(odleglosc);
  Serial.println(" cm");

  delay(200);
}