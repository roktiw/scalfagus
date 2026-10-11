# GitHub Actions local replay — 2026-10-12

Branch: `fix/ci-local-parity` (pulled `origin/main` before testing).

## Commands and results

| Local equivalent | Result |
| --- | --- |
| `bash scripts/check.sh` | PASS — `SCALFAGUS_GODOT_CHECK_PASS` |
| `bash scripts/check-gut.sh` | PASS — 4/4 tests, 32 asserts |
| `bash scripts/check-map.sh` | PASS — YAML and committed JSON match |
| `node --test architecture/examples/test_five_view_mapping.mjs` | PASS — 6/6 tests |

The Godot replay used the repository's Godot 4.7.2 installation and exercised addon import, addon manifests and Keychain autoload, startup/menu/RTS/navigation smoke tests, mirror authority/integrity/timing/A*/authored-map/batch/visual/group tests, atlas validation, and faction-emblem checks.

## Fixes made after the first replay

- `apps/game/tests/addons_smoke.gd`: call `get_node_or_null` through the `SceneTree.root` node. The previous call was a parse/runtime error because `SceneTree` does not expose that node lookup method.
- `apps/game/tests/mirror_smoke.gd`: place the funded Barracks test at `(13,12)`, within the HQ build radius. `(13,36)` was outside the authoritative build rule and made the test reject a valid funded scenario.
- `apps/game/tests/mirror_group_orders_smoke.gd`: target the actual northwest resource at `(17,10)`. `(17,31)` was not a resource cell, so the group-order test could not exercise the gather gateway.

## Notes for GitHub Actions

The current workflow checksum for the official Godot 4.7.2 Linux archive is already the full 65-character SHA-256 (`...b35329e4`); no workflow checksum change was needed in this pull. The local run still leaves four renderer `ObjectDB`/RID leak warnings from headless scene teardown, but all commands exit successfully and no test reports a failure.

Raw logs are kept under `logs/ci-local-2026-10-12/` for the next agent to inspect.
