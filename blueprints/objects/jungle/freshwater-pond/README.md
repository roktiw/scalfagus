# Freshwater pond — world obstacle, not resource

**Rule:** fixed water bodies on Verdant Divide are genuine impassable terrain for the ground-only MVP. No pumping, swimming, fishing, liquid-to-Energy conversion or water harvesting. Their gameplay polygon/circle is in the map YAML; the pixel-water graphics are overlays on that shape.

**Visual:** blue-green, relatively quiet surface bordered by brown mud and reeds; tileable shallow wave or reflection animation, shoreline transitions aligned with underlying 3D terrain. Do **not** give pools 5-yaw actor sprites; use terrain materials/masks/tiles instead.

**Pending:** RGBA overlay tiles, animated shimmer strip, shoreline variants, visual/collider fit proof.
