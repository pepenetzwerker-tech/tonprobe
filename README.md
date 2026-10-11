# Tonprobe

Intonationsmessung für Gesangsübung. Eine einzelne HTML-Datei, kein Server, keine Abhängigkeiten.

Live: https://pepenetzwerker-tech.github.io/tonprobe/

Die bisherigen Messwerte stehen in [PROTOKOLL.md](PROTOKOLL.md).

## Drei Betriebsarten

**Stimmgerät** — läuft immer mit. Notenname, Abweichung in Cent, Zeiger, und der Verlauf der letzten
sieben Sekunden mit Toleranzband bei ±10 Cent.

**Übung** — Referenzton 1,4 s, Pause (2–5 s wählbar), 3,2 s singen, Prüfton. Halbtonweise von Startton
bis Endton, und das Ganze so oft, wie unter *Durchgänge* eingestellt ist (1 bis 20). Startton und
Endton auf denselben Ton zu setzen und zehn Durchgänge zu wählen gibt zehn Versuche auf genau
diesem einen Ton; die Zusammenfassung rechnet dann über alle zehn. Dieselbe Einstellung gilt für
*Figur durchsingen*. Protokolliert pro Ton Abweichung, Streuung, Zeit bis stabil, Dauer und Pegel.

Figuren, mit den gemessenen Kursfiguren als Vorlage:

| Auswahl | Stufen | Beispiel ab A2 |
|---|---|---|
| Einzelton | 1 | A2 |
| Ganzton · 1–2–1 · wie das i | 0, 2, 0 | A2 H2 A2 |
| kleine Terz · 1–3–1 | 0, 3, 0 | A2 C3 A2 |
| Quinte · 1–5–1 · wie das u | 0, 7, 0 | A2 E3 A2 |
| Ganzton abwärts · 3–2–1 | 4, 2, 0 | C♯3 H2 A2 |
| Terz-Lauf · 1–2–3–2–1 | 0, 2, 4, 2, 0 | A2 H2 C♯3 H2 A2 |
| Bogen · 1–2–3–4–5–4–3 · wie das a | 0, 2, 4, 5, 7, 5, 4 | A2 H2 C♯3 D3 E3 D3 C♯3 |

**Figur durchsingen** — die Figur wird vorgespielt, dann als zusammenhängende Linie gesungen und
gegen die Vorgabe abgeglichen. Siehe unten.

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

Die a-Figur steht hier **nach mündlicher Beschreibung, nicht nach Messung**: sieben Töne, die ersten
zwei auf i als Anlauf, dann aufwärts bis zum höchsten Ton an fünfter Stelle, die letzten zwei
abfallend.

Der Messversuch ist gescheitert, und zwar an der Segmentierung. Von fünf gesungenen Siebener-Gruppen
passen zwei gut auf einen Bogen mit Gipfel am vierten Ton (29 und 34 Cent Fehler), zwei steigen über
alle sieben Töne durch und haben keinen Abstieg — dort hat die Gruppierung mitten in der Figur
geschnitten. Über alle fünf liegt der Fehler bei 112 Cent. Bei sieben Tönen in einer fließenden Linie
findet die Plateauerkennung keine sieben Plateaus; sie verschmilzt manche und zerteilt andere. Beim i
und u ging es, weil dort drei Töne mit Pausen dazwischen stehen.

Die absteigende Ganztonfolge bleibt in der Auswahl, trägt aber keinen Vokalnamen mehr: F♯3–E3–D3 aus
der Aufnahme ist wahrscheinlich der Schluss der langen Figur, nicht die ganze.

## Figur durchsingen

Der Übungsmodus misst Ton für Ton mit Referenzton und Pause dazwischen — genau, aber nicht
musikalisch. Dieser Modus spielt die Figur als Ganzes vor und misst eine durchgesungene Linie
gegen dieselbe Vorgabe.

**Vorgespielt** wählt, was vor dem Singen zu hören ist. *Nur der Grundton* gibt die Lage und sonst
nichts — die Intervalle müssen aus der eigenen Vorstellung kommen. *Die ganze Figur* spielt sie
vorher durch, dann ist es Nachsingen. Die erste Einstellung ist die schwerere und die, auf die es
hinausläuft.

**Verfahren.** Jeder Sollton bekommt einen zusammenhängenden Abschnitt der Aufnahme von mindestens
150 ms (5 Messrahmen). Welche Abschnitte, entscheidet eine dynamische Zeitverzerrung über alle
Gesamtversätze von −350 bis +350 Cent in 10-Cent-Schritten; gewählt wird der Versatz mit den
geringsten Gesamtkosten. Die Zeitachse darf sich dabei beliebig dehnen — gemessen wird die
Tonhöhe, nicht das Tempo. Ein freies Tempo ist deshalb kein Problem, sondern wird selbst zur
Messgröße: die Spalte Dauer zeigt, wo gedehnt und wo gedrängt wurde.

Dass die Reihenfolge der Töne bekannt ist, macht das Verfahren der Transkription überlegen: es muss
nicht geraten werden, welcher Notenwert gemeint war, nur wo der nächste Sollton liegt. Es braucht
auch keine saubere Trennung in Plateaus — der Grund, warum die siebentönige a-Figur sich nicht
transkribieren ließ.

