// ĆWICZENIE 6 (wariant 3) — Przepływ z szumu, sterowany ruchem ręki
// =================================================================
// Inspirowane szkicem "surfs_up" (tysiące pikseli płynących wzdłuż
// kierunków wyznaczonych przez szum Perlina). Przerobione na sterowanie
// czujnikiem HC-SR04 + większy canvas + bogatsze kolory.
//
//   REKA DALEKO -> wolny, spokojny przepływ, długie delikatne smugi,
//                  chłodna, stonowana paleta.
//   REKA BLISKO -> szybki, żywy przepływ, krótsze smugi, pełnia kolorów
//                  wędrujących w czasie (tęcza płynąca przez ekran).
//
// Ręka steruje: prędkością przepływu, długością smug i kolorem.
//
// Klawisz spacji = przebuduj cząsteczki od nowa.
//
// JAK URUCHOMIĆ:
//   1. Wgraj .ino na Arduino i ZAMKNIJ Monitor szeregowy.
//   2. Ustaw "portIndex" na numer portu usbserial (czarne okno na dole).
//   3. Kliknij Play.

import processing.serial.*;

Serial port;
int portIndex = 3;            // <-- numer Twojego portu usbserial (u Ciebie [3])

float odleglosc = 50;         // ostatnia odczytana odległość w cm
float energia = 0;            // 0 = spokój (ręka daleko), 1 = pełnia (blisko)

int ILE = 24000;
Particle[] czastki;

void setup() {
  size(1000, 1000);
  background(0);
  noStroke();

  println("Dostepne porty szeregowe:");
  printArray(Serial.list());

  String nazwaPortu = Serial.list()[portIndex];
  port = new Serial(this, nazwaPortu, 9600);
  port.bufferUntil('\n');

  setParticles();
}

void draw() {
  // Zamień odległość (blisko=5cm ... daleko=60cm) na ENERGIĘ (1 ... 0).
  float cel = map(odleglosc, 5, 60, 1, 0);
  cel = constrain(cel, 0, 1);
  energia += (cel - energia) * 0.08;

  // Smuga: w spokoju długa i delikatna, w pędzie krótsza (mocniejsze czyszczenie).
  float alpha = map(energia, 0, 1, 4, 40);
  colorMode(RGB, 255);
  fill(0, alpha);
  rect(0, 0, width, height);

  // Prędkość przepływu rośnie z energią — szeroki zakres, żeby było WYRAŹNIE.
  float predkosc = map(energia, 0, 1, 0.15, 6.5);

  colorMode(HSB, 360, 100, 100);   // kolory cząsteczek liczone w HSB
  loadPixels();
  for (Particle p : czastki) {
    p.move(predkosc, energia);
  }
  updatePixels();
  colorMode(RGB, 255);

  // Napis kontrolny — od razu widać, czy czujnik działa i jak reaguje energia.
  fill(255);
  textSize(16);
  text("Odleglosc: " + int(odleglosc) + " cm   |   Energia przeplywu: " + int(energia*100) + "%", 20, 30);
}

void setParticles() {
  czastki = new Particle[ILE];
  for (int i = 0; i < ILE; i++) {
    czastki[i] = new Particle(random(width), random(height));
  }
}

void keyPressed() {
  if (key == ' ') setParticles();   // spacja = reset
}

// Czyta liczbę przysłaną przez Arduino (uruchamia się samo przy każdej linii).
void serialEvent(Serial p) {
  String linia = p.readStringUntil('\n');
  if (linia != null) {
    linia = trim(linia);
    float w = float(linia);
    if (!Float.isNaN(w)) odleglosc = w;
  }
}

// ---- Jedna cząsteczka-piksel ----
class Particle {
  float posX, posY, incr, theta;
  float baza;              // bazowy odcień (różny dla każdej cząsteczki)

  Particle(float x, float y) {
    posX = x;
    posY = y;
    baza = random(360);
  }

  void move(float predkosc, float energia) {
    update(predkosc);
    wrap();
    display(energia);
  }

  void update(float predkosc) {
    incr += 0.008;
    // Kierunek ruchu z szumu Perlina 3D (x, y, czas) -> płynne, organiczne prądy.
    theta = noise(posX * 0.005, posY * 0.005, incr) * TWO_PI;
    posX += predkosc * cos(theta);
    posY += predkosc * sin(theta);
  }

  void display(float energia) {
    if (posX > 0 && posX < width && posY > 0 && posY < height) {
      // Odcień: bazowy + kierunek ruchu + powolna wędrówka w czasie.
      // Dzięki temu kolory płyną i mienią się przez cały ekran.
      float odcien = (baza + degrees(theta) + millis() * 0.01) % 360;
      float nasyc  = map(energia, 0, 1, 45, 100);   // spokój stonowany, pęd żywy
      float jasn   = map(energia, 0, 1, 80, 100);
      pixels[(int)posX + (int)posY * width] = color(odcien, nasyc, jasn);
    }
  }

  void wrap() {
    if (posX < 0) posX = width;
    if (posX > width) posX = 0;
    if (posY < 0) posY = height;
    if (posY > height) posY = 0;
  }
}
