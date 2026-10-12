# Scalfagus — Local QA · YYYY-MM-DD / run-id

> Overall: `PASS | PASS_WITH_WARNINGS | FAIL | BLOCKED | NOT_RUN`

## Kontekst

- Baseline `origin/main` pełny SHA: `<...>`
- Branch QA / PR: `<...>`
- Tested SHA po fixach: `<...>`
- OS / CPU / architecture / RAM: `<...>`
- Godot `4.7.2.stable` / GUT wersja: `<...>`
- Czas lokalny, start/koniec / duration: `<...>`

## Test matrix

| Command / scenario | Exit | Status | Log | Notes |
|---|---:|---|---|---|
| `bash scripts/check.sh` | ? | PASS/FAIL/BLOCKED | `logs/local-qa/...` | |
| `bash scripts/check-gut.sh` | ? | PASS/FAIL/BLOCKED | | N testów / N asercji |
| `bash scripts/check-map.sh` | ? | PASS/FAIL/BLOCKED | | source git SHA / JSON |
| `node --test architecture/examples/test_five_view_mapping.mjs` | ? | PASS/FAIL/BLOCKED | | N/N |
| Manual gameplay + Keychain persistence | n/a | PASS/FAIL/BLOCKED/NOT_RUN | | |
| Exports + target runtime | ? | per platform | | |
| Stress / replay / leak audit | ? | per scenario | | seed/performance/RID |

## Twarde punkty akceptacji

- 20Hz, Matter 1660, 10 złóż, 3×3/6m/12 portów, 49/148 physics, source SHA: `<evidence>`
- Ownership, conserved Matter, replay determinism, LOS *diagnostic only*: `<evidence>`
- Group orders, W pan/T train, po zmianie T→Y persistence: `<evidence>`
- H-H LAN/ENet, FPP, ETH/ORG, ridge/ramp: `PASS | NOT_IMPLEMENTED | NOT_RUN` każde osobno

## Incydenty i naprawy

| ID / priority | Expected vs actual / steps / seed | Root cause | Fix commit | Before → after log |
|---|---|---|---|---|
| QA-001 / P0 | ... | ... | ... | ... |

## Ostrzeżenia, blokery i uczciwe pominięcia

- ObjectDB/RID, stderr: `<ile/jakie>`
- PASS bez logu: niedozwolony; blocked/skipped tests: `<...>`
- Decyzje właściciela potrzebne dla: `<...>`

## Zmiany, GitHub i artefakty

- Commits: `<URLs>`; PR: `<URL>`; raport permalink: `<URL>`
- Sanitized logs: `<relative paths>`
- Final `git status --short`: `<clean or blocker>`

## HANDOFF TO CHATGPT

> Przetestowano Scalfagus base `<sha>` → tested `<sha>` na `<OS/Godot>`. Raport: `<GitHub permalink do tego pliku>`. PR: `<URL>`. Gate'y: check `<...>`, GUT `<...>`, map `<...>`, sprites `<...>`, manual `<...>`. Naprawiono `<...>`. Pozostałe P0 `<...>`. Proszę `<konkretne kolejne zadanie>`. Nieuzyskane wyniki nie są PASS.

