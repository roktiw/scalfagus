# Scalfagus — canonical object blueprints v0.1

**Purpose:** one discoverable folder per unit, building, neutral object, world element, map or standalone art asset. Every object folder has **`README.md`, `blueprint.yaml` and `assets/`** (the latter contains `README.md`, and actual media when available). All text and metadata are in English (DEC-006).

This is an **authoring and art handoff catalog**, not a new authoritative simulation database. Blueprint files must not replace the active `design/` rule YAML, map manifest or Godot runtime. Compilers/loaders must resolve and validate these references before using anything for gameplay. A documented draft is not proof of implemented behavior.

## Authority and release scope

1. Latest owner-approved decisions: `design/decisions.yaml`, especially DEC-017 (five authored views), DEC-030 (floating platforms), DEC-033 (first MAN mirror MVP).
2. MVP0 executable scope: `design/mvp0-man-mirror-rts.yaml`; candidate runtime numbers: `design/mvp0-agent-implementation-contract.yaml` (not owner-approved balance).
3. World: `design/world-environments.yaml`, `design/world-topologies.yaml`, `design/battlefield-frames.yaml`, `design/platform-surface-presets.yaml` and `design/mvp-verdant-divide-map.yaml`.
4. Art: `art/directional-sprite-five-view-v0.1.yaml`, `art/sprite-resolution-and-camera-profile-v0.1.yaml`, `art/man-min-isometric-sprite-production-spec-v0.1.md`, `apps/game/assets/manifest.json`.
5. A blueprint is an *index and proposed visual production contract* referencing those authorities. New art does not create new resources, units, collision, rules or economic effects.

**First playable**: MAN Command Core, MAN MIN, MAN Barracks, MAN Rifleman; Verdant Divide jungle on a static spaceborne platform. No UMU, ETH, ORG, extra faction machinery, Energy economy, swimming, FPS or TPP in DEC-033 MVP0.

## Directory convention

```text
blueprints/
  README.md
  registry.yaml                  # discovery/index, not a runtime roster
  schema.yaml                    # blueprint schema/authoring conventions
  _template/
    README.md
    blueprint.yaml
    assets/
      README.md
  units/man/min/
    README.md                    # lore, silhouette, behavior, art QA, exceptions
    blueprint.yaml               # typed identity, refs, geometry, render, assets
    assets/
      README.md                  # provenance and approval status per file
      ...png                     # native source/atlas where actually available
  buildings/man/command-core/...
  objects/jungle/giant-tree/...
  maps/verdant-divide/...
  art-assets/man-min-idle/...
```

## Object types

`unit` = mobile controllable actor; `building` = completed structure / victory entity; `cover` = world obstacle with authored gameplay colliders; `resource_node` = finite mineable physical source; `liquid_body` = authored unharvestable water; `terrain` = surface appearance, not independent collision; `world_frame` = mandatory visible floating deck / noninteractive backdrop; `map` = authored placement manifest; `art_asset` = reusable visual asset record, which **never spawns an extra game entity**.

## Pixel-art production rules (retro 1990s RTS)

- Refer to the existing approved artistic direction: pale ivory worker suits, deep navy-blue visors, blue industrial panels and orange hazard details, plus brown loam and verdant jungle foliage.
- 2:1 dimetric tile convention: **32×16 px**, optional detailed 64×32. Godot world is true 3D; pixel projection is only a rendering convention.
- Canonical directional prototype: **5 painted yaw rows** [front, front_right, right_side, back_right, back] and runtime sector indices **[0,1,2,3,4,3,2,1]** with horizontal mirroring in the last three sectors. One actual actor/world/collision; Sprite3D textures are visual only.
- Animated atlas: columns = time frames, rows = 5 authored angles; transparent RGBA, nearest-neighbor, no background baked into sprites, stable bottom-center feet and dedicated world-anchored shadows/selection overlays.
- Mirror-safe flags require an art review: doors, lettering, asymmetric weapons, cargo ports and tools cannot change physical sides when a sprite flips.
- Concept sheets and existing copied prototypes are **NOT shipping-qualified**. Do not just crop/compress the conversation concept poster and call it a finished transparent, registered five-view atlas.
- Every imported asset records origin, license, original source and SHA-256 after production; real Godot/visual QA is required before changing `lifecycle` to `validated`.

## How to add an object

Copy `_template/` to one path under the correct class, fill the `README.md` and `blueprint.yaml`, place media in `assets/`, record license/provenance, add the object to `registry.yaml`, link back to existing gameplay/world authority, and test visual fidelity in **320×240 and 640×360**. Never silently upgrade a proposed aesthetic to owner-approved lore or a prototype atlas to final production art. The runtime importer must not scan these folders as playable entities by default.

## Maps versus reusable object templates

`maps/verdant-divide/blueprint.yaml` indexes the one source map; positions, source amounts, shapes and stable instance IDs continue to live exclusively in `design/mvp-verdant-divide-map.yaml`. Reusable `giant-tree`, `surface-rock` etc. blueprints specify visuals and interaction categories, not a second conflicting set of map coordinates. Seeded decorative plants can change appearance but not collisions, route geometry or state hashes.

## Remaining art work (explicit)

Existing MAN worker, lander, tree and rock atlases are copied from `apps/game/assets` as **prototype references only** (Git blobs reused, no independent licensed pack). Rifleman, Barracks, actual deadwood/pond/soil/rim atlases and fully validated 5-angle rotations are still pending. The new MAN × Jungle concept composition generated in conversation is a **reference**, not an independently cut or imported sprite atlas and is **not embedded in this change**. Add it only with a proper source file and approval/provenance record.
