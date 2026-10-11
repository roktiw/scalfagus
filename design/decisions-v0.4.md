# Scalfagus — zatwierdzone decyzje projektowe v0.4

Status: **cztery decyzje zatwierdzone**. Szczegóły oznaczone `TBD` i `proposed` są do dalszego balansu.

## DEC-001 — Energy jako trzeci surowiec magazynowany

Matter (T1), Volatiles (T2), Energy (T3) to trzy transportowalne i wydawane zasoby gospodarcze. Energy można produkować generatorami albo pozyskiwać w punktach wydobywczych, umieszczać w magazynach i jednostkach cargo, przeładowywać oraz wydawać na technologie, moduły, zdolności i transformacje. **Nie ma obowiązkowej sieci energetycznej.** Lawa to opcjonalne źródło geotermalne zależne od świata, nie czwarty zasób. Przeliczanie zasobów zachodzi wyłącznie według jawnych receptur. Pierwsze pozyskanie podstawowych zasobów i uruchomienie energii nie może powodować softlocka.

**Do określenia:** ilość Energy na cykl produkcji, pojemność kontenerów, koszty transformacji, sposób utraty ładunku, ewentualne zużycie ciągłe i wydajność dla trzech ras.

## DEC-002 — Tylko specjalistyczne jednostki rozstawiają budynki

Reguła: zwykła jednostka MIN/MID/MAX **nie** może stać się dowolną strukturą. Szablon jednostki musi mieć jawną cechę `deployable`, a rozstawienie wymaga właściwego terenu, miejsca, czasu i zasobów. Jest przerywalne.

Przykłady robocze: Blergian *Colony Seed* zakorzenia się trwale, Manusian *Modular Constructor* kotwiczy moduły (potencjalnie demontowalne), Aetherian *Resonance Anchor* manifestuje strukturę za Energy (potencjalnie kosztownie odwracalną). Nazwy i mechaniki demontażu nie są jeszcze zatwierdzone.

**Do określenia:** koszt i czas, los konstruktora, HP podczas rozstawiania, przejmowanie, odzysk, rozstawianie na poruszających się asteroidach.

## DEC-003 — Średnia automatyzacja logistyki

Gra pozostaje klasycznym RTS. Gracz wskazuje złoża, trasę, cel magazynowania, miejsce ekspansji i operacje dokowania. Jednostki automatycznie powtarzają wydobycie, wracają z pełnym ładunkiem do wskazanego odbiorcy i przekazują cargo do zgodnego MIN/MID/MAX według istniejących zasad hierarchii. Bez samodzielnej ekspansji, strategicznego wybierania mapy lub automatycznego stawiania fabryk. Energy jest obsługiwane jako cargo.

**Do określenia:** zasięgi, przepustowość, kolejki, pełne magazyny, kolizje, utrata odbiorcy, przerwanie trasy i zachowanie przy dryfie asteroid.

## DEC-004 — Standardowy mecz 1v1: 25–40 minut

Czas 25–40 min to **cel projektowy**, nie limit meczu. Orientacyjnie early 0–8 min (Matter, zwiad), mid 8–22 (Volatiles, wyspy, MID), late 22–40 (Energy, asteroidy, MAX). Fazy są określane rozwojem technologicznym, nie zegarem. Dominacja ekonomiczna Blergians early, Manusians mid i Aetherians late to zamierzone **okna przewagi**, nie przewidywane procenty wygranych. Bilansować trzeba wszystkie matchupy i mapy, a nie tylko jedną łączną krzywą.

**Do określenia:** warunki zwycięstwa, limity populacji, początkowe zasoby, tempo produkcji, comeback i rozwiązania impasu.

## Kryteria akceptacji v0.4

1. Energy można w symulatorze wyprodukować, magazynować, przetransportować i zużyć bez obowiązkowej sieci.
2. Rozstawienie budynku przez jednostkę bez tagu `deployable` jest odrzucone; wyspecjalizowana jednostka przechodzi walidację miejsca i kosztu.
3. MIN przekazuje cargo do uprawnionego MID/MAX bez ręcznego polecenia przeładunku po wcześniejszym skonfigurowaniu trasy.
4. Model meczu raportuje długość partii i moment przejścia technologicznego, nie wymuszając zakończenia po 40 min.
5. Dane historyczne `Crystals/Gas/Resin` z `economy.yaml`, `resources.yaml`, `units.yaml` są migrowane w osobnej zmianie; **nie są zgodne** z aktualnym Matter/Volatiles/Energy bez przeliczenia.

Powiązane: [resource-balance.yaml](resource-balance.yaml), [factions.yaml](factions.yaml), [units.yaml](units.yaml).
