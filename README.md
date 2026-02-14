# SweetWatch Garmin

Aplikacje Garmin Connect IQ do monitorowania glukozy z SweetWatch.

## Projekty

### sweetwatch-widget
Widget wyświetlający glukozę na głównym ekranie zegarka.
- Pokazuje: czas, glukozę, trend, datę
- Pobiera dane co 60 sekund

### sweetwatch-datafield
Pole danych do aktywności sportowych (bieganie, rower, itp.)
- Pokazuje: glukozę + trend
- Background Service pobiera dane co 60 sekund

## Wymagania

- Garmin Connect IQ SDK 3.1.0+
- Klucz deweloperski (`developer_key.der`)

## Budowanie

```bash
# Widget
monkeyc -f sweetwatch-widget/monkey.jungle -o sweetwatch-widget.prg -d fenix6pro -y /path/to/developer_key.der -r

# Data Field
monkeyc -f sweetwatch-datafield/monkey.jungle -o sweetwatch-datafield.prg -d fenix6pro -y /path/to/developer_key.der -r
```

## Instalacja na zegarku

### Metoda 1: USB (najszybsza)

1. Podłącz zegarek przez USB
2. Zegarek zamontuje się jako dysk (np. `/media/GARMIN` lub `D:\`)
3. Skopiuj pliki `.prg` do odpowiednich folderów:
   ```
   GARMIN/Apps/sweetwatch-widget.prg
   GARMIN/Apps/sweetwatch-datafield.prg
   ```
4. Bezpiecznie odmontuj zegarek
5. Zegarek automatycznie załaduje aplikacje

### Metoda 2: Garmin Express

1. Zbuduj plik `.iq` (package):
   ```bash
   monkeyc -f monkey.jungle -o sweetwatch-widget.iq -e -y /path/to/developer_key.der
   ```
2. Otwórz Garmin Express
3. Wybierz zegarek > IQ Apps > Sideload
4. Wybierz plik `.iq`

## Konfiguracja

Aplikacje domyślnie łączą się z:
```
https://test.sweetwatch.app/api/glucose/current
```

Aby zmienić URL, edytuj pliki:
- `sweetwatch-widget/source/SweetWatchView.mc`
- `sweetwatch-datafield/source/BackgroundServiceDelegate.mc`

## Używanie

### Widget
1. Na zegarku: przytrzymaj UP > Widgets
2. Dodaj "SweetWatch" do listy widgetów
3. Przesuń w lewo/prawo na tarczy żeby zobaczyć widget

### Data Field
1. Na zegarku: przytrzymaj UP > Activities > [wybierz aktywność] > Settings > Data Screens
2. Dodaj ekran lub edytuj istniejący
3. Wybierz pole > Connect IQ > SweetWatch DF

## Obsługiwane urządzenia

Obecnie: Fenix 6 Pro

Aby dodać inne urządzenia, edytuj `<iq:products>` w `manifest.xml`.
