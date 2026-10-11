# Scalfagus — Natural Environments, Ground-Only MVP and Map Authoring

Date: 2026-10-11
Status: **owner direction** for race domains, land-only MVP, visible liquid terrain and Earthlike jungle; **engineering proposals** for coordinates, sizes, YAML layers, RNG and future raster sidecars.
Data: [world environments](world-environments.yaml), [map format](map-authoring-format-v0.1.yaml), [first jungle map](mvp-verdant-divide-map.yaml), [spherical topology alternative](planetary-map-topology-2026-10-11.md).
Implementation handoff: [AGENT-MVP-IMPLEMENTATION.md](AGENT-MVP-IMPLEMENTATION.md).

## Latest universal map requirement — DEC-030 supersedes DEC-029

The owner confirmed **every playable Scalfagus map is an independent floating platform in outer space**. The first square bounded PLANAR MVP map is an **obligatory flying platform**, not an option. The same Verdant Divide jungle terrain can grow on the platform's real brown soil: a static hovering habitat deck with real soil, tree-trunk cover, freshwater basins, visible roots/industrial underside and a starfield/distant planet. It has a **visible exterior rim plus authoritative invisible hard wall** along all four sides, blocking all ground actors and building/loot placement outside the world. The platform itself is a faction-neutral background, not a building or win target. Planet travel and moving entire game maps are post-MVP ideas.

The world **MUST be a floating platform** for all authored playable maps, independently of the material of its upper surface; surface variants may include brown soil, jungle, patchwork industrial metal, rock, desert and mixed terrain. This **does not** change the planar gameplay topology, navigation domain or physical gathering rules, and it does not imply playable aircraft. The old `bounded_planetary_surface` fallback is FORBIDDEN by DEC-030. Art/lore and detailed engineering contract: [space-platform constitution](space-platform-world-contract-2026-10-11.md), [surface preset YAML](platform-surface-presets.yaml).

References: [flying platform design](floating-platform-battlefields-2026-10-11.md), [frame schema](battlefield-frames.yaml), [updated map fixture](mvp-verdant-divide-map.yaml).

Implementation handoff: [AGENT-MVP-IMPLEMENTATION.md](AGENT-MVP-IMPLEMENTATION.md).

## 1. Natural environment of each civilization

| Race | Natural environment | Future fantasy | First two-race MVP |
|---|---|---|---|
| **MAN** | Earth / terrestrial ground | Vehicles, mobile ground bases, hard fortification and physical engineering | Ground-only SCV, Rifleman, mobile-on-ground UMU |
| **ETH** | Air / atmosphere | Floating/levitating structures, future network-mediated pylon relocation, airborne units | Ground-only Courier/Channeler and Sentinel; Pylon/Obelisk is stationary |
| **ORG** | Water / aquatic organisms | Aquatic colonies, biological swimmers, ocean niches | Not a playable faction in this MVP, but reserve domain IDs |

Natural domain is *identity*, **not** a faction lock or intrinsic combat stat multiplier. Every civilization can later acquire other terrain movement capabilities through authored technology. In the first MVP, **no units swim, sail, hover, fly or operate in underwater/space pathing**. Maintain one authoritative 3D world, for RTS and future Direct/FPS perspective.

## 2. Terrain liquid versus economic liquid

The owner wants liquids visibly present in the **map even while ONLY SOLID deposits can be harvested**. Distinguish:
- **Liquid body** = terrain obstacle/material feature with an actual world location, surface, depth, substance and passability.
- **Liquid resource source** = explicitly specified *harvestable* economic deposit with finite inventory, legal hand-tap/pump rules; **none in MVP 0.1**.
- **Resource currencies** = Matter, Volatiles and Energy. In first MVP, surface solids produce **Matter via an explicitly scoped example recipe**, while Volatiles is unavailable and Energy comes from specified finite operating/storage mechanisms; never assume GAS equals Energy.

Initial Earthlike alien jungle should feel familiar: recognizable trees, vegetation, soil, streams and freshwater, with subtle exotic accents. No mandatory aquatic units.

Other possible worlds, not part of first release:
- Dense liquid coolant or synthetic gel in a spacecraft habitat: terrain liquid without requiring Earth water.
- Waterless volcanic/arid planet with hydrocarbon, molten salt or brine pools: **no water**, but nonwater liquids may exist.
- Classic barren StarCraft-like terrain entirely without visible liquid if the scenario explicitly opts out of the liquid-body requirement in a later map version. **Do not make dry maps impossible by a universal engine assertion.** Only first provided jungle must have liquid.

Each liquid body declares `substance_id`; rendering can use water/gel/opaque-fluid material, but gameplay movement checks the body's **ground-passability**, not cosmetic color.

## 3. Map dimensions — testable candidate presets

| Use | Tile grid | World span if tile = 2 m | Status |
|---|---:|---:|---|
| Engine and 3-camera smoke test | 32×32 | 64×64 m | candidate |
| **Verdant Divide first 1v1** | **64×64** | **128×128 m** | candidate |
| Large 1v1 | 96×96 | 192×192 m | future |
| Expanded warfare | 128×128+ | 256×256+ m | future |

Do **not** declare a world size universally balanced until pathfinding, UMU clearance, travel times and Ether edge ranges are tested. A 64×64 world can be too tight for multiple large UMUs.

Coordinates (initial planar worlds): `tile_x` increases east, `tile_y` increases south, origin at northwest; world coordinates `x=(tile_x+0.5)*tile_m`, `z=(tile_y+0.5)*tile_m`, and world `y=elevation(tile_x,tile_y)`. Tile Y is **NOT** 3D up. Heights are collision/LOS authoritative. A height transition requires a legal ramp; colorizing an elevated square alone must not make it walkable.

