# Scalfagus — Ready-Made Asset Shortlist: MAN Universal Man Unit (UMU)

**Research date:** 2026-10-12  
**Purpose:** real, currently discoverable third-party 3D art packs suitable for building the owner-designed **UMU**, not generation of new concept art and not authorization to install.  
**Status:** verified **publisher listing/link and visible license claim** for shortlisted sources; downloaded archive contents, model dimensions, individual meshes, import integrity and Godot 4.7.2 compatibility are **NOT inspected**.  
**Agent source:** [machine catalog](umu-ready-made-asset-catalog.yaml), [acceptance and art pipeline](umu-asset-intake-acceptance.yaml), [discussion record](../inbox/2026-10-12-umu-assets-discussion-handoff.md).  
**Current scope:** UMU is **post MAN-mirror MVP0** under DEC-033. Do not add an UMU class or replace the existing HQ/worker/barracks/rifleman templates in the first release.

## Decision: best candidate is NOT a prebuilt vehicle

**Recommended asset sourcing strategy:** use **Kenney Conveyor Kit** for the **two actual transforming belt wings** + **Kenney Factory Kit** for machine body/feeds + **KayKit Space Base Bits** or **Quaternius Modular Sci-Fi Megakit** for the open cabin, armor/rib frames, bunker covers and roof hardpoints. Build one **original Scalfagus physical chassis/rig** in Godot or Blender, then render directional action sprites conforming to DEC-017.

No identified third-party finished model demonstrably contains the exact UMU mechanism (two convertible belt-wings that become **tracks under an open trapezoid cage**, one belt for **warehouse**, both at **3/5-cell conveyor span**, folded body for **bunker**, turned upright for **sentry wall**) **as a licensed ready-to-ship entity**. **Ready-made models here are real component assets, not a magically 100% ready UMU.** Designing/rigging the transform and the five-view pixel art remain essential original art work.

## Ranked verifiable source packs

Scores express qualitative UMU component suitability, **not tested compatibility or real model extraction**. All URLs below refer to original publisher / official Godot Asset Library / original author upload pages, not random repost bundles.

