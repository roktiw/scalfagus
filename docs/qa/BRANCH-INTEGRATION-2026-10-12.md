# Scalfagus — merge wszystkich gałęzi do main, 2026-10-12

- Audyt: **18 gałęzi poza main**, **0 otwartych PR**.
- **13 gałęzi** miało `compare(main...branch).ahead_by = 0`: ich commity już są przodkami main, nie trzeba ich merge'ować ponownie.
- **5 gałęzi** miało historyczne dodatkowe commity: `art/faction-emblems-nine-variants`, `feat/godot-addons-local-install-20261011`, `feat/godot-five-view-spike`, `feat/godot-mit-addons-2026-10-11`, `feat/rts-command-hud-verdant-slice`.
- Kontrola drzew Git: **żadna z pięciu nie miała ścieżki, której brakowało w main**. Ich starsze treści były już zastąpione przez nowsze GUI, addons, YAML, grafiki i smoke tests.
- Dlatego ich **historia** została scalona commit-em o wielu rodzicach, a **treść** rozwiązano strategią `ours` na korzyść nowszego `main`. Nie cofano testów, mapy, Keychain, LOS 3D ani decyzji DEC-033–046. W tym samym commicie dodano QA handoff.
- Po merge: sprawdź ponownie `compare(main...branch)` dla każdej gałęzi i wymagaj `ahead_by = 0`. Gałęzie-refy pozostają do audytu; merge nie oznacza ich usunięcia.
- Ta operacja sama **nie uruchamia Godota**: wykonywanie lokalnych testów i raportowanie zostało przekazane w `docs/qa/LOCAL-AGENT-TESTING.md` oraz `scripts/qa-local.sh`.

