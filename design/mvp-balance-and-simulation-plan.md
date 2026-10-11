# Scalfagus — Future MAN–ETH Balance Study and Headless Simulation Plan

> **Current DEC-033 micro-MVP first:** MAN mirror, four templates, Matter only, no Energy/Pylons/UMU/FPP. This file concerns the **next MAN–ETH five-role milestone** only. Current [MVP0 contract](mvp0-agent-implementation-contract.yaml), [headless plan](godot-headless-balance-lab-2026-10-11.md) and [current mechanics audit](mvp-repository-mechanics-audit-2026-10-11.md) take precedence. Do not use this document to tune first-release MAN mirror prices.

> **Current release scope reconciliation — DEC-033 (2026-10-11):** MAN vs ETH three-form extraction and network balance for a POST-MVP0 milestone. First release under DEC-033 is MAN vs MAN with four templates and no Energy, UMU, ETH or FPP. Use micro balance YAML.
>
> **CURRENT owner-approved executable release: [DEC-033](decisions.yaml), [MAN mirror scope](mvp0-man-mirror-rts-2026-10-11.md), [active numerical profile](mvp0-man-mirror-balance-v0.1.yaml), [Godot execution rules](mvp0-man-mirror-execution-contract.md), [Godot ENet authority](mvp0-man-mirror-network.yaml), [M0 backlog](mvp0-man-mirror-backlog.yaml), [M0 acceptance](mvp0-man-mirror-acceptance.yaml).**


Date: 2026-10-11
Status: **analytically checked candidate values, NOT a measured or final balanced game**.
Actual numerical profile: [mvp-balance-playtest-v0.1.yaml](mvp-balance-playtest-v0.1.yaml).
Tests/thresholds: [mvp-balance-acceptance.yaml](mvp-balance-acceptance.yaml). Execution: [gameplay contract](mvp-gameplay-execution-contract.md), [network runtime](mvp-network-execution.yaml).

## 1. Fundamental owner-approved anti-synergy in full three-faction RTS

**Do not confuse physical-source forms SOLID/LIQUID/GAS with the stored/spendable currencies Matter/Volatiles/Energy.** The player wants the race which **needs most** of a source-form in its characteristic phase to have the **worst extraction** of that form, and the race that needs it **least** to be **best** at taking it away from competitors. This encourages denial, raiding, opportunistic extraction and trading space for tech. Access gates remain unchanged: raw SOLID pickup needs no rig; LIQUID manual tapping is slow unless pumped; GAS requires installed rig for **every** race.

| Faction | Primary phase dependence (physical form) | Slowest intended extraction | Fastest intended extraction | Narrative consequence |
|---|---|---|---|---|
| **ORG** | Early SOLIDS | SOLID | GAS | ORG needs high-volume early biomass/materials but struggles to secure them; can monopolize future vents if equipped |
| **MAN** | Midgame LIQUIDS | LIQUID | SOLID | MAN can strip SOLID from ORG's immediate territory but must work for refining/extraction of midgame fluids |
| **ETH** | Late GAS | GAS | LIQUID | ETH can contest MAN's fluid reserves, but advanced gas extraction must be built and defended carefully |

The table expresses **relative throughput after legal infrastructure**, not changing the legal form access gate. Form-to-currency mapping is an **OPEN cross-era decision**; GAS is **NOT** simply Energy and “ether” is not a fourth universal currency. A future refinery may consume captured gas and produce Energy only through a priced, finite explicit recipe.

**Provisional normalized 3×3 extraction throughput matrix** (future **three-form** game, not active in solid-only MVP):

| Faction | SOLID | LIQUID | GAS | Row total |
|---|---:|---:|---:|---:|
| ORG | **0.85** | 1.00 | 1.15 | 3.00 |
| MAN | **1.15** | 0.85 | 1.00 | 3.00 |
| ETH | 1.00 | **1.15** | 0.85 | 3.00 |
| Column total | 3.00 | 3.00 | 3.00 | |

Every row and column sums to 3.00 by construction; that **does not** guarantee equal win probability. Actual rates may be realized via extraction cycle duration, real carrying capacity, rigs, conversion and route costs, not one fake global income multiplier. The old matrix `ORG Matter=1.30, MAN Volatiles=1.30, ETH Energy=1.30` in `resource-balance.yaml` is an **older currency utilization hypothesis**, **not current owner-approved FORM extraction**; it cannot be plugged directly into harvesting.

## 2. MAN versus ETH when SOLID is the only collectible form

If full late-game extractors, gas and liquid are unavailable in the 0.1 map, giving MAN an immediate 15–30% overall income bonus creates an avoidable prototype imbalance. Use a **small candidate MAN mining advantage**, preserve equal direct soldier DPS and let asymmetry come from the systems:

