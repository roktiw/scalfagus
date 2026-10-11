# Scalfagus — Flat RTS Battlegrounds as Flying Platforms in Space

Date: 2026-10-11
Status: **OWNER CONFIRMED** first-MVP square, finite, nonwrapping **PLANAR** battlefield with an impassable boundary. **NEW EXCITING OWNER ALTERNATIVE / RECOMMENDED ART DIRECTION:** present battlegrounds as immense **flying platforms or mobile world-ships in space**, inspired by the visible edges and construction decks of classic sci-fi RTS, Factorio Space Age interplanetary platforms, and the layered mechanical/fantasy character of a wandering flying castle. Not yet a locked mandate that ALL future maps must be platforms.
Decision: [DEC-029](decisions.yaml). Machine contract: [battlefield-frames.yaml](battlefield-frames.yaml). First-map fixture: [Verdant Divide](mvp-verdant-divide-map.yaml).

## 1. Best of both approaches: same flat map, two diegetic skins

The core gameplay map remains a 2D tactical square grid over one 3D **PLANAR** heightfield, default proposed 64 x 64 cells at 2 m/cell. No true spherical surface, no gameplay map wrap, no in-match orbital motion, no new navigation domains.

| Aspect | Conventional square map | Floating platform / world-ship |
|---|---|---|
| Pathfinding, resources, building footprints | Standard planar bounded map | **Exactly the same gameplay data and simulation** |
| Edge | Invisible wall, visible distant world ground/horizon | **Physical-looking exposed platform rim plus blocking invisible safety volume**, beyond which is starfield/clouds/planet |
| Environment | Earthlike jungle, deserts, canyons | **Any of the same biomes can live atop a massive platform**: living jungle garden, desert terrarium, industrial deck, eerie liquid laboratory |
| Trees and rocks | Real 3D collision and LOS | Same collision and LOS; platform framing changes no tactical cover |
| Water or dense liquid | Lakes/streams are terrain features | Sealed ponds, canals, reservoirs or dense coolant basins **on platform**, still impassable/nonharvestable in initial MVP |
| Race identity | MAN Earth / ETH Air / future ORG Water | Same cultural affinity; all initial playable MAN and ETH actors remain ground-only |
| Engineering | Straightforward | Additional static underside/rim/skybox/atmosphere and art framing only |
| Travel between planets | Scenario transition | Later fiction: platform **may become a moving world-ship**; travel, fuel, hazards and campaigns are POST-MVP |

A platform is **not** a small tactical building, not a consumable item or another win-condition target. Its structural rim is part of the level backdrop/terrain, not a faction-owned `victory_building`. Destroying all opposing true buildings still wins; platforms must not create invulnerable extra faction-owned structure counters.

## 2. First MVP presentation candidate: Verdant Divide — Hanging Jungle Habitat

- Two faction-neutral jungle start clearings at NW and SE; trees and giant roots form real line-of-sight/hard cover. Preserve the 3-lane route topology, water bodies, SOLID-only Matter deposits, and 1v1 balance data **unchanged**.
- The jungle grows in **real soil on a huge hovering slab**. The edge shows weathered stone/old metal, engineered retaining structures, cable roots, hanging vegetation and enormous dormant thrusters below.
- In the background are stars, a distant planet, wispy orbital haze or clouds; choose one restrained lighting setup so the tiny readable 1990s-style pixel units remain legible. Avoid busy high-contrast thruster exhaust behind UI.
- Water pools and a stream are real but **not extractable** as economic liquid in this slice. They can be plausibly contained by gravity/atmosphere engineering without modeling the engineering.
- Rims show a physical edge; **units cannot walk beyond the level**. Add navigation blocking and a separate invisible physics guard/collider at the playable boundary so Hero/FPS or falling items cannot exit the world due a pathing/physics glitch. Do NOT introduce death-on-fall unless the owner explicitly selects it in a later ruleset.
- Standing trees remain intact cover (source stones/deadwood are separate objects). Resource pickup, building placement and ETH/UMU cable/graph behavior are unaffected by the backdrop or altitude in space.
- The entire battle deck/platform stays **stationary during the actual MVP match**. A slow cosmetic parallax starfield or flyby planet does not move the authoritative coordinate frame, cause world origin shifts, or affect deterministic replay.
- In-camera border treatment may be edge rails, shield generators, terraced soil retaining walls, exposed metal framing, ancient suspended masonry or vines. This is a visual set, **not a new gameplay fourth resource**.

