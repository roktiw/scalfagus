# MVP0 MAN mirror — state integrity follow-up

Date: 2026-10-11
Branch: `feat/mvp0-state-integrity-ci-20261011`
Status: **code and executable checks proposed in PR; Godot runtime results pending CI**.

This change hardens the **existing** Godot/GDScript match core instead of adding a second engine:
- Reject unreachable move, gather, and construction commands before applying them or spending Matter.
- Forbid Barracks on existing units or finite resource sources.
- Make queued production wait for an unoccupied, walkable spawn cell.
- Have intervening completed buildings block weapon LOS, without blocking shots against the target building itself.
- Pause construction when its paid site is temporarily occupied instead of throwing away the work.
- Remove Matter stored at an HQ when that HQ is destroyed, crediting it to accounted losses. Workers' carried cargo remains separate.
- Strengthen state hashing: production, orders, cooldowns, resources, map obstruction, routing, and match outcome influence the hash.
- Run an additional headless integrity regression and a bounded two-match C-C batch through `scripts/check.sh`.

## Validation

**Not claimed as passing at author time:** no official Godot binary was available in the authoring container. Required next checks:

```sh
bash scripts/check.sh
godot --headless --path apps/game --script res://tests/mirror_integrity_smoke.gd
godot --headless --path apps/game --script res://tests/mirror_batch.gd -- --matches 2 --seed 42
```

The existing test suite and graphical camera spike must remain intact. If GitHub Actions fails, inspect *actual job logs* and adjust only the failing code. The new regression guards **do not** deliver LAN Human-Human, full 20 Hz numeric tuning, native authored map parity or release-quality combat. These remain subsequent DEC-033 milestones.
