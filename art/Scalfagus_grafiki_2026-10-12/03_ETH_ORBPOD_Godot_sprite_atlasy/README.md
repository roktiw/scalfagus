# ETH ORBPOD — Pixel-art prototype asset bundle

Original, hand-constructed nearest-neighbor indexed-style RGBA sprites as a playable placeholder, inspired by the owner's concept and Scalfagus art canon. Generated concept poster shown in chat is separate from these prototype atlases.

## Asset format
- 24x32 transparent pixels each cell, ground pivot (12,30), shadow separate.
- Five authored yaw rows: front, front-right, right-side, back-right, back.
- Animated columns per action, frame counts and FPS in `eth_orbpod_manifest.json`.
- `idle`, `move`, `carry`, `hide` separate transparent RGBA PNG atlases.
- 8 sectors from 5 views using repo's DEC-017 mirror policy. Review mirror-safety with asymmetric expression/limbs before production.
- Orb central body with **one eye and visible brow** and exactly **three pairs of universal limbs** (six total); poses show ears, grippers and support legs without fixed anatomy.
- Movement domain is GROUND with near-ground hover VFX, not free flight.

## Integration
Import PNGs with nearest filtering and mipmapping tuned for gameplay camera. Use a Sprite3D with the atlas convention in `art/directional-sprite-five-view-v0.1.yaml`. Ground shadow sprite is separate. Use the JSON manifest for action/row/frame metadata.

These are original first-pass **prototype** art sprites intended for QA, **not an approved production asset**. Test at 320x240, and review whether all 6 limbs and eye remain legible. Their style follows repo rules; their exact final palettes, animation timing and collision are subject to art direction approval.
