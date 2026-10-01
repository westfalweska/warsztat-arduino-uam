// ĆWICZENIE 6 — Arduino rozmawia z Processing
// Czujnik odległości HC-SR04 steruje wizualizacją na ekranie komputera.
//
// To jest PRAWIE ten sam kod co w ćwiczeniu 5. Jedyna ważna różnica
// jest na samym dole: zamiast wysyłać "Odleglosc: 37 cm" wysyłamy
// SAMĄ LICZBĘ. Dlaczego? Bo tę liczbę będzie czytał drugi program
// (Processing), a nie człowiek — a programowi łatwiej odczytać czysto "37".

const int trigPin = 9;
const int echoPin = 10;

void setup() {
  Serial.begin(9600);         // ta sama prędkość musi być ustawiona w Processing!
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

  // Czasem czujnik "gubi" echo i zwraca 0 — pomijamy takie błędne odczyty,
  // żeby wizualizacja nie skakała.
  if (odleglosc > 0 && odleglosc < 200) {
    Serial.println(odleglosc);   // <-- SAMA LICZBA + znak końca linii
  }

  delay(50);   // ~20 odczytów na sekundę = płynny ruch obrazu
}