**Spalten.** Abweichung ist der Abstand zur Vorgabe. Intervall ist derselbe Wert nach Abzug des
Gesamtversatzes und misst damit die Figur statt der Lage: wer die ganze Figur 30 Cent zu tief singt,
hat Abweichung 30 und Intervall 0. Anlauf vergleicht den Beginn eines Tons mit seiner Mitte —
negativ heißt von unten hineingerutscht.

**Güteprüfung.** Der Abgleich liefert immer ein Ergebnis, auch wenn die Aufnahme der Figur nicht
folgt. Drei Prüfungen entscheiden, ob die Einzelwerte überhaupt etwas bedeuten:

- quadratisches Mittel der Intervallabweichungen unter 50 Cent (nicht der Median — der versteckt einzelne grobe Fehler)
- höchstens ein Sollton, der nur die Mindestdauer bekommen hat (häufen die sich, wurde die Zuordnung erzwungen)
- kein Abschnitt mit über 70 Cent Streuung (ein solcher Abschnitt ist kein gehaltener Ton, sondern ein Sammelbecken mehrerer Tonhöhen)
- genau so viele gesungene Töne wie Sollnoten, und bei gleicher Zahl eine Schrittfolge, die höchstens 60 Cent von der vorgegebenen abweicht

Die letzte Prüfung ist die wichtigste, weil sie nicht vom Abgleich abhängt. Der Abgleich kann wenige
lange Töne in mehrere Sollnoten zerschneiden und so passende Mediane erzeugen — dann sehen Intervall
und Restfehler gut aus, obwohl die Figur gar nicht gesungen wurde. Die unabhängige Segmentierung ist
der Zeuge dagegen. Ein Beispiel aus dem Gebrauch: drei Töne mit den Schritten −0,53 / +1,43 gegen
eine Vorgabe von +2,00 / −2,00 wurden mit einem Intervallfehler von 8 Cent als *folgt* gewertet.
Eine Toleranz von einem Ton Unterschied bei der Tonzahl ist dabei keine Hilfe, sondern hebelt die
Formprüfung aus — gerade der Fall, für den sie gebaut ist, liefe dann ungeprüft durch.

Fällt eine davon durch, erscheinen die Einzelwerte trotzdem, aber gedämpft und mit der Warnung,
dass die Zuordnung unsicher ist — dazu die gesungenen Schritte neben den vorgegebenen. Einzelne
Zeilen tragen Marken: `!` heißt auf die Mindestdauer gezwungen, `~` heißt in sich zu unruhig für
einen gehaltenen Ton. Zahlen zu verbergen, weil sie unsicher sind, nimmt die Möglichkeit, den
Fehler selbst zu sehen. Geprüft gegen: korrekt gesungen, durchgehend 30 Cent zu tief, ein Ton 70 Cent zu
hoch, Tempo von 0,3 bis 1,8 Sekunden je Ton, halbierte Intervalle, anderthalbfache Intervalle,
Figur verkehrt herum, und eine echte Aufnahme mit acht Tönen gegen sieben Sollnoten. Alle acht
werden richtig eingeordnet.

## Kopfhörer

Am Telefon leiten Android und iOS die Ausgabe oft auf den Telefonhörer um, sobald eine Seite das
Mikrofon offen hat. Der Referenzton ist dann da, aber nur am Ohr hörbar. Kopfhörer beheben das und
verhindern zugleich, dass das Mikrofon den Referenzton mithört und die Messung verfälscht.

## Verlauf der Durchgänge

Unter dem Abgleich steht eine Liste, die über die Durchgänge hinweg bestehen bleibt: je eine Zeile
pro durchgesungener Figur mit Grundton, Urteil, Gesamtversatz, Abweichung, Intervall, Restfehler und
den gesungenen Schritten in Halbtönen. Darunter die Mediane über alle Durchgänge und wie viele der
Figur gefolgt sind. Geleert wird sie nur auf Knopfdruck.

Die Spalte *gesungene Schritte* ist der eigentliche Fortschrittswert bei den Kursfiguren. Drei
Durchgänge der i-Figur ergaben etwa `+1.98 −1.94`, `+1.53 −1.90` und `+1.81 −1.94` — daran war
ablesbar, dass der Schritt abwärts auf 2 Cent konstant war und der Schritt aufwärts um 23 Cent
schwankte. Ohne stehende Liste wäre das nicht aufgefallen, weil jeder Durchgang den vorigen
überschrieb.

## Fassung

In der Kopfzeile steht Datum und Uhrzeit der geladenen Fassung. Mobile Browser halten eine
einmal geladene Seite hartnäckig im Zwischenspeicher; die Angabe sagt, ob die Änderung schon
angekommen ist. Gesetzt wird sie vor dem Hochladen mit `./stamp.sh`.

## Archiv

Jede fertige Zeile aus allen drei Betriebsarten wird mit Zeitstempel im Browser abgelegt und bleibt
dort, auch wenn die Listen oben geleert werden oder die Seite geschlossen wird. **Als CSV sichern**
lädt alles als Semikolon-Datei mit BOM herunter, die sich ohne Umweg in einer Tabellenkalkulation
öffnen lässt.

Der Browserspeicher ist nicht verlässlich — er kann beim Löschen der Websitedaten verschwinden und
ist auf dieses eine Gerät beschränkt. Die CSV-Datei ist deshalb die eigentliche Sicherung, nicht
der Speicher.

Spalten: zeit, modus, figur, nr, ton, soll, abw, schritt, streuung, dauer, pegel, stabil, versatz,
intervall, restfehler, urteil, marken. Je nach Betriebsart bleibt ein Teil davon leer.
