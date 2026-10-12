# Scalfagus — Discussion handoff and the first ready-made art search: MAN UMU

**Date:** 2026-10-12  
**Status:** curated record of available conversation and currently committed design decisions; **not a verbatim chat transcript**. Previous messages were long and distributed across multiple discussions. We preserve their meanings with links to owner-approved decision specs, rather than inventing exact missing quotations.  
**Current request (Polish):** "Zapisz dyskusje do repo. Przygotuj nowe propozycje gotowych asset ów do gry. Zacznij od assetow umu".  
**Deliverables:** [ready-made UMU pack shortlist](../art/umu-ready-made-asset-shortlist-2026-10-12.md), [machine-readable asset candidates](../art/umu-ready-made-asset-catalog.yaml), [UMU asset intake/validation plan](../art/umu-asset-intake-acceptance.yaml).

## What this discussion and previous related game-design exchanges established

### Faction identities and one physically finite world

Scalfagus is one RTS universe with three sharply asymmetric civilizations:
- **ORG**, biological life, growth, veins/nutrient network, consumption/assimilation and irreversible mutations. Living buildings must be vein-connected and require real metabolism/nourishment. Its original fantasy includes biological superstructures and irreversible fusion.
- **MAN** (Manusians), human engineers and autonomous machine industry: modular logistics, physically carried packets, independent small outposts, separated physical Matter vs power/data services, mobile industrial infrastructure, crews and/or built-in AI, vehicles and eventual combiners/meta-mechs.
- **ETH**, resonance/ether civilization: a single unified information/typed resources/Energy network, Pylon/Obelisk nodes and an authoritative Nexus converting incoming *physical* resources into conserved typed Ether. Cutting links divides existing inventory, never clones it.

Wallet economic types are Matter, Volatiles, Energy; source deposit forms SOLID, LIQUID, GAS are **separate concepts** (DEC-001, DEC-016, DEC-021). Later owner direction intentionally makes each faction weakest at harvesting its most important phase-specific physical source form: ORG early SOLID, MAN mid LIQUID, ETH late GAS (see `design/resource-balance.yaml`). Energy production/conversion and all building/transport resource transfers must remain finite and attributable. Unit/building losses create physical packages (MAN cubes, ETH orbs, ORG tetrahedra) and possible partial recovery; infinite recycling loops are not allowed. Ordinary match victory is elimination of all enemy **completed living building-class entities**, including mobile buildings; surviving workers and ordinary soldiers do not block victory (DEC-022–024).

### The world and staged implementation scope

All playable maps are bounded flat-ish **floating platforms in outer space**, including brown-soil jungle and patchwork-metal deck variants (DEC-030). First `Verdant Divide` contains tree trunk cover, real nonharvestable ponds and finite solid sources. Game uses native Godot, one world/entity-state, directional 5-source-view mirrored sprites (DEC-017) with real 3D collision.

**DEC-033 supersedes old MAN–ETH-first MVP plans for release 0.1:** first shippable slice is 2×MAN slots, 4 MAN templates (HQ, MIN, Barracks, Rifleman), solid→Matter, RTS-only, H-H LAN, H-C, C-C accelerated/self-play. No UMU is in the current release. Dec-031 reserves future RTS and first-person *possession* as two gameplay views. DEC-034 requires reuse of existing code/Godot built-ins and license-reviewed third-party resources before bespoke generic modules.

### UMU concept evolution — current owner-approved laws

The earliest Power Dock/Power Bastion sketch combined energy, cargo and bunker/mobile cover; subsequent owner instructions transformed the idea into a **reconfigurable physical machine**, not an omnifunctional building that runs every mode at once. The authoritative latest UMU spec supersedes older simplified examples:

- **DEC-040:** every UMU has **two physical, persistent conveyor-belt wings**. MOVE: wings fold **under** an **open front/rear trapezoid cage** as tracked undercarriage; WAREHOUSE: **one** belt wing opens to load/unload, the opposite folded; CONVEYOR: both wings extend 1+1+1=3 or 2+1+2=5 axial cells; BUNKER: wings fold along side hull as shielding; SENTRY_WALL: wings turn **up** as an actual movement-blocking wall. No magical replacement asset per mode.
- **DEC-041:** one and only one **active operational role** per UMU at a time. New POWER_GENERATOR physically **consumes valid delivered fuel packets** to generate finite existing Energy; a roof solar panel must explicitly select the generator role, not passively generate while driving or defending. A real roof-mounted turret, drilling rig, pump, gas collector, battery, radar or solar module is a candidate equipment family rather than all always-active perks. **BUILDING_DRIVE** lets **4 UMU move a small building, 6 a medium and 8 a large** as actually mounted wheel/track units. The expansion of acronym UMU remains unselected; `Universal Man Unit` is the legacy canonical label and `Universal Modular Unit` is an unratified candidate.
- **DEC-042:** role/cargo exclusive: **4 actual soldiers** OR **27 mixed cargo units** in a visibly physical 3×3×3 internal cage OR **45 same-resource cargo units** (27 inside + two 3×3 external 9-slot racks). The racks must have legal swept geometry for the transforming belts. UMU is a **light versatile generalist**; dedicated specialist machines must outperform it at their respective single jobs. A bunker garrison is a separate equipment/balance question, not automatically four mobile passenger seats.
- **DEC-043–046:** MAN has qualified human professions, academies, nine candidate machine families, crew or autonomous AI and future recombination/megachassis. These are future world design and not a need for an extra UMU at present.

