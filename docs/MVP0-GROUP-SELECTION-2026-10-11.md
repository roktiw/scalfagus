# Scalfagus MVP 0.1 — RTS group selection / orders

Date: 2026-10-11
Status: **code committed, Godot 4.7.2 engine execution NOT VERIFIED**.
Target: DEC-033 MAN vs MAN Overlord RTS; DEC-034 Reuse First.

## What's implemented

Human-controlled MAN match in `apps/game/scripts/mirror_view.gd`:
- Left click selects a friendly unit/building.
- Left mouse drag shows a native Godot `ColorRect` selection marquee.
  The scene's `Camera3D.unproject_position` is reused to select all
  friendly actors whose projected cell lies inside the rectangle.
- Shift-left-click toggles one actor; Shift-drag extends the group.
  Enemy units cannot become human selections.
- Each selected actor gets an existing-style marker; selected actors
  killed during simulation are pruned safely from group selection.
- Right click on a valid resource orders all selected **workers** to
  gather through `MirrorMatchState.issue_command`.
- Right click on a visible enemy orders all selected **riflemen** to
  attack through the same authoritative validated API.
- Right click on ordinary terrain assigns individual, distinct free
  cells in a small square/ring near the click to mobile selected actors.
  It calls the existing command API for movement, never directly
  edits entity positions or computes a substitute path.
- Barracks construction and HQ/Barracks training still use the
  current primary selected worker/building, not a duplicate queue
  or command domain.
- Escape cancels construction placement when active; otherwise
  returns to the main menu.
- Spectator mode is read-only and does not accept a human selection.

## Reuse evidence

- Existing repo: `apps/game/scripts/main.gd` already has marquee
  selection / screen projection, reused as an implementation pattern.
- Godot built-ins: `Control`, `ColorRect`, `Camera3D`,
  `Rect2`, `InputEventMouseButton`, `InputEventMouseMotion`.
- Reviewed but **not copied**: the vendored WIP RTS Framework
  SelectionManager, which is not currently integrated with the
  authoritative `MirrorMatchState`.
- Decision: **REUSE_EXISTING + WRAP_GODOT**.
- No add-ons, physics engine, custom A* or multiplayer protocol added.

## Acceptance tests

`apps/game/tests/mirror_group_orders_smoke.gd` creates an actual
Godot `mirror_match.tscn`, then tests single click, Shift toggling,
owner filtering, marquee projection, two distinct move targets,
legal multi-worker gather commands and cleanup after worker death.
`scripts/check.sh` now calls this test.

## Known limits

- This is **not** A* group coordination / advanced formations /
  local dynamic avoidance. Formation targets are selected by
  deterministic short-range search around the click, and independent
  actors may still block or overlap while travelling.
- Destination assignment may reject orders when only blocked or
  unreachable cells remain; the HUD displays an accepted count.
- No current benchmark for 100 units; GUI playtest and perf still required.
- Does **not** implement LAN Human vs Human, FPP possession,
  ETH or the later autonomous doctrine system.
- New Godot scene smoke **not executed in this environment**. Do not
  claim PASS until the developer runs `bash scripts/check.sh`
  under Godot 4.7.2 on macOS or CI.
