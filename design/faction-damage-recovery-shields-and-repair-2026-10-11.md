# Scalfagus — Three-Faction Shields, Health and Recovery (DEC-037)

**Date:** 2026-10-11 (owner discussion); archived as the next owner design decision.  
**Status:** owner-approved faction recovery *rules and relationships*; exact regeneration rates, thresholds, timings and costs are **not** approved balance values.  
**Machine-readable specification:** [faction-damage-recovery-shields-and-repair.yaml](faction-damage-recovery-shields-and-repair.yaml).  
**Related:** [DEC-035 network logistics](three-faction-logistics-and-eth-unit-relay-2026-10-11.md), [DEC-036 storage and Obelisk policy](faction-storage-specialization-and-obelisk-traffic-2026-10-11.md), [Energy](energy.yaml), [faction definitions](factions.yaml), [DEC-033 first release](mvp0-man-mirror-rts.yaml).

## Owner's explicit direction (original Polish)

> Org jak zergi odnowa powolna automatyczna i szybsza przy dostępie do żył. Eth może regenerować zdrowie zielone gdy zje całą tarczę. Musi wykonać kilka cykli. Tarcza sama się regeneruje i szybciej przy obeliskach przy podłączeniu do network. U terran jednostki bio wymagają leczenia a mechaniczne serwisu . Niektóre mam mogą mieć pole siłowe ale zawsze jego regeneracja wymaga doładowania bateria lub z sieci

This sets **Scalfagus faction rules**, NOT a requirement to copy every numerical stat from StarCraft or to use the terms "Terran", "Zerg" or "Protoss" for Scalfagus races. The user's final "mam" means MAN in the project context.

## Shared combat accounting

