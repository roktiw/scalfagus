# Raport instalacji i builda Scalfagus — 2026-10-11

## Status

Lokalne środowisko macOS Apple Silicon zostało zainstalowane, prototyp Godot został opakowany w launcher Tauri, a aplikacja została zbudowana i uruchomiona z `~/Applications/Scalfagus.app`.

Potwierdzony build: `Scalfagus.app` (około 344 MiB), lokalnie podpisany ad-hoc i zweryfikowany przez `codesign --verify --deep --strict`.

## Co działa

- Node.js `24.21.0`, Rust `1.99.0`, Tauri `2.12.x` i Godot `4.7.2-stable Standard`.
- Oficjalny binarny Godot 4.7.2 został pobrany z manifestem SHA-512 i zweryfikowany przed użyciem.
- `npm --prefix apps/desktop run build` przechodzi: TypeScript i Vite.
- Tauri release build przechodzi i tworzy macOS `.app`.
- Launcher Tauri otwiera grę Godot jako osobny proces przez jawnie zdefiniowany zasób `Godot` + `game.pck`.
- Istniejący smoke test przechodzi: `SCALFAGUS_SMOKE_PASS: one world, three modes, 5->8 mapping, same hero, PNG import`.
- Prototyp Godot ma jeden świat, jednego bohatera i trzy tryby: Overlord/RTS, Direct/TPP oraz FPS/Possession.
- Działają podstawowe wejścia prototypu: F1/F2/F3, Tab, WASD, obrót kamery, zoom i Escape.
- Frontend launchera pokazuje status uruchomienia i podstawową instrukcję sterowania.
- Zależności npm i Cargo są zapisane w lockfile’ach.

## Czego brakuje

- To nadal techniczny vertical slice, a nie pełna gra RTS. Brakuje ekonomii, surowców, budowania, produkcji, armii, AI przeciwnika, fog of war, minimapy, zwycięstwa/porażki i kampanii.
- Nie ma pełnego systemu walki RTS ani trwałego modelu broni, obrażeń, celów i synchronizacji stanu między rozkazem RTS a trybem FPS.
- Obecne assety sprite są oznaczone w repo jako provisional/unverified; wymagają przeglądu wizualnego, prawdziwych animacji i spójnych kierunków.
- Smoke test potwierdza strukturę sceny i mapowanie sprite’ów, ale nie zastępuje ręcznej kontroli obrazu, kolizji i odczuć sterowania.
- Build jest lokalny dla macOS Apple Silicon. Nie ma zweryfikowanych paczek Windows/Linux, instalatorów ani pipeline CI.
- Aplikacja nie jest podpisana certyfikatem Apple Developer i nie jest notarized; dystrybucja poza lokalnym komputerem wymaga konfiguracji Apple Developer.
- Silnik Godot jest dołączany do aplikacji jako duży binarny sidecar, więc paczka ma około 344 MiB.
- Skrypt smoke testu zgłasza znane wycieki RID/ObjectDB przy zamykaniu headless; nie blokują obecnego testu, ale powinny zostać wyjaśnione przed wymaganiem czystej diagnostyki.
- Nie wykonano jeszcze testu długiego uruchomienia, testu dwóch instancji, testu przełączania trybów podczas ruchu ani testu wydajności na docelowych mapach.

## Zalecenia dla kolejnego agenta

1. Zachować granicę: Godot jest autorytatywnym runtime’em gry, Tauri tylko launcherem/studio.
2. Najpierw naprawić i udokumentować kontrakt stanu bohatera: ID, HP, pozycja, ekwipunek, cel i własność muszą pozostać identyczne przy RTS → TPP → FPS → RTS.
3. Dodać mały, testowalny pionowy fragment rozgrywki: zaznaczenie jednostki, rozkaz ruchu, jeden cel, obrażenia, śmierć i prosty warunek zwycięstwa.
4. Dodać deterministyczne testy komend i kolizji, w tym anulowanie rozkazu, przełączanie kamery w ruchu oraz strzał z FPS w ten sam obiekt widoczny w RTS.
5. Zastąpić provisional sprite’y zatwierdzonym zestawem artystycznym dopiero po screenshot QA z trzech kamer.
6. Dodać eksport gry bez launchera oraz test, że Tauri odmawia uruchomienia brakującego lub nieprzewidzianego sidecara.
7. Rozważyć zmniejszenie paczki przez osobny instalator Godot albo dedykowany eksport, ale dopiero po zachowaniu reprodukowalnego lokalnego builda.
8. Przed dystrybucją skonfigurować Apple signing/notarization i osobne artefakty dla Windows x64 oraz Linux x64.

## Powtarzalna weryfikacja

```sh
bash scripts/check.sh
bash scripts/build.sh
open /Users/wiktorswiatkowski/Applications/Scalfagus.app
```

Ostatni build został wykonany lokalnie i uruchomiony. Raport opisuje stan potwierdzony na tej maszynie; nie jest dowodem gotowości produkcyjnej ani live release.
