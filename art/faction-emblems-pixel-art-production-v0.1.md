# Scalfagus — Pixel Art Faction Emblems (16 / 32 / 64 px) Production Sheet

Date: 2026-10-11  
Status: **prototype art generated**, candidate variant identities not formally approved. This describes the concrete 3×3 produced icon family, deterministic build process, coordinate regions and next art QA.

## The 3×3 concept translated into real game-size icons

The 2026-10-11 AI reference poster depicts richly shaded badges in three rows **MAN / ETH / ORG**, three variants each. It is valuable art direction but **not** a trustworthy 16px sprite source. This pack contains a fresh programmatically pixel-authored interpretation at actual 16, 32 and 64 pixel grids, without tracing, scaling down, anti-aliased poster cropping or attempting to retain illegible labels.

Order of candidates:  
MAN-01 Open Palm; MAN-02 Constructor Glove; MAN-03 Work Grip.  
ETH-01 Watcher Eye; ETH-02 Radiant Iris; ETH-03 Orbital Eye.  
ORG-01 Chitin Mandibles; ORG-02 Germination Seeds; ORG-03 Spined Maw.

## Native pixel-tier rules

**16×16** (HUD/minimap). One-pixel external contour; 1px key gaps; large continuous blocks and sharply differentiated exterior outline. MAN shows exactly one working hand shape; no micro writing. ETH shows eye and pupil. ORG shows one biological action: paired pincers, 3 seed pods or an open mouth. The triangle red frame must remain visible even without the organic center.

**32×32** (tech tree/build menu). Add finger/knuckle or segmented gauntlet features, ETH iris/ring segments, ORG chitin shell/pod veins/spines. Core outline ~2px; use 2–4 value steps. Every pixel is still hard edged and meaningful.

**64×64** (faction selection/codex). Add secondary material shading, armor seams/orbit features and selective highlights to animate *imagination* without actual glowing gradients. Core strokes 3–4px; optional decorative stars/panels never replace recognizable hand/eye/mandible.

Each tier is independently rasterized from shared geometric primitives with selective threshold-based features at 32 and 64. **It is NOT a high-quality hand-painted master at three resolutions** — this deliberate procedural starting point still deserves a human polish pass.

## Files delivered and atlas indexing

- `assets/faction-emblems/man_01_16.png` etc through `org_03_64.png`: **27 standalone transparent icons**.
- `assets/faction-emblems/faction-emblems-16.png`, `faction-emblems-32.png`, `faction-emblems-64.png`: **three atlases**, of pixel dimensions 48×48, 96×96 and 192×192.
- `assets/faction-emblems/regions.json`: explicit region metadata, counts and identifying records; **X,Y,W,H** coordinates.
- `scripts/build-faction-emblems.mjs`: deterministic, no NPM dependency, Node built-in zlib and fs PNG encoder. Can reproduce all 30 PNG from 1 source.
- `scripts/test-faction-emblems.mjs`: validates PNG signature, alpha, dimensions, atlas region exact equality with standalone icons, nine variants and 3 sizes.

For every native tile size `s ∈ {16,32,64}`:

- Atlas size `3s × 3s`.
- `row = {man:0, eth:1, org:2}[faction]`.
- `column = {01:0, 02:1, 03:2}[variant]`.
- `rect = [column*s, row*s, s, s]`.

Example: `eth.02` at 32×32 is rect **[32,32,32,32]** from `faction-emblems-32.png`. `org.03` at 16×16 is rect **[32,32,16,16]** from `faction-emblems-16.png`.

Godot implementation can use a `Texture2D` atlas and `AtlasTexture.region` set to the region above. The faction emblem is a HUD texture, not a rotating `Sprite3D` directional actor image. Palette/material changes, if later needed, go through generator + regenerated PNGs + manifest version bump.

## Relation to the 3D art renderer

World units/lander/tree/rock use [ADR-0003 five original views and horizontal mirroring](../architecture/adr-0003-five-view-mirrored-3d-sprites.md). Faction iconography is a distinct, **camera-independent UI layer**, and possibly source material for some decals. For a logo appearing on an in-world mirrored building, use an independent correctly oriented decal; never let `flip_h` reverse text or move physical controls/doorways.

## Explicitly unfinished

- **ORG symbol** not ratified: all 3 are candidate identities and MAN/ETH preferred `01` are suggestions, not final artwork.
- Visual legibility on native 320×240 Godot HUD is not yet checked; only PNG structure and pixel sizes are algorithmically checked.
- No Aseprite multilayer source is claimed; generator JS is the editable canonical source for this version.
- Missing palette/color-blind user study, print black-and-white, anti-counterfeit legal checks and faction typeface.
- Design approval must examine hand / eye / arthropod geometry at true native scale before branding freezes.
