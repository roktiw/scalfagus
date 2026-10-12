# MAN Command Core — headquarters

**Role:** one completed HQ per side at match start; real receiving port for MIN cargo and sole spendable Matter inventory in first micro-MVP; trains replacement workers. It counts for victory. Geometry is a real **3×3 tile** grounded footprint with exterior access cells; each tile is 2 m in this map (6×6 m total footprint).

**Visual:** retro moon-lander / modular industrial base: ivory-white body, blue enamel panels, orange safety edges, physical ramp, rooftop beacon and antenna. Deep navy doorway must retain the same physical side regardless of camera yaw/mirror.

**Art QA:** existing `man_lander_128x128_unverified_5view.png` is only a concept reference. The repo explicitly says its 5 rows are **not proven rotations**. Make a real consistent five-view atlas and separate hit flash, production indication, building damage and shadow. Door/port positions follow world colliders, NEVER alpha pixels.

**Excluded:** UMU generator/transform modes and Energy grids in MVP0.
