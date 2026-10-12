# Brown jungle soil — tile/material family

**Source:** `design/platform-surface-presets.yaml` = `brown_soil_jungle`; `design/mvp-verdant-divide-map.yaml` = `humid_jungle_soil`. Ground is a real 3D collidable surface with ramps and authored lakes, NOT a second TileMap physics system.

**Visual:** brown fertile earth, moss, sparse fern clusters, small rocks, leafy patches, dry paths and muddy edges. Use a 2:1 32×16 pixel diamond as a **camera-preset art convention**, not a hard-locked projection for freely orbiting 3D cameras.

**Pending:** tileable palette with wet/dry, path, moss and rim transitions; nonblocking prop sprites. Tiny stones and grass **must not** block nav or generate mineable Matter.
