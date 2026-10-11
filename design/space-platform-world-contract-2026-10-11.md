# Scalfagus World Constitution — Every Battlefield Is a Spaceborne Platform

Date: 2026-10-11
Status: **OWNER-APPROVED UNIVERSAL WORLD RULE (DEC-030)**.
Supersedes optional/alternate nonplatform map framing in DEC-029, `design/floating-platform-battlefields-2026-10-11.md`, `design/battlefield-frames.yaml`, earlier jungle/world-topology/agent documents **where inconsistent**.
Canonical machines: [battlefield frames](battlefield-frames.yaml), [surface presets](platform-surface-presets.yaml), [map authoring format](map-authoring-format-v0.1.yaml), [first map](mvp-verdant-divide-map.yaml). Agent tasking: [MVP delivery gates](MVP-DELIVERY-GATES.md), [agent handoff](AGENT-MVP-IMPLEMENTATION.md), root [AGENTS.md](../AGENTS.md).

## Non-negotiable world rule

**Every Scalfagus playable map is a floating platform/deck/island/vessel in outer space.** No standard playable terrestrial patch on a planet surface as an alternative map framing. Its soil and terrain may look Earthlike or alien, but the playable battleground is a constructed or naturally suspended **bounded independent platform** with a visible outer edge, finite land area, and space beyond it.

This is both an **art/world identity requirement** and a **gameplay geometry contract**. The platform itself has a flat-ish navigable top with local hills/ramps, a vertical rim and underside. Its underlying technical map topology in MVP is `planar` (rectangular square grid), with **hard four-sided physics and navigation limits**. `floating_space_platform` is a **required battlefield frame**, not an optional toggle or cosmetic free choice. A planet visible behind the platform is a distant backdrop, **not** the match surface.

**All future authored playable maps must include this required platform framing**, including any desert, jungle, metal, mountain, industrial, laboratory, wetlands or alien-material biome. A scenario can be dark/empty/waterless, but not a naked planetary surface with no floating platform. Any exception later requires a new **explicit owner decision**, not silent developer inference.

## Surface appearance is independent from platform identity

| Original biome candidate | Deck / traversable top | Edge/underside | Liquids | Tactical geometry |
|---|---|---|---|---|
| **Earthlike brown-soil jungle** (MVP) | Real brown soil, thick tree-trunk cover, clearings, scattered rocks and deadwood | Layered clay/rock, vines and old support braces/thrusters | Freshwater ponds, small river/canals, nonharvestable in first slice | Three approach routes, tree-trunk projectile blockers |
| **Industrial patchwork metal** | Welded mismatched plates, grated walkways, rust, containers and machinery | Exposed struts, cables, engines and hanging scrap | Dense coolant basins / nonwater fluid possible | Pipes/containers make solid cover |
| **Rocky desert / wasteland** | Ochre sand, broken stone, craters and ramps on a suspended slab | Stratified rock/industrial scaffolds | Brine or hydrocarbon, or a dry later scenario as explicitly permitted | Outcrops and canyon chokepoints |
| **Resonant monastery** | Stone terraces, small garden islands, luminous mineral formations | Obelisks/levitation framework and mechanical supports | Reflective calm pools or exotic dense fluid | Arches/pillars and narrow lanes |
| **Biological wet ark** (future ORG) | Wet organic soil, mangroves, roots, canals | Living hull growing over an older substrate | Water/wetlands, later with aquatic units | Roots, reeds and shoreline control |

Those five entries are **visual/authoring presets**, not 5 new gameplay maps, new armies, or an approval to add fluid extraction in MVP. Define platform structure separately from **surface material** (e.g. brown earth, metal patchwork), separately from **tactical collision objects** (trees, pipes), separately from the **environmental liquid substance** (water, coolant). A map may mix multiple surface materials on the same platform (e.g., 70% brown soil and 30% patched metal), or use irregular-looking *visible* silhouette over a square MVP gameplay grid. No biome forces affinity buffs for MAN Earth, ETH Air or ORG Water.

## Unified, implementation-ready map invariants

