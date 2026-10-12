# Scalfagus — instrukcja lokalnego agenta QA

**Wykonaj na aktualnym `origin/main`.** Ta instrukcja jest nadrzędnym handoffem testowym; gameplay definiują `AGENTS.md`, `design/decisions.yaml` (MVP0 DEC-033) i źródłowe YAML. **GitHub Actions nadal nie stanowi test gate** — używamy realnego lokalnego Godota 4.7.2 stable.

## Start i ochrona cudzej pracy

```sh
git fetch origin --prune
git status --short
git switch main
git pull --ff-only origin main
git log -1 --format='%H %s'
git submodule status
git switch -c fix/local-qa-$(date +%Y%m%d)-$(git rev-parse --short HEAD)
bash scripts/qa-local.sh
```

Nie używaj `reset --hard`, force push ani usuwania cudzych gałęzi. Jeśli drzewo jest nieczyste, zatrzymaj proces i opisz blokadę bez utraty danych. Jeśli `qa-local.sh` zgłosi brak PyYAML, zainstaluj bezpiecznie tylko build-time:

```sh
python3 -m venv .tools/map-venv
.tools/map-venv/bin/python -m pip install -r scripts/requirements-map.txt
MAP_PYTHON=.tools/map-venv/bin/python bash scripts/check-map.sh
```

Jeśli lokalnych submodułów brakuje, najpierw `bash scripts/install-godot-addons.sh --ensure`, potem `--check`; nie podmieniaj pinned addonów. Zachowaj log pierwszej awarii i ponów pełen pakiet po poprawkach.

## Kolejność testów

| Priorytet | Warunek odbioru | Test / dowód |
|---|---|---|
| P0 | Godot 4.7.2 import, parsowanie, scena menu i meczu, Keychain, RTS Framework, State Charts, GUT, licencje i brak crashy | `bash scripts/check.sh` |
| P0 | Ownership, odrzucanie nielegalnych rozkazów, brak duplikacji Matter, reproducible replay/hash, victory/defeat | mirror/integrity/batch + GUT |
| P0 | 20 Hz, 24 000 ticków, 40 ticków/Matter, 2 minerów/złoże, Worker 140, Rifleman 180, Barracks 360, strzał co 20 | `mirror_timing_smoke.gd` |
| P0 | Verdant 64×64, 2 m/pole, 10 złóż = 1660 Matter, NW/SE starter 400, zgodność kanonicznego YAML z JSON SHA i stałymi colliderami | `bash scripts/check-map.sh`, authored-map smoke |
| P0 | HQ/Barracks 3×3 = 6×6 m, 9 pól kolizji AStarGrid2D, 12 zewnętrznych portów, spawn, budowa, śmierć | `mirror_footprint_smoke.gd`, navigation/visual |
| P0 | LOS native: 49 komórek drzew, 148 wody, budynek jako cel/przeszkoda, remove-on-death; diagnostyczny raycast **nie** zmienia autorytatywnego combat | `mirror_physics_los_smoke.gd` |
| P0 | Klik/Shift/drag, rozkazy grupowe, brak kontroli wroga, Keychain: W kamera, T train Worker; po ręcznym remap T→Y utrzymanie po restarcie | group/keychain smoke + GUI |
| P1 | Pixele 5-view, atlas, emblematy, prawdziwe sprite'y bez missing assets | `node --test architecture/examples/test_five_view_mapping.mjs`; check.sh assets |
| P1 | GUT: uruchom wszystkie testy, raportuj ich realną liczbę i asercje | `bash scripts/check-gut.sh` |
| P1 | Eksporty macOS, Linux, Windows, Web z właściwymi template'ami i wbudowanym `maps/*.json`; runtime osobno na danej platformie | `bash scripts/build.sh macos` itd. |
| P1 | Headless 10 powtórzeń, seed 42, hash deterministyczny, 10/100 aktorów jeśli dostępne; FPS i RID/ObjectDB leak warnings | zapis pomiarów i seedów |
| Scope | H-H LAN/ENet, FPP, ETH/ORG, prawdziwe rampy i heightmap: nie zgaduj, zgłoś `NOT_IMPLEMENTED` jeśli brak | link do decyzji/backlogu |

**Manual GUI:** `bash scripts/dev.sh --editor` → Options / Keychain, zmiana przypisań → start Human-vs-Bot, Worker gather→return→HQ→Barracks→Rifleman→attack, selection drag/Shift i kamera, Bot-vs-Bot, widoczność drzew/budynków, overlap 3×3. Sprawdź po ponownym uruchomieniu profil skrótów. Jeśli brak ekranu lub template'ów: zapisz `BLOCKED`, nie PASS. Mac export nie dowodzi uruchomienia Windows/Web.

## Co wolno poprawiać bez pytania

Minimalny fix: GDScript parse/runtime/API Godot 4.7.2, fixture testowe i błędne współrzędne, import/export zasobów, korekta ścieżek, lokalny runner, cleanup wycieków, deterministyczne iteracje bez zmiany reguł, regresje UI. Dla każdego błędu: zreprodukuj, podaj expected/actual i seed, określ root cause, dodaj test lub napraw istniejący, powtórz wszystkie gate'y.

**Nie wolno zmieniać bez decyzji właściciela:** gameplay balance, reguły DEC-033–046, źródło mapy, liczby Matter, koszty, 20 Hz, 3×3/2m, ownership, replay, combat authority, provenance zależności, przyszłe frakcje i osobiste decyzje projektowe. Nie wyłączaj testów, aby przeszły. `MirrorMatchState` pozostaje autorytetem; raycast Godota jest diagnostyczny. Jeśli naprawa wymaga tych zmian, raportuj `REQUIRES_OWNER_DECISION`.

## Jak zgłaszać poprawki i wyniki przez GitHub

1. Utwórz **nowy**, nie nadpisywany plik `docs/qa/reports/YYYY-MM-DD-<base-sha>-<run>.md`, zaczynając od `docs/qa/REPORT-TEMPLATE.md` lub raportu wygenerowanego przez `scripts/qa-local.sh`.
2. Każde `PASS` wymaga realnego kodu wyjścia 0 **na podanym końcowym SHA**, logu i zakresu testu. Odnotuj `FAIL`, `BLOCKED`, `SKIPPED`, `NOT_IMPLEMENTED`, ostrzeżenia RID/ObjectDB, OS/arch/Godot, czas, liczbę GUT testów i asercji, pomiary i niezweryfikowane funkcje.
3. Oczyszczone logi umieść pod `logs/local-qa/<run-id>/`; usuń tokeny, ścieżki prywatne, dane osobowe, nie publikuj sekretów. Raport zawiera linki do plików logów oraz komendy reprodukcji.
4. Zapisz poprawki małymi commitami na gałęzi `fix/local-qa-*`, raport po testach w ostatnim commicie; `git status --short` ma być czysty. Wypchnij gałąź, utwórz PR do `main`. Nie force-pushuj i nie merge'uj w ciemno. Jeśli nic nie poprawiasz, utwórz PR zawierający wyłącznie raport.
5. W końcu raportu umieść **HANDOFF TO CHATGPT**: URL raportu, URL PR, base+tested SHA, matrix PASS/FAIL/BLOCKED, najważniejsze poprawki i nierozwiązane P0 oraz jedno następne zadanie. Przekaż permalink właścicielowi do wklejenia do rozmowy z ChatGPT. Sam push nie uruchamia czatu.

**Nie zamieniaj nieprzetestowanych funkcji w „PASS”.** Lepiej oddać dokładny raport częściowy.

