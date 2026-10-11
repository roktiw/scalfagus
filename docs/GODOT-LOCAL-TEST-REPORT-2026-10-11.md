# Raport lokalnego testu gry Godot — 2026-10-11

## Wykonane

Usunięto z lokalnego checkouta pozostałości desktopowego launchera Tauri. Aktualnym runtime’em jest wyłącznie Godot 4.7.2 Standard. Repo nie zawiera już śledzonego `apps/desktop/`; lokalne stare artefakty zostały odłożone poza repo do `/tmp/scalfagus-tauri-removed-20261011-214511`.

## Wynik testu

Uruchomiono:

```sh
bash scripts/check.sh
```

Wynik: `SCALFAGUS_GODOT_CHECK_PASS`.

Potwierdzone automatycznie:

- import projektu Godot 4.7.2,
- smoke test jednego świata, jednego bohatera i trzech widoków,
- stabilność Hero ID/HP przy przełączaniu trybów,
- mapowanie pięciu źródeł sprite’a do ośmiu sektorów,
- test menu: `SCALFAGUS_MENU_PASS`,
- manifest assetów i zgodność regionów atlasów,
- walidacja 27 ikon i 3 atlasów.

Gra została uruchomiona lokalnie z aktualnego checkouta przez `scripts/game.sh`. Godot zgłosił standardowe wycieki `ObjectDB/RID` przy zamknięciu headless smoke testu; test kończy się poprawnie, ale te ostrzeżenia wymagają późniejszego wyjaśnienia.

## Działa w obecnej wersji

- natywne okno Godot,
- menu główne i przejście do sceny gry,
- trzy kamery: RTS/Overlord, Direct/TPP i FPS/Possession,
- jeden wspólny bohater i świat 3D,
- ruch bohatera w Direct/FPS,
- obrót i zoom kamery,
- pięciokierunkowe sprite’y i renderowanie sektorów,
- teren, kolizje, drzewa, skały i placeholdery sceny,
- testy headless oraz walidacja assetów.

## Nie działa albo nie jest jeszcze zaimplementowane

- pełna gra RTS: zaznaczanie jednostek, rozkazy prawym przyciskiem, grupy i kamera przesuwana WASD,
- ekonomia, wydobycie, transport i produkcja,
- armie, bot przeciwnika, fog of war i minimapa,
- pełna walka, broń, obrażenia i zwycięstwo/porażka,
- kampania, zapis gry i multiplayer,
- finalna jakość animacji oraz wszystkich kierunków sprite’ów,
- eksport Windows/Linux/Web i testy na tych platformach,
- dystrybucyjne podpisywanie/notarization Apple.

## Następny agent powinien

Najpierw zbudować mały pionowy fragment RTS na obecnym świecie: wybór bohatera, rozkaz ruchu, jeden cel, obrażenia, śmierć i warunek zwycięstwa. Zachować istniejące smoke testy i nie przywracać Tauri bez osobnej decyzji architektonicznej.

## Ostatnia sesja Godot Editor

Godot Editor został uruchomiony z `apps/game` na macOS Apple Silicon. Edytor poprawnie otworzył `menu.tscn` i projekt w wersji `4.7.2.stable`. Ponowne uruchomienie `bash scripts/check.sh` potwierdziło `SCALFAGUS_GODOT_CHECK_PASS`, w tym `SCALFAGUS_SMOKE_PASS`, `SCALFAGUS_MENU_PASS` i `ASSET_MANIFEST_PASS`.

Wniosek: środowisko Godot i obecny prototyp są uruchamialne lokalnie oraz mają działającą walidację headless. Sesja nie potwierdza jeszcze kompletnej pętli RTS ani jakości eksportów platformowych; te elementy pozostają zadaniami implementacyjnymi.