| Priority / source (open link) | What actually exists | UMU application | License seen | Main caveat |
|---|---|---|---|---|
| **A1 — [Kenney Conveyor Kit](https://kenney-assets.itch.io/conveyor-kit)** | **60+** CC0 low-poly models for factory conveyors; publisher lists single texture/color map and an actual ZIP download | The **two wing-belts**; powered belt surface/rails/loader and left/right loading connection | **CC0 1.0**, verified on publisher itch page | No tracked-mode transforms prebuilt; verify meshes are segmentable, model dimensions/pivots and formats after download |
| **A1 — [Kenney Factory Kit 3.0](https://kenney.nl/assets/factory-kit)** | **140** industrial/conveyor/warehouse/factory assets; animation/variations advertised | Machine core, hopper, feeder, fuel intake, equipment housing, warehouse doors, mechanical details | **CC0**, Kenney original page | Static modular building pieces; not necessarily a vehicle or complete UMU rig |
| **A1 — [KayKit Space Base Bits](https://godotengine.org/asset-library/asset/2124)** | **48+** low-poly optimized base/colony items in Godot Asset Library; single gradient texture atlas | Trapezoid open cage framing, shelter/garrison shell, hard-surface machine panels, rooftop foundation | **CC0**, official Godot library listing | Listing created for Godot 4.1, **must test in pinned Godot 4.7.2**; exact useful part names unknown until archive inspection |
| **A2 — [Quaternius Modular Sci-Fi Megakit](https://quaternius.com/packs/modularscifimegakit.html)** | **277** advertised modular sci-fi props/architecture in full pack; OBJ/FBX/glTF; Standard **60–70% free**, full Source tier separate | Original industrial sci-fi body shell, sliding hatches, corridor ribs, armored bunker/wall panels, roof socket | **CC0**, publisher lists commercial reuse | Grid/rooms parts, not real tracked vehicle; **do not assume all 277 models are in free tier** or Source-version Godot scene is free |
| **A2 — [Quaternius Sci-Fi Essentials Kit](https://quaternius.com/packs/scifiessentialskit.html)** | **65** advertised futuristic asset models (crates, screens, guns, animated robots/props); OBJ/FBX/glTF; Standard subset free | Actual visible cargo cubes and racks, display/port props, garrison detail, roof optics | **CC0**, publisher | Props are not a full UMU or guaranteed turret; Standard includes only a subset |
| **A2 — [Kenney City Kit (Industrial)](https://kenney.nl/assets/city-kit-industrial)** | **40** 3D industrial/warehouse models; update includes solar/wind | Original generator silhouette, **solar rooftop visual study**, turbine/industrial refinery appearance | **CC0**, Kenney | Building-scale visuals, must resize/rework for *mounted* equipment; no automatic Energy gameplay |
| **B1 — [Kenney Modular Space Kit](https://kenney.nl/assets/modular-space-kit)** | **40** sci-fi modular station meshes with variants/animation | Replaceable body wall/door/hull segments, armor shell, docking clamps, optional space-deck aesthetics | **CC0**, Kenney | Station kit, not a wheeled/belt machine; too space-station-like unless assembled creatively |
| **B2 — [Kenney Car Kit](https://kenney.nl/assets/car-kit)** | **45** low-poly 3D vehicle models with body/debris variations | **Temporary wheeled transport proxy or wheel geometry studies** for `BUILDING_DRIVE` prototype | **CC0**, Kenney | Owner UMU uses its **two original conveyor wings as tracks**. Do **not** ship separate free-spawned wheels or claim this kit provides folding belt-tracks |
| **B2 — [Low-Poly Tank Assets by pixelmannen](https://opengameart.org/content/low-poly-tank-assets)** | Old small CC0 pack with a low-poly tank and minor props | **Tracked undercarriage visual reference/proxy**; potentially examine mesh topology for modular track appearance | **CC0**, original OpenGameArt author page | Toy/simple tank, unknown mesh separation, no track-to-belt articulation; do not copy recognizable existing game vehicle motifs |

### Additional reference — check before use

**[Sketchfab: Mobile Battery, onzarain](https://sketchfab.com/3d-models/mobile-battery-230a7ef3b5b24a6081074a8ecf0b6fef)** visually resembles the target tracked mobile industrial power infrastructure; however its page explicitly describes another game universe, claims approximately **308k triangles** and does **not visibly grant an open download/license**. It carries a **NoAI** notice. **Reference-only; do not download, duplicate, modify, use for AI image prompts or include in Scalfagus without direct written rights.** A nice-looking picture from a commercial game is NOT a source art license.

**Paid Synty POLYGON Sci-Fi/Construction packs:** real commercial packages exist, but marketplace EULAs, possible asset redistribution/derivative restrictions, price and lack of official Godot support make them **nonpreferred and explicitly unapproved** for the first UMU asset intake. [Synty's publisher FAQ](https://syntystore.com/community/faq) says to check each pack for compatibility and that official support is Unity/Unreal, not Godot. Do not assume paid = shippable Godot meshes.

## Three concrete art assembly proposals from those *real* kits

These are ORIGINAL planned composites, **not claims that a downloaded pack contains that exact assembled model**.

### Option A — Industrial Crawler (strongest first prototype)

**Component supply:** Kenney Conveyor Kit + Factory Kit + KayKit Space Base Bits.  
**Core silhouette:** **narrow rectangular machine core**, two detachable/rotating *identical continuous original belt-wings*, **open front/rear trapezoid cage**, orange-gray hardpoints, blue energy status indicators, **one roof socket**. The same belt mesh becomes an underbody left/right crawler track or a standing belt depending on transform.

Why: directly communicates ownership of the two persistent belt wings and makes all original mechanical poses recognizable at tiny RTS pixel sizes. Factory kit also supplies one-side fuel intake visual and warehouse hopper.

**What still needs hand-authoring:** exact cage-shaped welded frame, two hinged belt arms with 2 extension levels, rigid pivots/joints, mode-transition animation and collision, 3×3 external racks, real 4-passenger room, texture unification, sprite render/QA. **This is our recommended first audition.**

### Option B — Orbital Colony Utility Skid

**Component supply:** Quaternius Modular Sci-Fi Megakit + Kenney Conveyor Kit + Sci-Fi Essentials Kit.  
**Core silhouette:** sci-fi maintenance container/airlock on a physical tracked platform, sealed tool compartments, bright port/status strips and a roof solar/antenna/hardpoint. More technical, factory-colony/spaceborn aesthetic, less cute.

Why: arguably strongest long-term look for large modular MAN bases in a floating-space-platform universe; credible machine can attach to and move entire small/medium/large buildings in 4/6/8 coordinated drive groups.

**Risks:** a fully boxed sci-fi shell easily contradicts the **open front and rear cargo/passenger cage**; need deliberately hollow center. The premium complete Source tier is **optional**, free Standard subset may lack specific frames.

### Option C — Temporary Tracked-Bunker Blockout

**Component supply:** original-author CC0 Low-Poly Tank + Kenney Factory Kit + Conveyor Kit.  
**Core silhouette:** simple tracked low-poly armor cradle with blue/orange generic industrial equipment. Ideal **prototype only** to verify footprint, navigation, rotating/wall colliders and soldier seating in Godot.

Why: fastest *plausibly recognized crawler*. Risk: tracks may be embedded inside one tank mesh, requiring geometry surgery; placeholder can easily bias final design toward "tank with panels", not the two original transformed belt-wings.

## Non-negotiable UMU model and animation acceptance (DEC-040 / 041 / 042)

| Rig state / role | Physical sprite/mesh pose | Port / collision / economy result |
|---|---|---|
| **MOVE** | Both **same** actual belt-wings fold underneath as two crawler tracks; cage open fore and aft. | Carries actual **4 soldiers OR 27 mixed cargo OR 45 mono cargo**; one driver/AI if authorized; no live warehouse, conveyor, generator or bunker role |
| **WAREHOUSE** | One physically deployed wing (player chooses LEFT or RIGHT), other folded. | Single open load/dispatch port; real finite 27/45 manifest with physical packets; no through-conveyor nor free power |
| **CONVEYOR-3** | Both wings extend symmetrically 1 cell each around 1-cell core. | Real 3-cell corridor, finite packet flow; no simultaneous bunker or generator |
| **CONVEYOR-5** | Both wings extend symmetrically 2 cells each around 1-cell core. | Real 5-cell corridor, not a free extra wing; collision/path occupancy changes legally |
| **BUNKER** | Wings fold against hull sides, shields/weapon emplacements visible if equipped. | Real defense/garrison only; no ghost garrisoned units or automatic full-power warehouse |
| **SENTRY_WALL** | Both physical belts **rotate upright** as impassable wall. | Blocks allied AND enemy ground passage; active haul ports closed; no free turret |
| **POWER_GENERATOR** | Stationary and one real inlet feeder as proposed; fuel gauge/vent, roof turbine/solar when equipped. | Consume real eligible input and generate **accounted Energy**. Passive solar when MOVE/BUNKER prohibited |
| **HARVEST** | Stationary rooftop drill/pump/collector operating into finite output buffer. | Does not double as free generator/warehouse/conveyor |
| **BUILDING_DRIVE** | Same tracked units dock beneath a real building: **4 / 6 / 8** for S/M/L. | All mounted UMU locked to the exclusive drive job, one convoy motion order; no extra wheel entities |

**Crucial:** candidates like a ready-made "generator" or "tank" do not satisfy this list simply because their texture suggests it. The functional rig, exclusive state enum, resource accounting and authoritative Godot collision are ORIGINAL Scalfagus code. External models supply art only.

## Godot 4.7.2 + 5-view-pixel art conversion recommendation

The user-approved renderer uses **five authored azimuth views** (front, front-right, right, back-right, back) and mirrors to eight displayed sectors. The prototype/game uses Sprite3D over actual 3D terrain/physics. Most recommended assets are **3D**, not ready 5-row sprite PNG atlases.

**Recommended offline source-to-sprite route:**

1. **Stage/quarantine archive** without writing it to current shipping `apps/game/assets`. Record publisher page, per-pack CC0 evidence, file hashes and actual archive file formats/mesh counts. Download only after asset selection approval; do not auto-import unreviewed marketplace assets in CI.
2. In an **asset authoring tool** (Blender or vetted Godot editor import), construct a prototype **single physical UMU rig** with named sub-objects: `core`, `belt_wing_left`, `belt_wing_right`, `open_cage`, `roof_socket`, optional `mono_rack_left/right`, garrison doors, intake, ports. Every mode transforms **the same** wings, not separate unrelated clip-art silhouettes.
3. Export primitive portable model as **glTF 2.0 (.glb/.gltf) when source supports it**, or convert original OBJ/FBX to glTF. Keep original author license/source/transform data alongside derived sprites. Do not rely on Godot-specific Source-tier projects being included in free Standard.
4. Position fixed orthographic cameras with five azimuths and consistent lighting/pivot/texture filtering. Render original **transparent RGBA** frames for each meaningful pose/action; build one action atlas as 5 vertically stacked facing rows and N horizontal frames (per DEC-017). Example **candidate frame** `128×96` for a larger UMU base; extended `CONVEYOR-5` may need a **wider view box**. **Not a finalized art dimension.**
5. Test all eight displayed sectors: important off-center **loading door/side-selected warehouse belt cannot magically flip to the wrong real-world side**. Prefer mirrored-safe geometry, world-anchored overlays for asymmetric equipment, or obtain owner-approved separately authored view exceptions. Actor 3D collision/ports must **never follow a Sprite3D horizontal flip**.
6. Use separate world-anchored physical packets, transform pivot animation markers and LOD; atlases are a **rendering** output, not the transport mechanic. Compare at 320×240 and 640×360 without losing recognizable 3-cell/5-cell and folded/upright states.
7. Keep **Godot one world** authority; future FPP possession should reuse the same entity/rig and real collision, not a new game/physics state. A 3D source rig may support 3D close-up as a later option; does not automatically change the current sprite rendering contract.

### Proposed first visual PoC acceptance

A0 **Legal/asset intake**: 3 top pack ZIPs archived locally (not in committed root), CC0 texts/hash and visual parts inspected; 3D glTF import into Godot 4.7.2; no missing textures or owner-IP reuse.  
A1 **Static silhouette**: one original UMU on the Verdant Divide floor, two distinct belt-wings and open trapezoid cage, with a roof socket and **exactly four real seat placeholders**.  
A2 **Five postures**: MOVE, WAREHOUSE, CONVEYOR-3, CONVEYOR-5, BUNKER, SENTRY_WALL (two conveyor lengths count as two states of one job); 8 camera sectors legible.  
A3 **Expansion mode mockups**: POWER_GENERATOR with physically consuming item feed, HARVEST roof tool, BUILDING_DRIVE with 4/6/8 real UMU; do not imply these can run simultaneously.  
A4 **Approval**: art/geometry/collision/checksum/source/license review, 5-view Sprite3D atlas import, no missing transform pose, no UMU creep into DEC-033 MVP0.

## Licensing, provenance and asset acquisition rules

- First preference: **original publisher CC0 sources** (Kenney, KayKit, Quaternius) with per-pack license. CC0 permits commercial use and derivatives; voluntary credits may be added. **Do not assume a random mirror/repost inherits proper rights from a copied file.**
- Don't use images of existing copyrighted RTS/fantasy games, screenshots, movies or unlicensed Sketchfab models as mesh/sprite sources. A game-inspiration image is not a downloadable commercial license.
- Paid Source kits may have different **file entitlement** despite the CC0 license on delivered meshes; label **free subset** versus **full source kit** and inspect after purchase/consent, no invented pricing.
- Note **rights for textures and shaders individually** if delivered under separate license; verify what actual ZIP includes.
- Cite exact original pack/version/page, download date, file hash, source text and derived transform recipe in an internal manifest before a licensed asset is committed.
- No asset-pack auto-download in game runtime. No network telemetry dependencies, executables or bundled scripts from a creative asset source unless independently security-reviewed.
- If an external pack duplicates recognizable proprietary IP, remove those pieces even where package label says free.

## Decision and next steps

**Recommend Option A (Industrial Crawler)** built with **Kenney Conveyor Kit + Factory Kit + KayKit Space Base Bits**. Quaternius Modular Sci-Fi Megakit is a **strong visual alternate**, ideal to prototype separately for an industrial sci-fi enclosed-deck aesthetic. Reserve the CC0 tank as an **underbody proxy only**.

**This research delivery only writes designs and source links.** No externally downloaded zip/mesh, license file, generated sprite, Godot scene, pack installation, PR merge or gameplay code was created by this task. The user may now select the first composition for a real art and rig PoC in a **separate explicit step**, without accidentally changing first MVP0 scope.

### Primary publisher references (viewed 2026-10-12)

- Kenney Conveyor Kit: https://kenney-assets.itch.io/conveyor-kit
- Kenney Factory Kit: https://kenney.nl/assets/factory-kit
- KayKit Space Base Bits (official Godot Asset Library): https://godotengine.org/asset-library/asset/2124
- Quaternius Modular Sci-Fi Megakit: https://quaternius.com/packs/modularscifimegakit.html
- Quaternius Sci-Fi Essentials Kit: https://quaternius.com/packs/scifiessentialskit.html
- Kenney City Kit Industrial: https://kenney.nl/assets/city-kit-industrial
- Kenney Modular Space Kit: https://kenney.nl/assets/modular-space-kit
- Kenney Car Kit: https://kenney.nl/assets/car-kit
- Low-Poly Tank Assets (CC0, original author pixelmannen): https://opengameart.org/content/low-poly-tank-assets
- Licensing caution, Sketchfab non-open Mobile Battery: https://sketchfab.com/3d-models/mobile-battery-230a7ef3b5b24a6081074a8ecf0b6fef
- Marketplace caution, Synty FAQ: https://syntystore.com/community/faq