**Visual direction (original, not an imitation of any IP's proprietary design):** classical clear RTS combat readability; heavy industrial modular substructure / exposed pipes; improbable living gardens and fluid basins; warm inhabited surfaces contrasted with cold outer space; asymmetrical whimsical mechanical silhouettes of a roaming castle. No requirement to copy original Factorio/StarCraft/Studio Ghibli art.

## 3. Suggested one-switch YAML design

Keep **`world.topology: planar`** completely separate from the **map frame/theme**:

```yaml
world:
  topology: planar
  gravity: uniform
  planar:
    width_tiles: 64
    height_tiles: 64
    tile_meters: 2.0

battlefield_frame:
  variant: floating_space_platform       # or bounded_planetary_surface
  edge:
    policy: impassable
    visible_rim: ancient_habitat_terrace
    physics_guard: true
    unit_fall_off: false
    projectiles_beyond_map: terminate_at_world_limit
  backdrop:
    sky: orbital_starfield
    distant_body: earthlike_planet
    deck_motion: stationary
    cosmetic_parallax_only: true
  platform:
    geometry: flat_ground_with_visible_underside
    local_gravity: static_uniform
    retains_atmosphere_and_liquid: lore_only
    travel_between_planets: post_mvp
```

Avoid using `world.topology: spherical` to mean "a tiny planet visible beneath the platform". The visible planet is a **background mesh only**. The actual battle surface is still a planar rectangle and is governed by all existing YAML map semantics.

For another skin, keep the same `world.topology: planar` and instead set `battlefield_frame.variant: bounded_planetary_surface` with an edge policy blocking all units. Both can share the **same height map, spawn, tree collision, water shapes, resource nodes and nav-data** when desired.

## 4. Why make the edge physically readable?

**Owner's minimum:** map edge is a square and has an invisible blocking wall. When framed as a flying platform, place a corresponding visible cliff/rim in the rendering and still use an invisible hard guard to enforce the constraint. That avoids player confusion about "why can't the unit move one more tile?" while keeping a reliable engine boundary.

Implementation:
1. `MapManifestLoader` compiles the 64×64 tactical ground into a bounded occupancy/nav/physics region.
2. An entirely separate `BattlefieldFrameRenderer` draws underside slab mesh, retaining ledges, deck edge art, distant starfield and optional planet or clouds beyond playable region; no extra unit nav nodes.
3. `WorldBoundary` uses a collision barrier/guard covering all four sides with sufficient 3D height to block normal Hero/UMU actors; reject illegal target destinations beyond world bounds before motion. Preserve real boundary collision for both RTS and FPS views.
4. Deny building placement or loose loot spawns outside legal cells. Any deterministic loot scatter near the edge projects to the nearest legal interior surface without teleporting into enemy storage or duplicating amounts.
5. Ensure raycasts do not wrongly treat the backdrop planet as an in-game target/collider, while edge/world physics and actual tree trunks can obstruct combat according to weapon rules.
6. All three cameras see the same underlying world; fade foliage when it occludes friendly actor. FPS may see the horizon/space beyond the edge but cannot walk/fly into it.
7. Test that a packed MAN UMU cannot push through an edge, and ETH pylon links cannot attach to fictional exterior background landmarks.

## 5. Four optional future platform families

| Family | Upper terrain | Rim / silhouette | Story hook (not MVP physics) |
|---|---|---|---|
| **Hanging Jungle** | Soil, huge trees, rivers and ponds | Roots + ancient habitat machinery | Portable Earthlike biosphere |
| **Orbital Foundry** | Metal panels, coolant pools, industrial ruins | Thrusters, cranes, solar wings | MAN-like factory ship |
| **Aerial Monastery** | Stone sanctuaries, tiny gardens, mist | Floating obelisks, resonant supports | ETH atmosphere/levitation flavor |
| **Drowned Ark** | Wet mangroves, canals, marshes | Organically overgrown deck | Future ORG water/biology fantasy |

**All maps floating platforms?** Owner raised this as an appealing option, but has not explicitly locked all future settings. Implement the frame selector as data-driven for current first map; a later aesthetic decision can set `floating_space_platform` as default across the campaign without changing gameplay map topology.

## 6. MVP vs later space-travel campaign

**MVP — implement:** flat 64×64 ground, static rim/void visual, invisible collidable boundary, solid extraction, water terrain, trees and normal terrestrial battle; a platform **does not move** in gameplay. Lightweight starfield and optional distant globe are background visuals only.

**POST-MVP — research:** traveling between planets, orbit management, changing location with a base aboard the platform, atmospheric shielding, map-vs-ship transitions, asteroid attacks, multiple decks, moving map coordinate origin, flight outside the platform and platform destruction. These are new systems requiring dedicated simulation and victory rules, not promised by simply choosing a floating aesthetic.

## 7. Agent acceptance cases

- `FRAME-01` same map geometry, same match gameplay on either `bounded_planetary_surface` or `floating_space_platform` visual frame.
- `FRAME-02` all four map borders are impassable to MAN MIN, ETH MIN, soldiers, Hero and packed moving MAN UMU.
- `FRAME-03` static starfield/planet cannot be selected, collided with, mined, attacked or reached by ETH network path.
- `FRAME-04` water stays on playable deck, liquid resource extraction remains off and biome/tree cover still works.
- `FRAME-05` visible platform edge matches hard gameplay edge; no unit falls to its death from an invisible mesh bug.
- `FRAME-06` deterministic battle coordinates / headless replay identical with cosmetic background or platform presentation change.
- `FRAME-07` still planar; spherical manifest guard keeps rejecting unimplemented real planet gameplay.
- `FRAME-08` last-building victory does not count the faction-neutral indestructible platform.
- `FRAME-09` world-drop scatter at map rim retains amount inside legal playable bounds.
- `FRAME-10` no ship travel, orbital physics, power consumption or automatic movement of entire tactical terrain during MVP.

## Decision boundary

**Approved by owner:** first-MVP square/rectangular bounded map with collision wall; no true spherical world demanded. **Strong owner-raised alternative; candidate to adopt visually for first map:** spaceborne floating platforms, possibly universal environment of Scalfagus, combining sci-fi machinery and whimsical airborne architecture. Exact "all maps must be space platforms" and in-match interplanetary travel remain **unapproved/open**.
