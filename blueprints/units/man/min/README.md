# MAN MIN — worker / basic Manus

**Gameplay (DEC-033 MVP0):** human in a compact ivory pressure suit who moves, extracts finite surface SOLID, physically carries counted Matter to the **own HQ**, and constructs Barracks. No automatic resource creation, flying, combat, or future MAN certification/academy system in this first slice.

**Visual identity:** enlarged round white helmet with blue reflective visor; short human limbs and industrial utility braces; blue pack; restrained orange hazard details. It must remain a **person**, not a bulky robot. 24×32 RGBA reference, foot anchor (12,30), five authored view candidates.

**Animation plan:** idle, 4-frame walk, mining/drilling, carry crate, physical HQ unloading, build/weld, hurt/death. `walk_reference` contains a pose, **not** evidence of a finished walk loop. Overlay physical cargo, sparks and ground shadow without duplicating real quantities.

**QA/blockers:** existing copied sprite atlas is unverified for exact yaw/pivot and is flagged mirror-unsafe. A left-only tool must not teleport to the other physical side. Test worker readability at tiny HUD scale, true collision/LOS and source-to-HQ transfer.

**Authoritative mechanics:** `design/mvp0-agent-implementation-contract.yaml` and `design/mvp0-man-mirror-rts.yaml`. **Art contract:** `art/man-min-isometric-sprite-production-spec-v0.1.md`. Future three academies/nine faculties and equipment do not change this template automatically.