| Metric | MAN | ETH | Reason |
|---|---:|---:|---|
| SOLID harvesting time per Matter per MIN | **1.90s** | **2.00s** | MAN 5.3% higher pure mining rate, deliberately less than future 15% matrix |
| MIN cargo | 8 | 8 | One comparable transport unit |
| MIN ground travel | 2.30 tiles/s | 2.30 tiles/s | Isolate logistics, not movement stat |
| MIN cost | 15 Matter + 1 E | Same | No hidden economy bonus |
| Infra cost | 40 Matter + 5 E | Same | UMU mobile depot vs Pylon static network/turret |
| Barracks cost | 60 Matter + 8 E | Same | Common production timing |
| Infantry cost | 20 Matter + 2 E | Same | Common basic fight benchmark |
| Basic infantry HP / DPS before armor | 85 / **7.5** | Same | 9 damage per 1.2 sec |
| Starter Energy | 40 E | 40 E | Same bootstrap reserve |
| Starter support / used | 8 / 5 | 8 / 5 | Identical initial growth allowance |
| Infrastructure support | +8 deployed | +8 all modes | MAN can move, ETH turret cannot |
| Generator E/s | UMU warehouse 0.40, bunker 0.20 | Nexus 0.20, Pylon **0.00** | MAN power mobility vs ETH transferable resonance |
| Defense | 2 actually garrisoned infantry in UMU | 4-tile paid 8-damage/2s Pylon turret | Contrast: mobile garrison vs fixed energy-hungry fire |
| Enemy interception | Supply crates and cable cuts | Relay and construction beam disruption | Both vulnerable, in different ways |

Initial mother HQ for both produces **0.20 E/s** from explicitly declared external solar/ambient generation and holds real stored Energy. This generation is **NOT free untracked Mined Energy**: external input must be in energy ledger and can be stopped/disabled by future map rules. Pylon does not generate itself (avoids surprise income from tower spam).

### Arithmetic sanity check — provisional short-round trip

Use **8 Matter per trip**, a straight source **8 tiles from base**, worker speed **2.3 tiles/s**, 0.70s total loading/unloading overhead; ETH has an additional 1.0s batch Nexus re-encoding delay (throughput 8 Matter/s).

`trip_s = 8*gather_seconds_per_unit + 2*8/2.3 + 0.70 + (ETH?1.00:0)`

| Calculated unblocked test | MAN | ETH |
|---|---:|---:|
| Worker round trip | **22.86s** | **24.66s** |
| Income per worker | **21.0 Matter/min** | **19.5 Matter/min** |
| Income for 3 uninterrupted workers | **63.0 Matter/min** | **58.4 Matter/min** |
| Time to physically gather 100 Matter | **95.2s** | **102.7s** |
| Time to physically gather 160 Matter | **152.4s** | **164.4s** |

The simplified cycle assumes a *specific source 8 tiles away*, uninterrupted movement, no source queue, no site hauling overlap and no enemy. It is a **paper bound, not an engine result**. An income advantage of ~7.9% in this synthetic cycle still needs counterweight from actual build routes and Pylon/UMU affordances.

### First meaningful build order cost

`infrastructure (40) + barracks (60) + 3 soldiers (3*20) = 160 Matter`, which fits the independently accessible **400 solid units** near each start. Add 3 extra replacement workers for `205 Matter`. Initial Energy 40 can pay `5 + 8 + 3*2 = 19 E`, even if environmental generation were temporarily zero. Thus neither faction needs pumps, gas rigs nor a connected secondary base for its first combat army.

With `24s` solo work for infra and `40s` for barracks divided into three equal work stages, active **max workers per stage**:
- MAN 1,2,2: infra **16.0s** minimum; barracks **26.7s** minimum.
- ETH 1,2,3: infra **14.7s** minimum; barracks **24.4s** minimum.

Those are **ideal labor-only lower bounds** if all the needed authorized workers, stage Matter and Energy are on site on time. In a real battle ETH's physical arrivals and graph routing add delay; MAN's crate shuttles can add even more. Neither side is entitled to always receive its full worker cap at each stage.

This combination gives **MAN** better immediate solids and mobile setup, **ETH** slightly faster cooperative final assembly, network-based relay and a paid defensive turret. Whether this yields a genuinely even game must be measured, not declared.

## 3. Why a pylon turret must have a genuine cost

Proposed ETH turret: 8 damage every 2s, 4-tile LOS range, spends 1 E/shot = **0.5 E/s** at uninterrupted max fire. Its mother Nexus ambient generation is only **0.20 E/s**; **the turret burns 0.30 E/s more than one Nexus generates** under maximum fire, even before other production spending. It can defend a raid but cannot produce free unlimited perimeter defense from ambient supply. Pylon consumes inventory E actually delivered via its one Ether Network.

