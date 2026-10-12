# Giant living jungle tree — tactical cover

**Rule:** fixed individual trees in Verdant Divide block **ground paths and LOS/shots with their trunks**, but leaves have no independent hitbox. They are not mineable Matter; the canopy should fade when it hides selected friendly units without affecting combat LOS/fog. The map declares 10 fixed cover instances with explicit trunk/canopy radii.

**Visual:** dense broad tropical canopy with moss, long woody roots and a thick dark-brown trunk; saturated jungle foliage is still darker than the white-blue MAN units. Retro crisp, no blurry filter.

**Production:** existing `neutral_tree_40x64_5view.png` is a simple procedural placeholder; make a proper trunk+canopy layered source/atlas and validate camera fade as a separate visual effect. Do **not** regenerate navigation from sprite opacity.