1. `world.topology: planar` is required in MVP, with `world.gravity: uniform`. The 3D surface has bounded tile X/Y and optional elevation / ramps. One hero/army/navmesh/physics scene is shared by Overlord, Direct and FPS.
2. **`battlefield_frame.variant: floating_space_platform` must exist in EVERY authored playable map**. The compiler throws a validation error on missing, disabled, `bounded_planetary_surface` or unknown variants; a bare planet surface is not a fallback. Version/DEC reference attached to errors.
3. A visible `rim` is part of the map presentation. A matching invisible **impenetrable collider/guard** exists on all four edges for MINs, soldiers, Hero and moving packed MAN UMU, including knockback/physics. No gameplay actions target outside bounds; no building placement/loot drops outside bounds.
4. The 3D top surface has real physical ground, slopes/ramps and solid collision. Decorative rim/underside/sky/planet/clouds must not silently add pathfinding or resource nodes. The platform as world infrastructure is faction-neutral and does **not** count as a `victory_building`; owner win remains defeat after loss of all enemy living completed buildings, including mobile building-class actors.
5. Space beyond the rim is not walkable, swimmable or flyable in first MVP. No fall-off death penalty; collisions/guards stop actor movement. Projectiles and spawned loot resolve inside legal gameplay world; art only beyond.
6. Platform itself **does not travel during a match**. Starfield/planet can parallax cosmetically; no orbital gravity, orbital navigation, moving world origin, engine fuel costs, platform HP/capture or destruction in MVP.
7. First playable platform is **Verdant Divide**: proposed 64x64, brown soil with a jungle, real tree cover, stone/deadwood SOLID sources, ponds/streams as physical **nonharvestable liquid terrain**, two spawn slots, three routes. MAN vs ETH ground-only, five roles per faction. Do not migrate the first MVP into an industrial battlefield just because metal is a future family.
8. Resource source form **SOLID** is the only collectible world source in first MVP. Liquids existing inside the platform do not become free harvestable Liquid/Gas resources. Matter/Volatiles/Energy remain distinct economic IDs under the scoped MVP Solid→Matter recipe and separately booked Energy.
9. Surface/underside style and distant backdrop are **presentation**. Changes to those layers alone must not change actual map-space collision/navigation, resource inventory, victory predicate or deterministic replay.
10. No exact IP-specific designs or copied characters from known science-fiction RTS, Factorio, or animated-film studios. Inspirations are high-level construction-deck/whimsical suspended habitat design, with original Scalfagus silhouettes and textures.

## Three independent coordinates of world design

| Layer | Required YAML key | Implementation authority |
|---|---|---|
| Gameplay topology | `world.topology` | Initially strictly `planar`. Controls geometry, collision and world-up. |
| **World frame identity** | `battlefield_frame.variant` | Strictly **`floating_space_platform`**, all playable maps, with hard border and visible rim. |
| Surface materials/biome | `environment.preset`, `surface_palette`, `terrain_regions` | Soil, industrial metal, stone, wetland etc; allowed multiple materials and decorations without redoing simulation. |

`spherical` world topology remains an archived research spike only; it is **not** a supported alternative map in Scalfagus's current map authoring workflow. A genuinely spherical floating body would require a deliberate new design decision that reconciles curvature with the universal platform requirement; a starfield background planet never satisfies that.

## How to author and compile maps

A sparse YAML manifest declares platform frame, grid, elevation, terrain material palette, region masks, ramps, liquid bodies, fixed blockers, start slots, source inventory, decoration seed and validation contracts. Build-time tool (TypeScript/Node appropriate) reads YAML and emits versioned, deterministic JSON/runtime map data; Godot owns the authoritative collision/render/navigation simulation. Optional future lossless raster height/terrain masks are supplements; stable object IDs stay in YAML.

Mandatory validator checks before the game can load an authored map:
- Universal required `floating_space_platform` with art rim, an invisible four-sided collision guard, valid platform surface and a neutral non-victory frame;
- All world/traversable/attackable/spawned objects lie within bounds; projectiles and loot cannot escape or duplicate inventory;
- Defined traversable land with ramp heights, tree/pipe cover collision, no illegal path across water/dense liquid; at least two viable ground attack paths for MAN mobile UMU footprint;
- At least one safe finite SOLID deposit per starting faction, with fair starter travel/cargo access and no need for extraction infrastructure;
- Clear distinction `terrain_liquid_body` vs `harvestable_resource_node`; current jungle pools are not economic Liquid resources;
- Cosmetic seeds do not change collision/source geometry or deterministic simulation;
- A platform surface material preset can be swapped without altering the physics unless its semantic collider/deposit masks are explicitly changed as game-authoring data.

## What agents must build first

See [MVP delivery gates](MVP-DELIVERY-GATES.md) and [MVP implementation backlog](mvp-implementation-backlog.yaml). The first map-compiler PR needs a **strict platform-frame validator**, a **flat bounded map**, a **visible primitive rim/underside**, **starfield / optional planet background**, and **edge collision**. It should render first with **simple placeholder mesh/materials** if necessary, not wait for perfect environment art. Tree cover, water and sources keep their real authored locations.

If a later developer wants an entirely bare square map to debug collision, it can be an **internal unshipped dev scene** with diagnostic geometry and no declared playable-map status. Any map exposed in match selection/loading must conform to the universal floating-world requirement.

## Out of scope until after full two-race MVP

Flying units, swimming/boats, multiple decks, interplanetary ship travel, moving entire tactical worlds, destructible/capturable mega-platforms, gravity engines, procedural generation of complete strategic layouts, fully spherical planetoids, next civilization ORG, extracting liquids/gases, complex planet weather and economic tech trees.

## Source precedence

**DEC-030 overrides DEC-029's "floating platform optional" and "ordinary bounded planetary surface remains legal" options.** DEC-025/026/027 remain intact for MAN–ETH, solid-only harvesting, environmental elements and sparse map YAML. DEC-024 remains the victory condition. The first map can look Earthlike because real brown soil and jungle can exist **on** a space platform.