Source documents:
- [Transforming belt wings](../design/man-umu-transforming-belt-wings-2026-10-12.md) / [YAML](../design/man-umu-transforming-belt-wings.yaml)
- [Power, moving buildings and roof modules](../design/man-umu-power-building-mobility-roof-modules-2026-10-12.md) / [YAML](../design/man-umu-power-building-mobility-roof-modules.yaml)
- [Capacity and specialist balance](../design/man-umu-capacity-and-specialist-balance-2026-10-12.md) / [YAML](../design/man-umu-capacity-and-specialist-balance.yaml)
- [Machine autonomy](../design/man-nine-machines-crews-and-autonomy-2026-10-12.md) and [future combining](../design/man-machine-recombination-meta-mechs-titans-2026-10-12.md)
- [Art direction](../art/faction-art-direction-and-transport-v0.2-2026-10-11.md), [sprite rendering](../art/directional-sprite-five-view-v0.1.yaml), [asset style/scale](../art/sprite-resolution-and-camera-profile-v0.1.yaml)

## New 2026-10-12 direction: ready-made assets first, begin with UMU

The user requests **new proposals for real, existing third-party art assets**, rather than more speculative UMU lore or immediate UMU feature implementation. The audit searches publicly discoverable, licensable **existing 3D models/kits** first; candidate sources must be checked for legal commercial-game reuse, available file formats, provenance, suitability for both 3D Godot and conversion into Scalfagus's 5-direction Sprite3D presentation, and ability to animate exactly **two original persistent transforming wings**.

### Outcome

No externally listed **ready-to-import complete UMU** with the exact owner-approved wing transformation, open cage, conveyor reach, rack geometry and every exclusive job was substantiated by this search. **Do not describe generic trucks/industrial models as already implementing UMU**. Instead, use approved **CC0 component kits** to assemble the original UMU chassis in Godot/Blender and generate 5 directional frames from a deterministic model/rig. Best initial components:
1. **Kenney Factory Kit 3.0** — newer **completely remade/renamed Conveyor Kit**, 140 industrial/factory/conveyor models; **primary audition for two belt-wing pieces** (CC0).
2. **Kenney Conveyor Kit (legacy)** — older publisher-hosted 60+ models, now an **optional belt-parts fallback** rather than an independently mandatory kit. [Kenney's own developer changelog](https://kenney.itch.io/kenney-game-assets/devlog/1526460/update-version-35) explicitly says Factory Kit replaced Conveyor Kit as a complete remake.
3. **KayKit Space Base Bits** — Godot Asset Library native-suitable hard-surface base building/colony props (48+ models, CC0), check Godot 4.7.2 compatibility.
4. **Quaternius Modular Sci-Fi Megakit** — multiple modular bulkheads, frames, shutters, hatches and cabin/roof panel pieces (277 items advertised in full kit; 60–70% free Standard tier, CC0 for included material; glTF/OBJ/FBX).
5. **Quaternius Sci-Fi Essentials Kit** — physical crates, screens and equipment props (65 models advertised in full kit, 60–70% free Standard, CC0).
6. **Kenney City Kit (Industrial)** — roof power plant / solar / industrial visual pieces, CC0 (40).
7. **Kenney Modular Space Kit** — modular sci-fi shell/rim panels, CC0 (40).
8. **Kenney Car Kit** / **CC0 low-poly tank assets from OpenGameArt** — wheel/track **proxy research only**, **not** finished persistent transforming wing tracks.

These are **third-party asset recommendations only**; no pack has been downloaded, installed, bundled into Scalfagus, accepted for shipping, or tested through Godot in this research task. The detailed component adoption and legal/visual validation gates live in the new Markdown/YAML art files above.

## Next workflow for the agent, once explicitly requested

1. Acquire an approved CC0 pack to a **quarantine or staging directory**; verify actual license inside ZIP, file inventory, texture references, source URL and hashes; do not replace existing licensed sprites.
2. Prototype **one original UMU** assembled from source kit parts: main body + two separate belt wings + front/rear open cage + roof socket. No extra gameplay skills. Validate shape readability in all five camera bearings, and hold one persistent entity while each mode changes.
3. Demonstrate only **MOVE / WAREHOUSE / CONVEYOR / BUNKER / SENTRY_WALL** visual postures first. Extend isolated **POWER_GENERATOR / BUILDING_DRIVE** equipment after existing core poses pass. Keep all CPU-intensive meshes for non-RTS debug/LOD if desired; the gameplay art contract prefers actual 5-row Sprite3D captures.
4. Add finite collision/sweep and animation/port tests before committing a shippable asset manifest. Clean all pack sources, no mirrored asymmetric functional port; record legal licenses without depending on public websites at runtime.
5. **Do not modify current MAN-mirror MVP0 roster by default**. UMU is a future economic/machine milestone until owner explicitly changes release scope.

## Open questions deliberately not promoted to approved canon

- Whether `Universal Modular Unit` replaces `Universal Man Unit`, and exact UMU MID/MAX representation or tier.
- Which specific ready-made model or art direction the owner likes best; no package approved/downloaded yet.
- Which real-world fuel recipes, rooftop modules, role-change duration, explosion/damage ejection, track speed and payload physics to balance.
- Sprite size, texture atlas export, rig animation budget and final pipeline remain to be validated on target Godot.
- Whether commercial packs with narrower marketplace licenses should even enter the asset shortlist. Current default is **clean CC0** with explicit provenance.

**Recording convention:** narrative above is a reasoned handoff based on available chat context and linked repo designs, not a fabricated complete verbatim chat dump.
