# Scalfagus — Faction UI Iconography Contract v0.1

Date: 2026-10-11  
Status: **authoritative category geometry requested by owner; nine actual mark variants remain exploratory.** This is a *proposed UI styleguide*, not user testing or completed accessibility certification.

## Heraldic invariant

| ID | Canonical faction short/mid | Outer boundary | Inner shape | Meaning |
|---|---|---|---|---|
| `man` | Manus / Manusians | **Square** | **Human working hand** | Making, agency, industry, modularity |
| `eth` | Eters / Etherans | **Circle** | **An eye** | Awareness, knowledge, vision, resonance |
| `org` | Organs / Organites | **Triangle** | **Open candidate: mandibles / germinating larvae / spined maw** | Adaptation, organic reproduction, predation |

Names follow [faction naming canon](../design/faction-naming-conventions-2026-10-11.md). The hand must look human rather than like a robotic grappling claw; the eye must still look like an eye rather than any generic filled disk; the triangle must not suggest that every ORG organism is an amorphous blob.

### Three variants in each identity

- **MAN 01**: open palm with orange node (best **UI default candidate**); **MAN 02**: construction glove; **MAN 03**: tool-gripping fist with angular orange streak.
- **ETH 01**: watchful blue eye with gold compass accents (best **UI default candidate**); **ETH 02**: iris/lens; **ETH 03**: eye crossed by orbital ring.
- **ORG 01**: two ivory mandibles and growth core (**suggested** visual default, *not owner-approved*); **ORG 02**: three linked germination pods; **ORG 03**: vertical spined arthropod maw.

These alternatives are not three separate sub-factions. They are visual explorations of **the same faction emblem**. The assistant recommends `01` for each in internal mockups, but **only the outer geometry and MAN/ETH motif categories are settled**. ORG still requires an owner choice.

## Identity, function, and game state are different layers

1. **Faction identity** belongs in the icon silhouette (square / circle / triangle + hand / eye / organic motif). This is immutable regardless of health, selection or current unit activity.
2. **Role or action** uses its own icon adjacent to the emblem (drill = construction, crate = cargo, crosshair = attack, gear = machine, path = logistics). Do not put miniature tools inside the primary 16x16 heraldry.
3. **Status** is external: thin HUD outline, progress ring, low-health pip, warning triangle, cooldown fill, team outline. Never turn the base faction icon green/red to mean selected/dead; keep an accessible label or shape indicator.
4. **Player/team** is an outline, corner pip or adjacent swatch; the same faction can have two opposing teams without replacing its core identity. Do not confuse team palette with faction palette.
5. **Selection on terrain** follows faction grammar as an *optional visual overlay*, but true world-space collision/selection is still calculated from the 3D object, not emblem or sprite alpha. MAN square ground cell projects to an angled diamond under the chosen camera.

### Canvas sizes and practical UI deployments

| Native raster | Typical use | Content budget | Guidance |
|---|---|---|---|
| **16×16** | minimap legend, unit card mini-badge, resource ownership, status list | outer silhouette + **one** center motif | No text, no microscopic highlights; 1px strokes/gaps minimum; avoid 1px floating details at noisy backgrounds; make shape visible in grayscale |
| **32×32** | build menu, squad banner, command selection, tech nodes | center motif and 1–2 secondary features | 2px major strokes; no thin streaks mistaken for damage; no fake semantically meaningful text |
| **64×64** | faction selection, codex, diplomacy portrait, tech/campaign header | textured linework, materials and atmospheric highlights | 3–4px major strokes; add decorative jewelry/armor cautiously; silhouette must match smaller tiers |

Sprites at all three sizes are **individually rasterized from shared geometric rules**, with selective detail only at 32/64. They are **not the big AI poster scaled down and not a smooth-resampled master**. Source pack: `assets/faction-emblems/`; deterministic builder `scripts/build-faction-emblems.mjs`.

## Pixel-art and color behavior

- Native 16/32/64 icons, RGBA PNG with **transparent background**. Use nearest-neighbor only for intentional integer-multiple previews; never interpolate bilinearly into soft edges. Magenta is acceptable in a debugging *preview*, never as runtime chroma key.
- Dark outline, clear bright center, spare 3–5 color ramps per material; reduce palette and internal strokes toward 16px. The color family supports recognition, but each faction must remain identifiable in monochrome and for color-deficient players by geometric boundary **and** center silhouette.
- Never depend on a particular palette for gameplay correctness, and do not use rapid blinking/glowing pulsing for the base emblem. Animation can be used for a larger HUD/status-specific effect outside the identity pixels.
- Text `MAN`, `ETH`, `ORG` is metadata / UI label placed **outside** the glyph if space permits; not painted into 16×16 pixels or mirrored in world-space billboards.
- HUD panel background must provide high contrast for both dark outlines and white/cyan/red highlight masses. If icon is laid on top of an image, use an external neutral dark plate, not opaque black painted inside an RGBA asset.
- Icons should remain understandable when rendered at native size on the actual **320×240**, **640×320** and **640×360** game viewports. Test at ordinary scene luminance and on a noisy battlefield, not exclusively black preview.
- Place emblem UV coordinates on pixel boundaries. Godot UI uses a `TextureRect` / `AtlasTexture` region or source `AtlasTexture`, with nearest texture filtering; do **not** feed heraldry through `DirectionalSprite5` (five directional actor art is unrelated to flat UI icons).
- Maintain icon padding / safe area: at least 1px (16), 2px (32), 4px (64) when possible; intentional optically balanced gold stars/spines may approach but must not clip the atlas region.
- Keep original source/license/provenance in asset metadata and credit records; icon generator output is programmatic original art guided by this project's own concept sheet, not traced franchise art.

## Behavior in each game camera

- **Overlord RTS**: native 16x16 badge for sidebar/minimap, 32x32 for building/selected faction panel; identical icon for the entity in any perspective.
- **Direct/TPP**: optional 16x16 badge beside selected actor’s skill bar; keep main avatar visible, do not replace actor sprites with flat logos.
- **FPP possession**: small emblem on HUD/faction indicator or an optional separate decal on equipment. If drawn as a decal on the in-world astronaut, it must respect handedness and flipping; prefer symmetric placement, a two-sided badge, or anchored overlay. Do not mirror text or functional attachments.

## Accessibility and QA acceptance

1. Given three grayscale 16x16 symbols without their names, identify the **square/hand**, **circle/eye**, and **triangle/organic** categories.
2. All nine 16x16 variants pass a native-size raster preview on 320x240 game HUD with normal UI scaling; at minimum each remains distinguishable from the other two factions. Minor same-faction variant differences may be subtle and that's okay because variants are not gameplay identities.
3. `MAN` still reads as working hand even without orange; `ETH` eye even without cyan; `ORG` mandibles/larva/maw even without red.
4. Transparent PNG, no anti-alias haze/diagonal filtered fringes; correct 3×3 atlas regions and correct faction/variant mapping for each resolution.
5. External status/selection/team overlay does not alter or cover key inner motif.
6. `ORG-01`, `ORG-02`, `ORG-03` remain alternative symbols until owner chooses; the sprite generator must not silently mark any canonical.
7. No false production claim: these PNGs are **pixel-constructed prototype icons** not a completed approved style, no visual approval at Godot 320x240 yet.

Related: [YAML registry](faction-emblems-v0.1.yaml), [pixel production sheet](faction-emblems-pixel-art-production-v0.1.md), [DEC-017 directional world renderer](../architecture/adr-0003-five-view-mirrored-3d-sprites.md).
