# Scalfagus — Overlord RTS and First-Person Possession

Date: 2026-10-11
Status: **owner-approved direction (DEC-031)**; implementation is **not yet migrated**.

**MVP 0.1 exception (DEC-033):** the FIRST playable release exposes **RTS Overlord only**. Do not implement FPP possession now. DEC-031 remains the approved two-perspective direction for a later Scalfagus release. TPP/Direct is still not a user-facing mode. Existing FPP/TPP technical spike remains as non-release debug baseline until safely migrated.

## Product contract

There are exactly **two supported player-facing gameplay perspectives**:
1. **Overlord RTS** — full strategic, isometric/orthographic view for base-building, transport/logistics, scouting, combat orders and army control. The player must be able to finish/win without possession.
2. **FPP/FPS Possession** — embody an eligible **existing** owned Hero/soldier, move/aim/fire from first person, and release control back to Overlord. This should feel distinctly different from a strategic camera (Dungeon Keeper-inspired possession).

**TPP and near-isometric Direct Unit are not a third product mode**. Do not develop polished third-person possession, animations, controller, shoulder camera, separate targeting or UI. Existing TPP/Direct camera spike may remain temporarily for debugging and existing smoke-test compatibility, but should be retired from user-facing inputs once two-mode tests replace them. Do not delete working code just to alter a specification.

The Architect / Commander / Avatar terminology describes interests and gameplay disciplines, **not** camera modes or locked classes. Engineer / Commander / Specialist starter kits and the Hero progression graph remain cross-compatible with both perspectives.

## Authoritative world and possession semantics

- Use **one native Godot 4.7.2 GDScript world, one authoritative simulation**, no duplicate 2D RTS and 3D FPS worlds, no Tauri/IPC runtime.
- Possession grants an **exclusive temporary input/controller lease on the same actor**. Stable ID, position, velocity, health, faction, equipment, experience, inventory, cooldowns, weapons, orders and resources remain continuous.
- RTS and possessed combat use the same movement/collision/weapon legality, range, armor, cooldown, damage, targeting domain, LOS, terrain cover and resource accounting. Camera perspective can alter how aim is selected, not inject a free damage multiplier.
- Release/death must hand back control, release mouse capture and restore/reconcile previous orders deterministically; no orphan camera or duplicated attack command.
- Worker AI, transport, economy, unit AI and combat continue uninterrupted in the background during possession.
- Pixel-art/close-up visual quality is a risk: the existing 32×48 directional sprite look suitable in RTS but may not stand up in FPP at close range. Test one real scenario and use near-field presentation variants only if necessary.

## Target user controls (not yet implemented)

| Action | Target |
|---|---|
| F1 | Overlord RTS |
| F2 | Enter first-person possession of selected legal actor |
| Escape while possessed | Release possession and return to Overlord |
| F3 | Unassigned or internal debug-only |
| First-person controls | WASD movement, mouse look, primary weapon/ability fire |

Input remapping is future scope. Do not expose three-way Tab cycling, Direct/TPP mode buttons or TPP tutorial after migration.

## Prototype reality and migration

As of this decision, `apps/game/scripts/main.gd` still has F1 Overlord, F2 Direct/TPP, F3 FPS and three-way Tab switching. `apps/game/tests/smoke.gd` covers the original three-camera spike. **No gameplay/input migration is implied by this document**.

Migration: (1) preserve the original code and smoke as baseline; (2) implement exclusive actor control lease and common command/weapon contract; (3) map F2 to literal FPP; (4) remove public TPP/Direct controls and UI; (5) replace/extend smoke with two-view test and keep legacy rendering checks intact; (6) verify playable RTS-only match and death/release.

## Acceptance

- Overlord → Possession → Overlord retains identical actor ID, HP, resources and state, with position/weapon cooldown updated only by legal gameplay events.
- One tree trunk blocks LOS and one world edge blocks movement in both modes.
- Possession does not pause economy or duplicate stocks; it cannot bypass fog, target restrictions or ammunition/energy.
- Death/invalid lease exits cleanly; no stuck mouse/input.
- In production UI only two perspectives are advertised; TPP is not a shipped feature.
- RTS-only player can still finish a match without using FPP.

## Supersession

**DEC-031 overrides any previous requirement to support three user-facing camera modes** in `design/hero-progressions-and-three-cameras-2026-10-11.md`, `design/three-pillars-one-world-control-contract.md`, `design/mvp-iso-pixel-rts.md`, `architecture/adr-0001-one-authoritative-game-world.md`, older engineering plans and acceptance fixture wording. These documents remain historical references for hero mechanics and single-world invariants.