- Two separately tracked **durability layers** where a given template actually supports shields: \`health_hp\` (green) and \`shield_hp\` (blue). Damage normally depletes the shield first, then health, barring future explicit damage-type exceptions.
- \`max_health_hp\`, \`max_shield_hp\` and any stateful cooldowns are finite; integer/fixed-point amounts and deterministic fixed-tick changes should be preferred to animation-time recovery.
- A default ORG actor does **not** gain free shields. A default MAN actor does **not** gain automatic organic or mechanical healing. Selected MAN templates **can** have shields, but MAN shield recharging is not passive.
- **Shield charge is durability**, not an additional global currency. The canonical spendable resource named \`energy\` remains a distinct, finite, stored economic resource (DEC-001). Mechanics may pay Energy or drain a real battery to accelerate/replenish shielding as explicitly defined below. Do not add a fourth economy resource merely to represent shield HP.
- Every event is attributed to exactly one owner/entity, with no overheal, no over-shield, no double payment of Energy and no actor duplication when taking damage, retreating or travelling through an ETH Obelisk network. The same world state is observed by player, bots and headless tests.
- The timing and animation cannot cheat: shield cycling takes positive game ticks; a network cut affects boosted recovery at the deterministic fixed-tick boundary.

## ORG — biological self-regeneration accelerated by living veins

**Core identity:** every ORG unit/building that has the faction's biological regeneration capability slowly restores green HP **automatically** without requiring a medbay, constructor or explicit heal order.

- **Baseline:** positive, relatively **slow** recovery of missing green HP even away from the vascular network, provided the actor is alive and its biological capability permits regeneration. This does not imply literal resurrection from zero HP.
- **Network bonus:** if a unit or living structure actually has valid access to a **live functional ORG vein**, it can recover health **faster** than when disconnected. This access must obey real existing ORG vein/nourishment topology and rate; being merely visually close to a dead or isolated vein is insufficient.
- **No instant pocket healing:** when a vein is severed, its accelerated contribution stops or degrades according to a future finite buffer policy; baseline autonomous organic recovery may continue where the organism's own viability remains, but biological buildings dependent on home nourishment still obey starvation/wither rules (DEC-012/020/023).
- **Future cost design:** enhanced regeneration may consume actual finite nutrients/nourishment delivered through living vessels; rate and consumption constants are TBD. Do **not** add a phantom unlimited network currency. Slow basal regeneration's exact fuel/metabolism accounting is also a later design choice.
- Different eligible ORG unit roles may have different maximum HP/regeneration profiles; **speed relationship** is the approved guarantee, not identical healing per second across every template.

**Counterplay:** cut nourishing veins to remove fast healing; deny backup food supply; intercept large mother carriers. A detached, starving living structure may wither even though individual organic actors have innate regeneration.

## ETH — regenerative shields, multi-cycle shield-to-health conversion

**Core identity:** ETH shield durability (blue) **passively regenerates** over time. Green health (HP) can recover when the entity **sacrifices an entire charged shield** to convert that shield into real HP recovery. A badly damaged entity needs **multiple recharge → consume → recharge cycles**.

### Natural shielding and connected Obelisk recovery

1. Eligible ETH units have separately tracked blue shield and green HP.
2. After any applicable regeneration delay (time TBD), ETH shields regenerate on their own, **including away from the Obelisk network**; they cannot exceed their current shield maximum.
3. Regeneration is **faster while accessing a live connected Obelisk**, but only if it belongs to a legal ETH Ether Network component with functioning relevant services. The correct user-facing term is **Obelisk** (DEC-036), not Pylon.
4. The additional recharge service may consume actual Energy and/or finite network capacity. **Exact power costs, network quality-of-service contention with freight and slow unit relays, and minimum service under storage congestion are TBD**; do not assume infinite boosted recharge. A full Obelisk has a storage-related throughput penalty under DEC-036.
5. If the connection fails mid-recharge, only earned progress through previous valid ticks survives. The actor falls back to ordinary autonomous shield regeneration. No instant refill or free stock transfer across a partition.

### Healing by consuming a whole shield

Example flow: wounded ETH actor with 40/100 health and 0/100 shield → recharges to full shield → executes a **shield sacrifice** that consumes the **entire shield**, healing a **finite** quantity of HP → repeats until health is restored or the process is interrupted.

For deterministic prototype rules, the **safest interpretation candidate** is **full shield first, then consume 100% of its current nominal capacity** in a single conversion transaction. This prevents abusing a near-empty 1-point shield as a full healing cycle. Whether the *owner instead intends consuming every remaining shield point even when partly charged* should be confirmed before final balancing; the transcript only approves whole-shield sacrifice and repeated cycles, not the exact activation threshold.

- The shield debit and green-HP credit must be **atomic within one authoritative tick**.
- Healing is bounded by missing HP. If the HP deficit is small, a shield sacrificed for conversion still **depletes completely**; unused potential health does not become extra stored cargo or a new shield.
- **One conversion cannot restore arbitrary amounts of health**; exact shield-to-health conversion efficiency and minimum/maximum total cycles are TBD.
- A conversion should have an explicit command/policy and may carry an animation/cooldown/charge time. Optional automatic cycling requires permission and must never surprise a player relying on a full shield for combat defense.
- The unit is **vulnerable** in the interval after a shield has been converted into health and before the next recharge. Network speed, strategic retreat and attack timing matter.
- Do not treat the local shield as a bank of \`energy\` currency that can be deposited into an Obelisk or duplicated. Nor may simultaneous ETH in-transit relays and heal events cause two actors to emerge.

**Counterplay:** pressure the recovering unit to deny safe cycles, destroy/cut the connected Obelisk to remove fast shielding, force it to choose protecting current HP versus sacrificing shields to restore deeper wounds.

## MAN — externally healed biological units, serviced mechanical units, battery/network-only shields

**Core identity:** MAN repairs damage by engineering and medicine. It is not innately able to recover missing health as an entire faction just by waiting.

- **Biological MAN actors:** green health requires a **legal medical healing service** (medic, medbay, treatment module, compatible support capability); no baseline spontaneous green-HP recovery.
- **Mechanical MAN actors/structures:** green HP requires **physical service/repair** by eligible workers, repair systems or specialist infrastructure; the operation has finite time and, where applicable, real parts/Matter/Energy costs. No baseline spontaneous mechanical auto-repair.
- Bio/mech hybrid entities may need type-specific medical and mechanical services, to be decided per chassis rather than assumed universally.
- **Some selected MAN units can possess a blue force shield**, not all. Its recharge **always requires an energy source**: a real finite local **battery charge** or valid connection to a powered **MAN energy network**. If neither is available, the shield **does not recharge at all**, irrespective of time since the last hit.
- A unit-borne battery is finite and must itself be recharged/refilled through an actual legal power source or carried Energy. Recharge from a powered network consumes/draws finite actual supply. No infinite energy loop in which shield-charge is conjured and then transformed into transferable economy stock.
- If a powered MAN grid is cut, any legal residual local battery can continue paying for recovery until depleted; only then does shield recharge stop. Unlike ETH, there is **no passive shield refill in total energy isolation**.
- A combat medical/repair service requires correct target identity, range, authorization, effect limits and time. Do not conflate the MAN green HP repair pipeline with shield energy recharge.

**Counterplay:** force depleted batteries, attack supply/repair infrastructure, separate troops from medics or mechanics, overload grid capacity.

## Worked visual comparison (illustrative, NOT canonical tuning)

Each eligible actor has 100 maximum green HP; ETH has 100 maximum blue shields. After combat:
- ORG 40 green HP, no blue shield: passively creeps up to 100; a reachable live vein makes it faster.
- ETH 40 green HP, 0 blue shield: regenerates blue shield to 100; sacrifices all 100 blue shield points to heal some of the missing 60 green HP; repeats until HP restored; still needs another cycle to finish with a protective shield. The amount of HP gained per cycle is **not fixed yet**.
- MAN biological actor 40 green HP: remains at 40 until medically treated. MAN mechanical actor 40 green HP: remains at 40 until repaired. Shield-equipped MAN actor with 0 blue shield refills only by draining a battery or drawing powered supply, and heals HP via its biological/mechanical category independently.

## UI / player autonomy

- Separate visible bars: **green HP**, and **blue shield** only on templates that actually have shielding.
- Explain why recovery is paused/boosted: "ORG live vein", "ORG vein severed", "ETH Obelisk network connected", "ETH natural shield regeneration", "ETH shield consumed for healing", "MAN battery empty", "MAN grid disconnected", "MAN medical/repair service needed".
- ETH displays cycle progress and whether shield-to-HP conversion is manually commanded, manager-authorized or idle. A shield-sacrifice action must never be hidden in a renderer side effect.
- Full Manual, Semi-Auto, Full Auto share one legal command interface. Human manual commands override delegates; group managers and doctrine controllers may use restorative abilities only if they have permission.
- A default emergency policy should favor keeping the shield when in imminent danger (proposed, not a blanket automatic conversion requirement).

## Implementation release gates

**DEC-033 / MVP 0.1 remains unchanged:** MAN-vs-MAN; fixed four templates (Command Core, MIN, Barracks, Rifleman), physical Matter delivery and basic combat. Do not add ETH, ORG, shield HP, sophisticated medicine, service grids or automatic network regeneration into this first release just because DEC-037 has been approved.

Implement the multi-layer damage model **only after** the first release has a clear upgrade plan. Add shared damage/recovery accounting first, then ORG baseline and vein bonus, ETH passive shielding/whole-shield-to-HP cycles and Obelisk boost, and MAN bio medical/mech maintenance/battery or grid shield. Exercise deterministic LAN/headless tests before declaring runtime parity.

## Proposed acceptance tests

- **HEAL-01**: ORG actor with damaged green HP recovers slowly without vein access; does not recover above its maximum.
- **HEAL-02**: Same ORG actor with a valid nourished live vein restores HP faster than in baseline isolation, under otherwise equal conditions.
- **HEAL-03**: Severed or unreachable vein does not grant the network bonus and does not magically erase owned local resources.
- **HEAL-04**: ORG zero-HP destroyed actor is not resurrected by innate regeneration.
- **HEAL-05**: ETH shield HP regenerates passively away from the network after legal delay, never exceeding cap.
- **HEAL-06**: Same ETH shield regenerates faster with legal connected Obelisk service; broken network drops bonus.
- **HEAL-07**: ETH multi-cycle shield-to-HP conversion consumes all eligible shield in one atomic event, restores only a finite amount of missing health, and cannot trigger twice against one shield.
- **HEAL-08**: ETH needs multiple whole-shield sacrifices for an illustrative severe health deficit; cannot get full heal from one arbitrarily tiny shield.
- **HEAL-09**: ETH shield-to-HP conversion is not invoked by an unauthorized group/civilization manager.
- **HEAL-10**: MAN biological actor cannot restore missing HP just by idling; appropriate medical service restores finite HP.
- **HEAL-11**: MAN mechanical actor cannot restore missing HP just by idling; appropriate repair restores finite HP with actual costs.
- **HEAL-12**: Shielded MAN actor with no local battery and no valid powered network recovers exactly zero shield HP.
- **HEAL-13**: MAN shield with finite battery draws battery exactly once per accepted recharge event; exhausted battery stops progress until legally recharged.
- **HEAL-14**: MAN shield with valid powered grid draws finite supply, and after grid loss may continue solely from remaining battery.
- **HEAL-15**: Damage first depletes shields and then health, without duplicated HP changes on one authoritative tick.
- **HEAL-16**: The same state transitions/replay outcomes occur in GUI, headless and LAN host simulation for a pinned ruleset/seed.
- **HEAL-17**: An ETH Obelisk full of stored resources respects DEC-036 bandwidth constraints if network-assisted shield regeneration is configured to share transit service.
- **HEAL-18**: A shielded MAN unit cannot convert blue shield points into green HP by the ETH-only cycle mechanic.
