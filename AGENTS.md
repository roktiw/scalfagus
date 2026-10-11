# Scalfagus development instructions

- Read [the technical seed](architecture/mono-blue-tech-seed-2026-10-11.md), [approved decisions](design/decisions.yaml), [product principles](design/product-principles.md), and [MVP scope](design/mvp-iso-pixel-rts.md) before editing gameplay files.
- All code, documentation, comments, user-facing design strings, PR summaries and commit messages are in **English**.
- The short faction IDs are `org`, `man`, `eth`. Short names are Organs / Manus / Eters; mid names Organites / Manusians / Etherans; full backronyms are exactly as in `design/faction-naming-conventions-2026-10-11.md`.
- Never silently reintroduce legacy faction keys or four resources. Exactly three primary economic resources: Matter, Volatiles, Energy.
- Do not add mandatory hive minds; preserve independent specialized units.
- All game cameras and control modes MUST act on one authoritative world and the same Hero identity. Overlord / Direct Unit / FPS may not duplicate authoritative health, positions, weapons or inventories.
- Do not claim runtime, art, Godot, pnpm, headless, CI or performance tests were run without proof. This branch is **tooling seed S0**, not the Godot engine spike S1.
- Avoid dependencies until a real need exists; pin versions and inspect provenance/license; no curl-piped-to-shell installers or silently elevated commands.
- Prefer small commits, headless validation, explicit uncertainty and one isolated feature per PR.
- Do not reinterpret the prospect of fourth autonomous machines or fifth faction as approved game content.
