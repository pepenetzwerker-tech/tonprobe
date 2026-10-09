# Tonprobe

Intonationsmessung für Gesangsübung. Eine einzelne HTML-Datei, kein Server, keine Abhängigkeiten.

Live: https://pepenetzwerker-tech.github.io/tonprobe/

## Drei Betriebsarten

**Stimmgerät** — läuft immer mit. Notenname, Abweichung in Cent, Zeiger, und der Verlauf der letzten
sieben Sekunden mit Toleranzband bei ±10 Cent.

**Übung** — Referenzton 1,4 s, Pause (2–5 s wählbar), 3,2 s singen, Prüfton. Halbtonweise von Startton
bis Endton. Figuren: Einzelton, Ganzton 1–2–1, Terz 1–2–3–2–1. Protokolliert pro Ton Abweichung,
Streuung, Zeit bis stabil und Dauer.

**Mitschreiben** — kein Ziel vorgegeben. Die Seite findet die Töne selbst und protokolliert jeden:
Notenname, Abweichung zum nächstliegenden Halbton, Streuung, Dauer.

## Messverfahren

Tonhöhe über eine YIN-artige Differenzfunktion mit kumulativer Mittelwertnormierung und
Parabel-Interpolation, Fenster 4096 Samples, Suchbereich 70–900 Hz.

Ein Ton gilt als laufend, solange die Tonhöhe im Band von 45 Cent um ihren eigenen Mittelwert bleibt.
Verlässt sie das Band, beginnt der nächste Ton. Eine Lücke ohne Klang beendet ihn erst nach 300 ms —
setzt die Stimme vorher innerhalb des Bandes wieder ein, ist es derselbe Ton. Solche Aussetzer werden
aus der Dauer herausgerechnet und in der Spalte Dauer als `·n` vermerkt. Mindestdauer 0,3 s.

„Zeit bis stabil" ist der Beginn des ersten 300-ms-Fensters, das vollständig innerhalb ±25 Cent um den
Median liegt. „Sofort getroffen" heißt: unter 500 ms stabil und Median unter 25 Cent Abweichung.

## Grenzen

- Mikrofonzugriff braucht HTTPS oder localhost.
- Unter etwa 90 Hz passen nur wenige Schwingungen ins Analysefenster, die Werte werden ungenauer.
- Beim Gleiten entsteht keine brauchbare Zeile: schnell fällt unter die Mindestdauer, langsam zerfällt in Stufen.
- Ohne Kopfhörer hört das Mikrofon den Referenzton mit.

## Wenn das Mikrofon am Telefon nicht geht

Die Seite benennt die Ursache selbst. `NotAllowedError` heißt blockiert, und das sitzt an zwei
getrennten Stellen: in Android unter Einstellungen → Apps → Chrome → Berechtigungen → Mikrofon,
und in Chrome selbst beim Schlosssymbol in der Adressleiste unter Berechtigungen. Ein einmal
abgelehnter Zugriff wird für diese Adresse gemerkt und nicht neu gefragt.
