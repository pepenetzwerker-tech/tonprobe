# Tonprobe

Intonationsmessung für Gesangsübung. Eine einzelne HTML-Datei, kein Server, keine Abhängigkeiten.

Live: https://pepenetzwerker-tech.github.io/tonprobe/

## Drei Betriebsarten

**Stimmgerät** — läuft immer mit. Notenname, Abweichung in Cent, Zeiger, und der Verlauf der letzten
sieben Sekunden mit Toleranzband bei ±10 Cent.

**Übung** — Referenzton 1,4 s, Pause (2–5 s wählbar), 3,2 s singen, Prüfton. Halbtonweise von Startton
bis Endton. Protokolliert pro Ton Abweichung, Streuung, Zeit bis stabil, Dauer und Pegel.

Figuren, mit den gemessenen Kursfiguren als Vorlage:

| Auswahl | Stufen | Beispiel ab A2 |
|---|---|---|
| Einzelton | 1 | A2 |
| Ganzton · 1–2–1 · wie das i | 0, 2, 0 | A2 H2 A2 |
| kleine Terz · 1–3–1 | 0, 3, 0 | A2 C3 A2 |
| Quinte · 1–5–1 · wie das u | 0, 7, 0 | A2 E3 A2 |
| Ganzton abwärts · 3–2–1 · wie das a | 4, 2, 0 | C♯3 H2 A2 |
| Terz-Lauf · 1–2–3–2–1 | 0, 2, 4, 2, 0 | A2 H2 C♯3 H2 A2 |

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

## Oktavprüfung

Tonhöhenverfolgung kann eine Oktave zu hoch greifen, wenn der Grundton schwach ist oder die
Stimme knarrt. Bei einem echten Grundton liegt auch bei der doppelten Periode ein Minimum der
Differenzfunktion, dessen Vorhandensein ist also kein Kriterium — verglichen wird die Güte.
Erklärt die doppelte Periode den Rahmen deutlich besser (Abstand 0,03 und selbst unter 0,20),
wird die Tonhöhe halbiert.

Der Abstand hält echte hohe Töne unangetastet, bei denen beide Minima gleich tief sind. Geprüft
gegen volle und dünne Klänge von 110 bis 523 Hz, gegen fehlende Grundtöne und gegen
Periodenverdopplung: die Korrektur greift nur im Grenzfall, in dem die rohe Erkennung tatsächlich
falsch liegt.

Betrifft die Korrektur mehr als 15 % der Rahmen eines Tons, steht in der Spalte Ton die Marke
`8ᵛᵃ`. Die Zeile ist dann zwar korrigiert, aber mit Vorbehalt zu lesen.

## Pegel

Beide Betriebsarten protokollieren den Pegel in dBFS, also bezogen auf die Vollaussteuerung des
Mikrofons. Null wäre Übersteuerung, −10 ist laut, −30 ist leise.

Der Wert ist **nur innerhalb eines Geräts und bei gleichem Abstand zum Mikrofon vergleichbar.**
Telefon und Rechner haben unterschiedliche Empfindlichkeit und Vorverstärkung, und ein Schritt
näher an das Mikrofon ändert den Pegel stärker als lauteres Singen. Für den Vergleich zweier
Sitzungen also: dasselbe Gerät, derselbe Abstand.

Wozu der Wert gut ist: Tonhöhe und Lautstärke hängen zusammen. Mehr Atemdruck hebt den Grundton
um einige Cent pro Dezibel, und die Volldecke braucht Druck, um überhaupt zu tragen. Eine leise
Sitzung ist deshalb nicht dieselbe Messung wie eine laute, auch wenn die Cent-Werte gleich aussehen.

## Schritt

Die Mitschrift zeigt pro Ton den Abstand zum vorigen in Halbtönen, und benennt ihn, wenn er
näher als 25 Cent an einem glatten Intervall liegt — Halbton, Ganzton, kleine und große Terz,
Quarte, Quinte, Oktave.

Damit sind Figuren ohne Kopfrechnen lesbar. Die i-Figur aus dem Kurs liest sich als
`+2.00 Ganzton` / `−2.00 Ganzton`.

Wozu das gut ist: ohne Vorgabe ist die absolute Tonhöhe beliebig, der Abstand nicht. Die Spalte
Abweichung misst dann nur, ob der Ton zufällig auf einer Klaviertaste gelandet ist; die Spalte
Schritt misst, ob das gemeinte Intervall herauskam.

## Belegte Referenz

Die i-Figur ist ein Ganzton hinauf und zurück, nicht ein Halbton. Gemessen aus einer Kursaufnahme:
die Kursleiterin spielt bei 81,7 s G4 (393,09 Hz), A4 (441,14 Hz), G4 (393,18 Hz) — Schritte von
+1,99 und −1,99 Halbtönen.

Klavier und Stimme lassen sich dabei trennen: ein Klavierton steht auf 1 bis 6 Cent still und wird
leiser, eine Stimme streut um 13 Cent im Median. Gegenprobe über 25 stabile Klaviertöne: alle
tragen dieselbe Verstimmung von +2,9 Cent gegen den Kammerton, das Instrument ist also auf
A = 440,7 Hz gestimmt.

Die u-Figur ist eine Quinte hinauf und zurück. Gemessen aus der u-Aufnahme vom 16.9.: bei 90,1 s
spielt die Kursleiterin G3 (196,74 Hz), D4 (293,39 Hz), G3 (196,56 Hz) — Schritte von +6,92 und
−6,93 Halbtönen; bei 149,4 s C3 (130,96 Hz) auf G3 (196,45 Hz), also +7,02. Alle Töne mit
Streuungen unter 3 Cent, das Klavier dieser Aufnahme steht auf A = 441,0 Hz.

Das deckt sich mit den gesungenen Figurspannen: beim i 1,8 bis 3,7 Halbtöne, beim u 6,6 bis 8,0.

Die a-Figur ist nicht eindeutig. In der a-Aufnahme vom 16.9. (50 Klaviertöne, Streuung 3,9 Cent im
Median, A = 440,4 Hz) finden sich mehrere Bewegungen: bei 70,7 s F♯3 (184,64 Hz) auf E3 (165,07 Hz)
auf D3 (146,95 Hz), also zwei Ganztöne abwärts; bei 260,1 s eine große Terz abwärts und zurück; bei
220,0 s A3 auf C4 auf F4, kleine Terz plus Quarte. Das deckt die gesungenen Figurspannen von 4,1 bis
8,8 Halbtönen. Aufgenommen in die Auswahl wurde die absteigende Ganztonfolge, weil alle anderen
Figuren aufwärts gehen.