MAN bunker has up to two actual garrisoned Riflemen firing through real LOS; it does not spawn two imaginary soldiers. Packing the UMU makes generation 0 and removes its +8 deployed support; the army is not killed by resulting overcap, but further training is blocked. This converts mobility into a **timed economic decision**, not free simultaneous warehouse/bunker/generator/truck/tower.

## 4. Three ways asymmetry could still be unfair

1. **MAN early-income snowball:** even modest mining advantage could yield first barracks and soldiers early enough to kill an ETH Pylon before it has meaningful stored Matter/E. Compare first troop time, not just raw income.
2. **ETH split fragility vs unlimited defenders:** ETH has all assets on one network and loses site time on last beam cut. Its Pylon +8 support may favor defensive overbuilding; Energy drain, no movement and reduced freight mode are the balancing penalties.
3. **Salvage treadmill:** recycling 100% of finished structures would let the same matter finance endless repositioning. Use candidate destroyed completed salvage 35%, MAN unfinished installed 50%, safe voluntary complete disassembly 65%, but preserve 100% of **unchanged loose crates** and **ETH already committed incomplete-site material**. All fractions are candidate; auditing must prove `recovered+lost = original` and repeated completed rebuild loops never increase material.

## 5. Method for real playtest balance

**Layer 1 — invariant/property tests:** 20Hz fixed tick, resource conservation, no negative accounts, network split+merge, mode switching, legal borders, first build funded, loss-bearing recycling, one-world Hero and final-building win.

**Layer 2 — single-unit microbenchmarks:** identical travel distance routes, one-to-eight workers on one source, MIN mining throughput per faction, 1 vs 2 vs 3 builders in each stage, full vs cut ETH link, packed vs deployed UMU, Pylon turret output under fixed E budget, delivered Matter per minute, drop pickup.

**Layer 3 — economy bot simulations:** two scripted bots with symmetric objectives and mirrored roles, swap team map starts, run same seeded jungle fixtures for at least **20 test seeds per role/side pairing** as engineering smoke; aim to sample 100+ matches per pairing once game loop is stable. These are **planned sample sizes**, NOT simulations already run.

**Layer 4 — human 1v1 tests:** account for unit micromanagement, early scouting, tree cover, Hero possession advantage, interruption frustration and HUD overhead. Test early 0–5 min, mid 5–12, contested 12–25 and likely stalls. Full three-form MIN/MID/MAX may later target 25–40; the 0.1 five-role solid-only slice should first be fun over **~10–25 min**, without an enforced hard time cap.

### Metrics to collect, with no fabricated observed values

- First 40-Matter infrastructure, Barracks, 1st/3rd Soldier timings by faction; 10th percentile, median, 90th percentile;
- Mine/source income, cargo delivery rate, travel vs gather time, permanently idle worker count, denial / contested ore share;
- Rate and duration of insufficient Energy, blackout and over-cap states; Pylon turret fired E per second / damage;
- ETH conversion throughput, relay latency, hop queue/backpressure, typed Matter distribution, site aborts and attacker interruption;
- MAN uninstalled crate theft, worksite queue stalls, generator warehouse vs bunker mode usage, UMU pack/restore and camp denial;
- Damage due to LOS/tree cover, infantry time-to-kill, building/soldier kills, end-match cleaning last mobile UMU;
- Recycled vs originally mined Matter, permanent attrition per rebuild, orbs/cubes recaptured, duplicate ledger errors (must remain **zero**);
- Outcome by side/faction, time and number of commands. At equal skill aim for **50%** faction wins with confidence intervals, never a guarantee.

### Provisional release guardrails

**Hard stop:** any negative resources, duplicate resources, unauthorized liquid/gas income, invisible map escape, ETH graph cloning or nonexistent terminal victory. **Warn for tuning:** first infrastructure/barracks timings differ more than 15–20% under fair symmetric benchmark; early scripted matchup repeatedly wins >60% from either faction after sides swapped; underused UMU mobility/Pylon turret; endlessly stable no-damage stalemate.

**Be careful with statistical claims:** a 60% win rate across 20 games is not convincing evidence of imbalance. Evaluate larger sample and variability and human-skill confounds before revising rules.

## 6. Suggested implementation balance update process

Record each playtest patch as a new versioned `design/mvp-balance-playtest-v0.X.yaml` or a variation YAML identifying exact overrides, associated Godot commit/test command/seed set and result hashes. Avoid independently editing old `mvp-economy.yaml` and `mvp-combat.yaml` numbers without updating this single active profile. The coding agent must load **one** numeric source of truth, report which profile hash was used, and make factual claims only when tests actually ran.

**The user did not approve the numeric values** in this file; their function is to prevent coding agents from inventing incompatible defaults, to provide initial checks and to make iterative balance possible.
