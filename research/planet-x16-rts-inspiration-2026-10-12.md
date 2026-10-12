# Planet X16 — Scalfagus RTS / Retro Pixel Art Reference

Date: 2026-10-12
Status: **owner-requested addition to the Scalfagus inspiration library**. Transfer insights are research/proposals, NOT approval to reproduce Planet X16 art, rules, code, balancing or UI exactly.
Related: [master gameplay inspirations](gameplay-inspirations.md), [faction art direction](../art/faction-art-direction-and-transport-v0.2-2026-10-11.md), [sprite-size/camera](../art/sprite-resolution-and-camera-profile-v0.1.yaml), [five-source-view sprite contract](../art/directional-sprite-five-view-v0.1.yaml), [MAN-only first release](../design/mvp0-man-mirror-rts-2026-10-11.md).

## Source identity and provenance

**Planet X16** is a 2023 retro real-time strategy game by **8-Bit Productions, LLC** for the **Commander X16**, developed by David Murray (The 8-Bit Guy) and contributors, and a spiritual successor to **Planet X3**. The developer's reference guide describes a new program for Commander X16 that reuses some Planet X3 **design and graphics**, **not code**. Do not mistake X16 for an original 1990s game.

Primary sources:
- [Steam official Planet X16 listing](https://store.steampowered.com/app/2727770/Planet_X16/)
- [Official Planet X16 Reference Guide (PDF via Steam CDN)](https://cdn.akamai.steamstatic.com/steam/apps/2727770/manuals/manual.pdf?t=1704058264)
- [The 8-Bit Guy: "This RTS runs on an 8-Bit Computer!" (2023)](https://www.youtube.com/watch?v=HP4ObKlCe6w)
- [Commander X16 project overview](https://www.commanderx16.com/faq.html)

## What to borrow as inspiration, not assets

| Reference insight (verified from official manual) | Original Scalfagus adaptation to investigate | Scope |
| --- | --- | --- |
| Tiny retro RTS sprites stay readable for worker, buildings, mineral piles, vehicles, terrain | Strong silhouettes, clean pixel clusters, distinct faction profiles/limb counts and clearly shaped pickups; maintain Scalfagus **isometric Godot Sprite3D**, 5 source views / 8 sectors | Art/UI, **not a literal X16 pixel grid or palette** |
| Player Builder **physically picks up minerals and drops them beside Smelter**, which processes them | Every visible Matter/Volatiles/cargo packet has a real custodian and visible pickup, drop, belt, drone, vein, Nexus or Obelisk transition according to the already approved faction rules | Existing physical-logistics visualization |
| Solar power station accepts a bounded cluster of panels; gas refinery goes on volcanoes | Make extraction location, production dependencies, Energy generation and power deficits visually distinguishable; no requirement to copy exact panel count, refinery placement or Planet X16's resource list | Economy UX research |
| Single/double/shift click, right-click move/attack, minimap, keyboard shortcuts | Validate unambiguous RTS selection, issue order, selected-unit feedback, minimap and readable action affordances at small resolution | Existing MVP0 HUD/input tests; research only |
| Walls, movable terrain obstacles, sentry tanks that switch drive/sentry modes | Show explicit configuration changes and visual telegraphs for **already approved MAN UMU SENTRY / MOVE**, without importing Planet X16 tank designs or exact abilities | Later MAN variants, keep DEC-040/041 authoritative |
| Cheap fast ATVs versus slower costly heavy tanks; build time and mobility matter | Distinct silhouette/readable speed/power tradeoffs for MAN machines. No import of X16 unit statistics or match timing | Future roster/balance |
| Enemy may clear rock/forest obstacles or bridge rivers in its own tactical context | Terrain should be strategically legible; Scalfagus **all maps are spaceborne platforms** and no unit freely crosses a void edge. Bridge/terrain modifications remain separately-approved future systems | Non-binding comparison |
| Limited retro audiovisual budget creates urgency without excessive VFX | Prioritize readable animation cues: worker starts loading, visible ore packet changes custody, mode transition, attack/range warning. Do not rely on excessive glow/particles to explain state | Art/UX |

## Concrete visual-design checklist for artists and agents

1. **Visual hierarchy at gameplay zoom:** ground silhouette → actor body → one obvious tool/eye/weapon → carried packet → animation/state. If any key signal disappears at 1× zoom, redraw it rather than adding more pixels everywhere.
2. **Cargo visibility:** a resource package must be identifiable *on the actor*, *beside its drop-off*, or *as a packet along the legal logistics route*. Nothing material teleports as an image-only convenience.
3. **Retro discipline without nostalgic tracing:** compact, deliberate pixel clusters; bounded outline/contrast; short clear action sequences. Preserve Scalfagus palette: ORG dark visceral green/pink biological matter, MAN machinery/hazard markings, ETH ivory/indigo/cyan geometry. Planet X16's exact palettes, HUD design, buildings, maps, sprites and icons are **off limits to copy**.
4. **Scalfagus engine contract takes precedence:** existing isometric view, Godot five-direction source/three mirrored presentations and current sprite/camera scale. Do not replace it with Planet X16's top-down renderer or hardware limitations.
5. **Modern luxury:** unlike the Commander X16 constraints, we can afford intentional expressivity and transparent sprites (e.g. ORG TRIPOD exactly 3 tentacles, ETH ORBPOD 3 pairs), physical five-view rotations and clean 20Hz simulation; old-console limitations are an aesthetic lesson, not imposed code architecture.

## Distinctions NOT to import silently

- Planet X16 has **no normal fog of war** in its main view, but radar enables live unit indicators on its minimap. Scalfagus has its own fog, sensor, telemetry and scouting decisions; **no free omniscience**.
- Its manual says early enemy assault commonly starts roughly **9–10 minutes** in. This is **not** a Scalfagus timing target; preserve Scalfagus match-scale/balance and autonomous opponent doctrine.
- Planet X16 is fundamentally **single-player and originally top-down**, whereas Scalfagus intends three autonomous asymmetric factions, multiplayer modes and eventual possession with a distinct renderer.
- The game uses mineral/energy/gas values in its own table; Scalfagus has three physical forms of **Matter / Volatiles / Energy** defined independently. No borrowed prices/unit stats, copied race names or reusing licensed Planet X16 artwork.
- No new dependencies on 8-bit hardware, 6502 CPU, VERA, emulation or Planet X16 code.
- **First playable Scalfagus remains DEC-033 MAN mirror four-template MVP0** (HQ, MIN, Barracks, Rifleman); inspiration does not expand scope into ETH/ORG, more structures, terrain bridging, missiles or a new renderer.

## Suggested design experiments (NOT shipped or tested)

1. Side-by-side at fixed gameplay zoom: Scalfagus worker collecting **one real Matter package** and placing it at a drop-off, versus a deliberately abstract distant version. Measure whether player sees the exact custody transition.
2. Render the same **24×32-ish economic worker** in five canonical source viewpoints (use repo scale/profile rather than hardcoded values) and measure clarity of cargo, identity and valid posture.
3. Prototype UI signals for idle/working/carrying/sentry and compare readability of unit silhouettes with minimal VFX enabled.
4. Walk new players through harvest → finite store → Barracks production → first Rifleman without extraneous tooltips; collect confusion points rather than copying Planet X16's controls verbatim.

**Guiding principle:** Planet X16 teaches "a whole RTS world is legible even with very few pixels"; Scalfagus retains its **original higher-detail 1990s isometric pixel-art fantasy**, finite logistics, geometry, faction color grammar and contemporary Godot features.
