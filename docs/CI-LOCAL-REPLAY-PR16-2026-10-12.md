# PR #16 local replay — 2026-10-12

The physics LOS branch was tested locally after pulling its current remote tip.

| Command | Result |
| --- | --- |
| `bash scripts/check.sh` | PASS — includes `SCALFAGUS_MIRROR_PHYSICS_LOS_PASS` |
| `bash scripts/check-gut.sh` | PASS — 4/4 tests, 32 asserts |
| `bash scripts/check-map.sh` | PASS |

The first run exposed two test-fixture issues after the 3×3 building change: the integrity and navigation tests spawned Barracks on authored tree cells, and the navigation test had a typo (`crosses_foot`). Both fixtures now use a clear map corridor and the corrected variable. The final `check.sh` completed with all smoke, footprint, physics LOS, group-order, atlas, and faction-emblem checks passing.

Raw output is in `logs/ci-local-2026-10-12-pr16/`.
