# Warsztat Arduino — UAM

Kod do wszystkich ćwiczeń z warsztatu. Płytka: **Maker Uno** (zgodna z Arduino Uno).

## Jak pobrać cały kod

Zielony przycisk **`Code`** u góry → **`Download ZIP`** → rozpakuj. Masz wszystko offline.
Pojedynczy szkic otworzysz podwójnym kliknięciem w pliku `.ino`.

## Co zainstalować

1. **Arduino IDE** — https://www.arduino.cc/en/software
2. **Biblioteki** (tylko do ćwiczenia 3, DHT11) — w Arduino IDE: `Narzędzia → Zarządzaj bibliotekami`, wyszukaj i zainstaluj:
   - `DHT sensor library` (Adafruit)
   - `Adafruit Unified Sensor`
3. **Processing** (tylko do ćwiczenia 5) — https://processing.org/download

## Do wydrukowania

**`schematy-do-druku.pdf`** — gotowy handout dla uczestnika (A4): schemat podłączenia, tabela pinów i najczęstsze pułapki dla każdego ćwiczenia + ściąga z kodami kolorów oporników i biegunowością diody.

## Ćwiczenia

| Folder | Czujnik / temat | Co robi |
|---|---|---|
| `01_fotorezystor` | fotorezystor | odczyt jasności do Monitora Szeregowego (`analogRead`, 0–1023) |
| `02_latarnia` | fotorezystor + dioda | dioda zapala się po ciemku (pierwszy `if … else`, własny próg) |
| `03_dht11` | DHT11 | temperatura i wilgotność + alarm (dioda, buzzer) |
| `04_hc-sr04` | HC-SR04 (ultradźwięki) | pomiar odległości + alarm parkowania (rytm, ton, dioda) |
| `05_processing` | HC-SR04 → Processing | czujnik steruje animacją na ekranie komputera |

Foldery `03` i `04` mają kilka wersji w kolejności od najprostszej — przechodzimy je po kolei:

- **03_dht11:** `DHT11a` (sam odczyt) → `DHT11bdioda` → `DHT11c_dioda2` → `DHT11d_buzzer` (pełny alarm)
- **04_hc-sr04:** `HCR_1_basic` (sam pomiar) → `HCR_2_buzzer` (buzzer wbudowany) → `HCR_3_buzzer_ext_dioda` (buzzer zewnętrzny + dioda) → `HCR_4_ext_buzzer_high` (im bliżej, tym wyższy ton)

Schematy połączeń są w podfolderach `schematy/`.

## Podłączenia (ściąga)

| Element | Pin |
|---|---|
| Fotorezystor (dzielnik napięcia) | `A0` |
| Dioda (latarnia / alarm) | `6` |
| DHT11 (dane) | `4` |
| HC-SR04 Trig / Echo | `9` / `10` |
| Buzzer wbudowany (Maker Uno) | `8` |
| Buzzer zewnętrzny (moduł) | `7` |

## Najczęstsze pułapki

- **Krzaczki w Monitorze Szeregowym** → ustaw prędkość na **9600 baud** (prawy dolny róg), musi się zgadzać z `Serial.begin(9600)`.
- **Buzzer wbudowany milczy** → Maker Uno ma fizyczny suwak wyciszania buzzera; ustaw go na **ON**.
- **HC-SR04 pokazuje śmieci / zera** → sprawdź, czy `Trig` i `Echo` nie są zamienione.
- **Dioda nie świeci** → sprawdź biegunowość: dłuższa nóżka = plus (anoda).
- **„Plik musi być w folderze"** → każdy `.ino` leży w folderze o tej samej nazwie; otwieraj plik `.ino`, nie przenoś go samego.
