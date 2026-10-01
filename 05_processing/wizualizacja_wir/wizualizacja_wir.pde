// ĆWICZENIE 6 (wariant 2) — Wir z siatki, sterowany ruchem ręki
// ==============================================================
// Inspirowane szkicem p5.js (siatka cząsteczek przyciąganych do środka).
// Przerobione na Processing (Java) + sterowanie czujnikiem HC-SR04.
//
//   REKA DALEKO -> cząsteczki wracają do SIATKI: porządek, chłodne barwy, spokój.
//   REKA BLISKO -> są WCIĄGANE do środka, nabierają WIRU, przyspieszają,
//                  gęstnieją w centrum i rozświetlają się kolorem.
//
// Ręka steruje naraz: prędkością, kierunkiem (wir), kolorem i zagęszczeniem.
//
// JAK URUCHOMIĆ:
//   1. Wgraj .ino na Arduino i ZAMKNIJ Monitor szeregowy.
//   2. Ustaw "portIndex" na numer portu usbserial (czarne okno na dole).
//   3. Kliknij Play.

import processing.serial.*;

Serial port;
int portIndex = 3;            // <-- numer Twojego portu usbserial (u Ciebie [3])

float odleglosc = 50;         // ostatnia odczytana odległość w cm
float energia = 0;            // 0 = spokój (ręka daleko), 1 = pełny wir (blisko)

int gridSize = 40;
ArrayList<Particle> czastki = new ArrayList<Particle>();

void setup() {
  size(800, 800);

  println("Dostepne porty szeregowe:");
  printArray(Serial.list());

  String nazwaPortu = Serial.list()[portIndex];
  port = new Serial(this, nazwaPortu, 9600);
  port.bufferUntil('\n');

  // Rozstaw cząsteczki w regularnej siatce — to ich "dom".
  for (int x = gridSize/2; x < width; x += gridSize) {
    for (int y = gridSize/2; y < height; y += gridSize) {
      czastki.add(new Particle(x, y));
    }
  }
}

void draw() {
  // Zamień odległość (blisko=5cm ... daleko=60cm) na ENERGIĘ (1 ... 0).
  float cel = map(odleglosc, 5, 60, 1, 0);
  cel = constrain(cel, 0, 1);
  energia += (cel - energia) * 0.08;   // płynne dociąganie

  // W spokoju czyści tło do czysta; w wirze zostawia smugi (ślad ruchu).
  float zanik = map(energia, 0, 1, 255, 45);
  noStroke();
  fill(0, zanik);
  rect(0, 0, width, height);

  PVector srodek = new PVector(width/2, height/2);

  for (Particle p : czastki) {
    p.sily(srodek, energia);
    p.update(energia);
    p.rysuj(energia);
  }

  fill(255);
  textSize(14);
  text("Odleglosc: " + int(odleglosc) + " cm   |   Energia wiru: " + int(energia*100) + "%", 20, 28);
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

// ---- Jedna cząsteczka ----
class Particle {
  PVector poz;
  PVector pred;
  PVector dom;      // miejsce w siatce, do którego wraca w spokoju

  Particle(float x, float y) {
    dom  = new PVector(x, y);
    poz  = new PVector(x, y);
    pred = new PVector();
  }

  void sily(PVector srodek, float energia) {
    PVector sila = new PVector();

    // 1. POWRÓT DO DOMU — mocny, gdy energia mała (ręka daleko).
    PVector doDomu = PVector.sub(dom, poz);
    doDomu.mult(0.05 * (1 - energia));
    sila.add(doDomu);

    // 2. PRZYCIĄGANIE DO ŚRODKA — mocne, gdy energia duża (ręka blisko).
    PVector doSrodka = PVector.sub(srodek, poz);
    float dist = max(doSrodka.mag(), 5);
    doSrodka.normalize();
    doSrodka.mult(0.9 * energia);
    sila.add(doSrodka);

    // 3. WIR — siła prostopadła do kierunku na środek = krążenie.
    //    Im bliżej środka i im większa energia, tym szybszy obrót.
    PVector wir = new PVector(-doSrodka.y, doSrodka.x);
    wir.mult((3000 / dist) * 0.02 * energia);
    sila.add(wir);

    pred.add(sila);
  }

  void update(float energia) {
    pred.mult(0.90);                       // opór — ruch wygasa
    float maxPred = map(energia, 0, 1, 2, 14);
    pred.limit(maxPred);
    poz.add(pred);
  }

  void rysuj(float energia) {
    // Rozmiar z szumu Perlina (jak w oryginale) + lekko rośnie z energią.
    float rozmiar = noise(poz.x * 0.005, poz.y * 0.005) * 18 + 3 + energia * 4;

    // Kolor: odcień z szumu (płynne przejścia), wędruje w czasie.
    // Nasycenie i jasność rosną z energią -> spokój chłodny, wir barwny.
    float odcien = (noise(poz.x * 0.004, poz.y * 0.004) * 360 + millis() * 0.02) % 360;
    float nasyc  = map(energia, 0, 1, 35, 95);
    float jasn   = map(energia, 0, 1, 70, 100);

    colorMode(HSB, 360, 100, 100);
    fill(odcien, nasyc, jasn, 85);
    noStroke();
    ellipse(poz.x, poz.y, rozmiar, rozmiar);
    colorMode(RGB, 255);
  }
}
