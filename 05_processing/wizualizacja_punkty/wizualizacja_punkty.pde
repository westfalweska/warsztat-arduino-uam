// ĆWICZENIE 6 — Hiperprzestrzeń sterowana ruchem ręki
// ====================================================
// Pole gwiazd lecących ku widzowi (efekt "skoku w nadprzestrzeń").
//
//   REKA DALEKO -> cisza: drobne, białe, prawie nieruchome punkty (gwiazdy).
//   REKA BLISKO -> punkty zaczynają DRŻEĆ i PĘDZIĆ w głąb, coraz szybciej,
//                  gęściej i z rozmyciem w smugi — wrażenie lotu przez tunel.
//
// JAK URUCHOMIĆ:
//   1. Wgraj .ino na Arduino i ZAMKNIJ Monitor szeregowy.
//   2. Ustaw "portIndex" na numer portu usbserial (patrz czarne okno na dole).
//   3. Kliknij Play.

import processing.serial.*;

Serial port;
int portIndex = 3;            // <-- numer Twojego portu usbserial (u Ciebie [3])

float odleglosc = 50;         // ostatnia odczytana odległość w cm
float energia = 0;            // 0 = cisza (ręka daleko), 1 = pełny pęd (blisko)

int ILE = 500;
Gwiazda[] gwiazdy = new Gwiazda[ILE];

void setup() {
  size(900, 600);

  println("Dostepne porty szeregowe:");
  printArray(Serial.list());

  String nazwaPortu = Serial.list()[portIndex];
  port = new Serial(this, nazwaPortu, 9600);
  port.bufferUntil('\n');

  for (int i = 0; i < ILE; i++) {
    gwiazdy[i] = new Gwiazda();
  }
}

void draw() {
  // Zamień odległość na ENERGIĘ. ODWRÓCONE: blisko=0 (cisza/stop), daleko=1 (pęd).
  float cel = map(odleglosc, 5, 60, 0, 1);
  cel = constrain(cel, 0, 1);
  energia += (cel - energia) * 0.08;   // płynne dociąganie, bez skoków

  // Tło: w ciszy czyści się do czysta (ostre, statyczne punkty);
  // przy pędzie zostawia smugi (rozmycie ruchu = wrażenie prędkości).
  float zanik = map(energia, 0, 1, 255, 35);
  fill(0, zanik);
  noStroke();
  rect(0, 0, width, height);

  // Prędkość lotu w głąb: od zera (cisza) do dużej (nadprzestrzeń).
  float predkosc = map(energia, 0, 1, 0.0, 32);
  // Siła drżenia punktów — rośnie z energią.
  float drzenie = energia * energia * 3.5;

  translate(width/2, height/2);   // środek ekranu = punkt ucieczki

  for (int i = 0; i < ILE; i++) {
    gwiazdy[i].aktualizuj(predkosc);
    gwiazdy[i].rysuj(energia, drzenie);
  }
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

// ---- Jedna gwiazda lecąca w głąb ----
class Gwiazda {
  float x, y, z;    // położenie w przestrzeni 3D
  float pz;         // poprzednie z (do rysowania smugi)
  float barwa;      // własny odcień gwiazdy (0-360)

  Gwiazda() {
    reset();
    z = random(width);        // rozrzuć w głąb na starcie
    pz = z;
    barwa = random(360);
  }

  void reset() {
    x = random(-width, width);
    y = random(-height, height);
    z = random(width);
    pz = z;
  }

  void aktualizuj(float predkosc) {
    z -= predkosc;            // lecimy ku widzowi
    if (z < 1) {              // przeleciała obok -> wraca w głąb
      x = random(-width, width);
      y = random(-height, height);
      z = width;
      pz = z;
    }
  }

  void rysuj(float energia, float drzenie) {
    // Rzut perspektywiczny: im bliżej (małe z), tym dalej od środka.
    float sx = (x / z) * width/2;
    float sy = (y / z) * width/2;

    // Drżenie — delikatny dygot, mocniejszy przy dużej energii.
    sx += random(-drzenie, drzenie);
    sy += random(-drzenie, drzenie);

    // Rozmiar rośnie, gdy gwiazda się zbliża.
    float r = map(z, 0, width, 5, 0);

    // Kolor w trybie HSB: w ciszy biel (nasycenie 0), przy pędzie żywy odcień.
    colorMode(HSB, 360, 100, 100);
    float nasycenie = energia * 100;        // 0 = biała, 100 = pełny kolor
    fill(barwa, nasycenie, 100);
    noStroke();
    ellipse(sx, sy, r, r);

    // Smuga: od poprzedniej do obecnej pozycji — widoczna dopiero przy pędzie.
    float px = (x / pz) * width/2;
    float py = (y / pz) * width/2;
    pz = z;
    stroke(barwa, nasycenie, 100, 70 * energia);
    strokeWeight(r * 0.6);
    line(px, py, sx, sy);
    colorMode(RGB, 255);
  }
}
