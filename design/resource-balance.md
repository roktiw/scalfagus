# Scalfagus — balans ekonomii ras (v0.3)

**Status:** propozycja do playtestów, nie zatwierdzony balans.  
**Powiązane:** [resource-balance.yaml](resource-balance.yaml), [resources.yaml](resources.yaml), [economy.yaml](economy.yaml), [units.yaml](units.yaml), [factions.yaml](factions.yaml).

## Dwie niezależne osie tierów

- **Surowce:** T1 **Matter** (materia konstrukcyjna), T2 **Volatiles** (substancje lotne, chemia i paliwa), T3 **Energy** (produkcja, przesył, magazynowanie i zużycie energii).
- **Geografia:** T1 **Mainland** (blisko, łatwo), T2 **Islands** (oddzielone, średni dystans), T3 **Asteroids** (odległe, powoli dryfujące, trudne logistycznie).

Tier surowca **nie** określa miejsca jego występowania: każdy może występować w każdym regionie. Lawa to **lokalne źródło ciepła geotermalnego** i ewentualnie materii po schłodzeniu; nie każda planeta ma dostępną lawę.

## Macierz 3 × 3: specjalizacja

| Rasa | T1 Matter | T2 Volatiles | T3 Energy |
|---|---|---|---|
| **Blergians** | Bioasymilacja skał, metali i minerałów | Biochemia, metabolizm, mutageny | Bioenergia, regeneracja, nieodwracalne mutacje |
| **Manusians** | Górnictwo, hutnictwo, prefabrykacja i recykling | Rafinerie, separacja gazów, paliwa, wymienne zbiorniki | Generatory, reaktory, baterie, sieci i magazyny mobilne |
| **Aetherians** | Reorganizacja materii i wzrost kryształów | Separacja molekularna, synteza, kontrola faz | Rezonans, transfer i magazynowanie energii, medytacja, odwracalne ascensje |

Każda rasa pozyskuje, przetwarza, przechowuje, transportuje i wykorzystuje wszystkie trzy zasoby. Specjalizacja oznacza przewagę w **określonych operacjach**, a nie wyłączny dostęp.

## Cykliczna macierz efektywności (propozycja)

| Rasa | Matter | Volatiles | Energy |
|---|---:|---:|---:|
| Blergians | **1.30×** | 0.80× | 1.00× |
| Manusians | 1.00× | **1.30×** | 0.80× |
| Aetherians | 0.80× | 1.00× | **1.30×** |

Każdy wiersz i kolumna sumuje się do **3.10**, lecz **symetria sum nie gwarantuje balansu RTS**. Nie stosować tych wartości automatycznie jako globalnych mnożników. Należy osobno balansować **wydobycie, przetwarzanie, magazynowanie, transport, zużycie i recykling**.

## Fazy rozgrywki

| Faza | Matter | Volatiles | Energy | Potencjalna przewaga |
|---|---:|---:|---:|---|
| Early | 70% | 25% | 5% | Blergians |
| Mid | 35% | 45% | 20% | Manusians |
| Late | 15% | 30% | 55% | Aetherians |

Są to **przykładowe wagi zapotrzebowania**, a nie zasada wymuszająca zwycięzcę. Blergians mogą wygrywać w late dzięki taniej masowej specjalizacji; Manusians dzięki modułowej logistyce i adaptacji; Aetherians dzięki wysokiej sprawności energetycznej, ale płacą czasem i kosztami transformacji.

## Asymetria operacyjna

| Aspekt | Blergians | Manusians | Aetherians |
|---|---|---|---|
| Wydobycie | Organiczne ekstraktory | Mechaniczne kopalnie | Rezonansowe ekstraktory |
| Przetwarzanie | Metabolizm | Rafinerie i fabryki | Konwersja rezonansowa |
| Magazynowanie | Żywe zbiorniki | Kontenery i baterie | Matryce energetyczne |
| Transport | Organizmy wyspecjalizowane | Największa modularność | Transfer rezonansowy |
| Odzysk | Konsumpcja / regeneracja | Demontaż i odzysk części | Dekonstrukcja |
| Adaptacja jednostek | Jednokierunkowe mutacje | Szybki hot-swap modułów | Odwracalna, kosztowna medytacja |

## Metryki do playtestów

1. Dostarczone zasoby/minutę, z uwzględnieniem odległości, dokowania, ruchu planetoid i strat.
2. Koszt efektywny jednostki i modułu, łącznie z czasem transformacji.
3. Czas osiągnięcia progów technologicznych i zwrot z inwestycji.
4. Kontrola mapy, odporność na ataki logistyczne i możliwości powrotu do gry.
5. Win rate ras i matchupów na różnych mapach i długościach partii.

## Migracja wcześniejszych YAML-i

Istniejące `economy.yaml`, `resources.yaml` i `units.yaml` nadal zawierają **legacy Crystals / Gas / Resin** i historyczne koszty liczbowe. **Nie traktować ich jako aktualnej taksonomii surowców.** Ten dokument oraz `resource-balance.yaml` opisują nowszą koncepcję **Matter / Volatiles / Energy**. Osobny etap powinien przepisać koszty jednostek, technologie i czasy ekstrakcji oraz ustalić, czy Energy jest magazynowanym zasobem, przepływem sieciowym czy modelem hybrydowym. Bez tego nie da się bezpiecznie przeliczyć starego balansu.
