# Scalfagus — Instructions for Coding Agents

This repository has **an existing Godot 4.7.2 native three-camera game spike**, **an existing Tauri 2 desktop launcher**, bootstrap scripts and tests. Do not generate a replacement project from scratch.

## Read before modifying implementation

1. **Current plan / agent PR worklist:** [design/AGENT-MVP-IMPLEMENTATION.md](design/AGENT-MVP-IMPLEMENTATION.md).
2. **MVP MAN vs ETH five-role roster:** [design/mvp-man-eth-catalog.yaml](design/mvp-man-eth-catalog.yaml).
3. **Map and geometry:** [design/mvp-verdant-divide-map.yaml](design/mvp-verdant-divide-map.yaml), [design/map-authoring-format-v0.1.yaml](design/map-authoring-format-v0.1.yaml), [design/world-environments.yaml](design/world-environments.yaml).
4. **Simulation:** [design/mvp-economy.yaml](design/mvp-economy.yaml), [design/mvp-combat.yaml](design/mvp-combat.yaml), [design/mvp-bot-behavior.yaml](design/mvp-bot-behavior.yaml), [design/mvp-man-eth-acceptance.yaml](design/mvp-man-eth-acceptance.yaml).
5. **Rules and owner decisions:** [design/decisions.yaml](design/decisions.yaml), [design/three-network-channels-and-destruction.yaml](design/three-network-channels-and-destruction.yaml), [design/world-loot-and-recycling.yaml](design/world-loot-and-recycling.yaml), [design/victory-building-template-registry.yaml](design/victory-building-template-registry.yaml).
6. **Map topology choice:** [design/planetary-map-topology-2026-10-11.md](design/planetary-map-topology-2026-10-11.md), [design/world-topologies.yaml](design/world-topologies.yaml).

## Scope that must not drift

- **First playable:** MAN and ETH only; mother, MIN worker, basic soldier, UMU/Pylon, barracks per faction; one Earthlike exotic jungle map; surface SOLIDS only; water bodies exist as **impassable nonharvestable terrain**.
- MAN basic mobile infrastructure is the **Universal Man Unit (UMU)**, ground-only. ETH infrastructure is one stationary **Pylon/Obelisk** with one Ether Network carrying accounted converted resources, Energy and information, conversion allowed only at Nexus.
- Three natural environmental affinities are future identities: MAN earth, ETH air, ORG water. **No swimming or flying in first MVP.**
- Default victory: all **completed living building-class entities** eliminated, **including mobile packed MAN UMU**. Workers, Hero, soldiers, loose items, wrecks and unfinished sites don't prolong matches.
- World drop silhouettes: MAN cube, ETH orb, later ORG tetrahedron; source form determines color. All real currency transfers must be ledger-correct and salvaging cannot create infinite closed cycles.
- Reuse **one native 3D world** in all camera perspectives; do not split RTS and FPS into separate simulations.
- Terrain/topology: **PLANAR** implemented first. Genuine SPHERICAL planetoids are a **future candidate**, not a feature supplied by a flag alone. Validate and reject unsupported sphere manifests explicitly.

## Environment and regression

- Main game: `apps/game/project.godot` (GDScript); TypeScript can compile authored YAML to JSON and assist tooling, not act as a second realtime simulation.
- Existing launcher: `apps/desktop/` Tauri 2. Use existing scripts instead of new package templates.
- From root, after dependencies: `npm run check` for smoke/build and `npm run game` to launch. Run native Godot headless fixtures as they become executable. Record which commands were actually run.
- Do not break existing `apps/game/tests/smoke.gd`, actor ID continuity, 5-source-view sprites/mirroring, or camera F1/F2/F3.
- All design and source files and code comments **in English**.
- For each task implement the minimal behavior, add tests, update relevant YAML status and document known limitations. Do not claim unrun acceptance scenarios passed.
- **Proposal-only values** (prices, HP, map dimensions, planet radius, supply/energy rates) are seed data to tune, not owner-approved balance.

## If two specs conflict

Newest **explicit owner-approved** DEC entry takes precedence over historical proposals. Specific latest priorities: DEC-021–024 networks/loot/victory; DEC-025 MVP content; DEC-026 environments; DEC-027 map authoring; DEC-028 is **research only** for possible spherical planet. Do not silently relabel legacy crystals/gas/resin into Matter/Volatiles/Energy outside the explicitly scoped solid→Matter first-map conversion. Document migration rather than guessing.
