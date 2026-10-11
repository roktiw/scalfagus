# GitHub Actions — lokalny replay i diagnoza

Data: 2026-10-11  
Commit testowany: aktualny `main` podczas replayu

## Wniosek

Gra i lokalne testy Godot działają. Niedziałające GitHub Actions mają problem w samych workflowach, przede wszystkim w kroku pobierania Linuxowego Godot 4.7.2: wpisany SHA-256 jest niepełny/błędny.

Workflowy uruchamiane w repo:

- `.github/workflows/faction-emblems.yml`
- `.github/workflows/five-view-spike.yml`
- `.github/workflows/godot-native.yml`

## Co przeszło lokalnie

Odtworzone kroki bez zależności od Tauri:

- `node scripts/test-faction-emblems.mjs` — pass,
- `node scripts/build-faction-emblems.mjs` + ponowna walidacja — pass,
- `git diff --exit-code -- assets/faction-emblems` — pass,
- `node scripts/verify_atlases.mjs` — pass,
- `node --test architecture/examples/test_five_view_mapping.mjs` — 6/6 pass,
- Godot import — pass,
- `res://tests/smoke.gd` — `SCALFAGUS_SMOKE_PASS`,
- `res://tests/menu_smoke.gd` — `SCALFAGUS_MENU_PASS`,
- asset manifest — pass,
- `bash scripts/check.sh` — `SCALFAGUS_GODOT_CHECK_PASS`.

Pełny log replayu znajduje się w [logs/gha-local-2026-10-11/run.log](../logs/gha-local-2026-10-11/run.log).

Uwaga: po wykonaniu `node scripts/build-faction-emblems.mjs` dwa śledzone pliki binarne zmieniły się lokalnie: `assets/faction-emblems/faction-emblems-32.png` oraz `assets/faction-emblems/faction-emblems-64.png`. Oznacza to, że krok `git diff --exit-code -- assets/faction-emblems` nie jest stabilnym testem na obecnym checkoutcie, jeśli wygenerowane obrazy nie zostaną zacommitowane. Zmiany zostały zachowane w tym commicie jako dowód replayu, a nie ukryte lub nadpisane.

## Znaleziony błąd workflowa

Oba workflowy Godot używają:

```text
cadd3204e728a35d3f13adb7fd0d7902636b79f6b95c40c265eb73b6c35329e4
```

Lokalnie pobrany plik `Godot_v4.7.2-stable_linux.x86_64.zip` ma SHA-256:

```text
cadd3204e728a35d3f13adb7fd0d7902636b79f6b95c40c265eb73b6c35329e4
```

Wartość używana przez workflow ma o jeden znak za mało (`...329e` zamiast `...329e4`). Na Ubuntu `sha256sum --check` zakończy się błędem, więc job zatrzyma się przed importem projektu. Log pobrania, porównanie SHA i próbę uruchomienia binarium są w `logs/gha-local-2026-10-11/linux-replay/`.

Na macOS nie można wykonać linuxowego binarium (`exec format error`), dlatego lokalny test gry używa zweryfikowanego Godot 4.7.2 macOS. To ograniczenie platformy testowej, nie błąd projektu.

## Dodatkowa obserwacja

W lokalnym replayu bez pobranego binarium `GODOT_BIN` krok kończył się `permission denied`. Workflow powinien najpierw skutecznie przejść download + pełną weryfikację SHA, a dopiero potem uruchamiać Godot. Obecny `scripts/check.sh` działa poprawnie na macOS i używa lokalnego `GODOT_BIN` z `.tools/Godot.app`.

## Zalecana poprawka dla agenta

1. Poprawić SHA-256 w `.github/workflows/five-view-spike.yml` i `.github/workflows/godot-native.yml` na pełne:

   `cadd3204e728a35d3f13adb7fd0d7902636b79f6b95c40c265eb73b6c35329e4`

2. Uruchomić workflow ponownie na Ubuntu.
3. Nie zmieniać logiki gry na podstawie obecnych czerwonych Actions — lokalne testy gry przechodzą.
4. Zachować osobno ostrzeżenia `ObjectDB/RID` z headless smoke; nie są przyczyną nieudanego checksum stepu.