The map system should delegate world-grid conversion to a `WorldTopology` interface, **not scatter global planar X/Z assumptions inside unit logic**. Later genuinely spherical planetoids need local tangent up, radial gravity, surface graph navigation and six-face/icosphere seams. Planar is the MVP default; spherical is a separately scoped design candidate, not a rendered skybox effect. See planetary-topology document.

## 4. Author maps in sparse YAML before an editor

Use `design/mvp-verdant-divide-map.yaml` as the actual first authored fixture. It includes:
- metadata, scenario flags, playable factions, grid size/units and stable map ID;
- start slots and spawn footprints (factions assigned by match selection, not hard-coded corners);
- default ground material, sparse rectangles/polygons for elevations and terrain;
- ramps and valid traverse links;
- liquid bodies with precise geometry/surface height/depth and no automatic extraction;
- authored **route intent polylines**, to be **validated after** collision rather than carving arbitrary holes through a lake;
- trunk/giant-root cover with collision and actual projectile/LOS blocking;
- individual finite SOLID rock/deadwood deposits with stable IDs and explicit Matter output;
- seeded **nonblocking** foliage and small rocks for appearance;
- strict validation requirements with actionable errors.

**Do not handwrite 4,096 separate YAML tile entries.** Put strategic objects and sparse patches in YAML; compile into runtime occupancy, navigation, height, collision and visual data.

Recommended compilation order:
1. Parse + validate schema, unique IDs, bounds, types.
2. Allocate base height/terrain surfaces (and optional future lossless height/terrain rasters).
3. Apply elevations, ramps, terrain masks, liquid bodies and any valid bridges.
4. Instantiate fixed blocking trunks/cover and authoritative ground colliders.
5. Instantiate deposits/start footprints and check spatial conflicts.
6. Build world-space navigation and line-of-sight collision data.
7. Validate reachability of starters and at least two independent dry ground paths, including **packed UMU footprint clearance**; validate similar safe source stock/travel time.
8. Add seeded **cosmetic nonblocking** vegetation; resolve immutable map hash and replay metadata.
9. Fail invalid map with object IDs and coordinate ranges; **do not silently erase terrain, trees or water just to satisfy a designer's route hint**.

For later GUI tooling: keep stable YAML semantic object IDs and optionally reference a lossless `height_u16.png` height raster, `terrain_u8.png` material palette image and `liquid_mask_u8.png`. YAML defines resolution/scale, sidecar path/checksum and semantic objects. Do not use lossy JPEG or color-managed height gradients as authoritative height numbers. A PNG is a data asset, not a replacement for meaningful building/deposit/spawn entities.

## 5. Procedural vs raster vs authored, without strategic RNG exploits

**First 1v1:** all strategic collision and economic objects must be fixed: HQ locations, lake shores, trunks that block attacks, ramps, approach corridors, deposit positions/amounts. Cosmetic seed may scatter nonblocking grass, moss, ferns and leaves in legal free space, but not affect pathfinding, combat or mine reachability. Two replay seeds with identical gameplay geometry should produce identical results for the same input command log.

**Later procedural maps:** use noise/template generation for terrain drafts only; overlay explicit gameplay constraints, ensure two legal starting clearings, land paths, equal reachable starter resources, and valid liquid/cover placement, then **bake** to a deterministic map hash and seed. A future ranked map might fix approved generated seeds to preserve fairness. No designer promise of a mandatory 50/50 percentage of pixels: separate *semantic strategic layout* from *visual scatter*.

## 6. Tactical trees — physically useful and visually non-hostile

- Solid trunks/roots block ground movement, direct line of sight and basic straight projectiles, from both RTS and FPS. These share the same collider in the one authoritative world.
- Leaf canopy is drawn and may be faded/hidden when obscuring selected/player-controlled units; alpha is **not** fog-of-war or automatic combat concealment.
- **Living trees are NOT mineable** in MVP, to keep routes and cover stable. Collectible SOLIDS are separate loose surface stone/deadwood objects.
- Reserve tree destruction/chopping, marsh slow terrain, dense-fog cover and bridge building for later research.
- Spawn clearing must accommodate HQ, initial three workers, hero actor and at least one full UMU move/deploy footprint without intersecting water, rocks or trunks.

## 7. Why this is agent-ready and what remains candidate

Agent must read first:
- [AGENT-MVP-IMPLEMENTATION.md](AGENT-MVP-IMPLEMENTATION.md), [MVP roster](mvp-man-eth-catalog.yaml), [MVP map](mvp-verdant-divide-map.yaml), [authoring format](map-authoring-format-v0.1.yaml), [environment data](world-environments.yaml).
- [MVP combat](mvp-combat.yaml), [economy](mvp-economy.yaml), [bot](mvp-bot-behavior.yaml), [acceptance](mvp-man-eth-acceptance.yaml).
- Existing constraints: [DEC-021–024](decisions.yaml), [latest one/two/three network contract](three-network-channels-and-destruction-2026-10-11.md), [world loot](world-loot-salvage-and-recycling-2026-10-11.md), [default victory](victory-defeat-building-classification-2026-10-11.md).

**Owner-settled:** MAN earth, ETH air, ORG water, MAN+ETH MVP, ground-only movement, first map Earthlike jungle with actual water terrain, only SOLID collection, trees serve as actual tactical cover, default victory loss of all building-class structures (including mobile building-units). **Still proposals:** exact biome name, dimensions, elevation level unit, routing parameters, environmental Energy source, procedural aesthetics ratios, final path shapes and any deeper future physics. **NOT open:** all playable maps have spaceborne floating platform framing (DEC-030), and MVP terrain is hard-bounded planar.
