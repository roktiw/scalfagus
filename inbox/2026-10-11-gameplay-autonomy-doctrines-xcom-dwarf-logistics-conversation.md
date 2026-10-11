# Scalfagus — Conversation Archive: Autonomous RTS, Doctrines, Simulation Inspirations and Faction Logistics

Date: 2026-10-11 (Europe/Warsaw).  
Source: current ChatGPT design conversation, supplied by the project owner.  
Kind: **conversation record and design handoff**, not an executable acceptance test or implementation report.  
Preservation approach: original user utterances reproduced below in Polish; assistant responses are recorded as **detailed topical summaries** rather than falsely labeled as verbatim full transcripts. The long podcast episodes remain in the originating chat; their principal arguments are distilled here.  
Repository: roktiw/scalfagus, branch main.  
Current first playable release: **DEC-033 / MVP 0.1, MAN vs MAN, four templates, Verdant Divide, native Godot RTS, H-H / H-C / C-C**. Post-MVP concepts here do not expand the MVP0 definition of done.

## 1. Chronological record of owner input (original language)

### 1.1 Autonomous units, RTS orders and future possession

> Dokładnie. Scalfagus idzie w kierunku połączenia Dungeon Keeper, StarCrafta i autonomicznej symulacji w stylu Factorio. Ale z jedną fundamentalną różnicą: każda jednostka ma własną inicjatywę, a gracz nie musi być jej operatorem, żeby świat funkcjonował.
>
> Wyobraź sobie, że budujesz koszary MAN. Koszary produkują Riflemanów. Nowo wyprodukowany żołnierz wychodzi na zewnątrz, sprawdza sytuację i sam podejmuje domyślne działanie. Jeśli baza jest bezpieczna, zaczyna patrolować. Jeśli zbliża się wróg, zajmuje pozycję obronną. Jeżeli ma przypisany rozkaz ochrony robotników, wraca do eskorty.
>
> Teraz zaznaczasz tego żołnierza w RTS i nakazujesz mu pilnować mostu. Twój rozkaz ma pierwszeństwo przed jego własnym AI. Żołnierz pozostaje na posterunku, ale sam podejmuje drobne decyzje taktyczne: gdzie stanąć, kiedy strzelić, jak uniknąć przeszkody.
>
> Następnie wcielasz się w niego jak w Dungeon Keeper. Przechodzisz na FPP, osobiście strzelasz i przemieszczasz się. Gdy wychodzisz z jego ciała, żołnierz odzyskuje autonomię i może kontynuować wcześniejsze zadanie.
>
> To samo dotyczy robotników. Nie musisz każdemu kazać zbierać surowców. Robotnik może sam znaleźć potrzebną pracę, dostarczyć materiały albo naprawić uszkodzony budynek. Gracz natomiast może przejąć go i wykonać specjalistyczną czynność ręcznie.
>
> Budynki również będą posiadały mini-AI. Przykładowo MAN UMU może działać jako generator, magazyn lub bunkier. Jeśli pozwala na to jego konfiguracja i sytuacja gospodarcza, może automatycznie wybrać właściwy tryb. Nie oznacza to jednak, że dowolne koszary mogą spontanicznie zmienić się w elektrownię. Transformacje muszą wynikać z rzeczywistych możliwości danego obiektu i respektować koszty, czas oraz reguły gry.
>
> Najważniejszy element architektury to trzy poziomy decyzyjności.
>
> Pierwszy: instynkt jednostki. Co robić, gdy nikt nie wydaje poleceń? Patrolować, pracować, bronić się, odpoczywać.
>
> Drugi: polecenia strategiczne. Gracz mówi, co ma zostać osiągnięte. AI samo organizuje szczegóły wykonania.
>
> Trzeci: bezpośrednie przejęcie. Gracz na chwilę staje się pilotem, żołnierzem lub inżynierem.
>
> I wszystkie trzy poziomy obsługują tę samą fizyczną jednostkę, jej stan, ekwipunek i uprawnienia.
>
> Chciałbym przy tym zachować jeden bardzo ważny bezpiecznik: autonomia nie oznacza samowoli strategicznej. AI nie powinno wydawać całego budżetu, demolować bazy ani zmieniać jej przeznaczenia bez przyznanej swobody. Możemy wprowadzić polityki zachowania: wykonuj wyłącznie rozkazy, pracuj autonomicznie w swojej roli albo samodzielnie zarządzaj przydzielonym obszarem.
>
> Co ciekawe, z takim fundamentem można będzie później stworzyć całkowicie autonomiczne cywilizacje. MAN rozwijający przemysł i logistykę, ETH rozbudowujący sieć energetyczną oraz ORG rozrastający się jak żywy organizm. Nawet bez gracza te światy będą podejmowały decyzje i reagowały na siebie.
>
> Docelowa filozofia Scalfagus: gracz nie steruje martwymi pionkami. Gracz dowodzi autonomicznymi istotami i maszynami, a kiedy chce — przejmuje nad nimi bezpośrednią kontrolę.
>
> To jest właściwy, uniwersalny core. I co ważne, pozwala nam zacząć od prostego MAN kontra MAN, dodając autonomię stopniowo, zamiast od razu pisać trzy kompletne cywilizacje.

### 1.2 Podcast request — basic hybrid identity

> Napisz mi podcast jak będzie svalfsgus gra jako miks dungeon keeper StarCraft I factorio

**Assistant discussion (summary):** StarCraft contributes RTS strategy and combat; Factorio contributes real finite production chains and material custody; Dungeon Keeper contributes autonomous actors and direct possession; Scalfagus unifies these in one physically persistent authoritative world. Suggested progression: begin MAN mirror RTS, add unit-level autonomy and managers later, possession later, autonomous distinct civilizations last. Fictional in-game examples in the podcast are illustrative, not claims of implemented features.

### 1.3 Boundaries of useful unit AI

> Rozkminić granice autonomii prostego ai w grze każdej jednostki i balans pomiędzy bezczynnością a pomocy faktycznej graczowi.

**Assistant discussion (summary):** Autonomous agents should remove repetitive micromanagement without undermining intentional player control. Distinguish reactive/local, tactical, operational, economic and strategic actions. An idle state can be correct if nothing authorized or worthwhile exists. Avoid an overeager AI that moves guards away, burns Matter or constructs without authorization. Manual orders outrank self-appointed jobs. Tests should measure utility gained, excess actions, idle reason and unwanted expenditure.

### 1.4 Three-state 'temperature' sliders

> To może dodać do gry suwaki ze stanami -1 0 +1 określającymi temperaturę budowania bazy wydobywania surowców doktryny wojennej etc . Podcast

**Assistant discussion (summary):** Proposed orthogonal temperature axes for construction, extraction, warfare, logistics, reconnaissance and later repair/reconstruction and expansion preparation. Values -1, 0, +1 indicate conservative, balanced and proactive preferences. They are not numeric buffs or blanket authorization. High extraction should not generate resources; high warfare should not reveal enemies through fog or authorize an unsanctioned attack. Suggested implementing a small deterministic utility scorer with permission filtering first and hysteresis against task oscillations.

### 1.5 Full Manual ↔ Semi-Auto ↔ Full Auto, managers and hot doctrine switches

> Gra może mieć tryb full manual jak klasyczny rts. Możesz wydawać jednostki proste rozkazy. Ale możesz też łączyć jednostki czy budynki w grupy i dawać im zarządców nazwijmy to pół automatic. I wreszcie możesz obstawiać 357 doktryny dotyczącej całej twojej rasy/cywilizacji wtedy algorytmy w grze mają najwięcej autonomii full jak w dungeon keeper czy dwarf fortress. A jak się zrobi gorąco to możesz znowu przejść na full manual, przejść na doktrynę wojenną, przejść na doktrynę przemysłową gdy jest po ataku, doktrynę odbudowy, soktryne przygotowania donexpansion etc

**Interpretation:** The three control modes and ability to switch them during a running game are explicit owner directions. The literal phrase "357 doktryny" is ambiguous speech-to-text; earlier assistant documentation proposed 3/5/7 *UI axis-depth levels*. Do **not** infer that exactly 357 doctrines are approved, or treat 3/5/7 as a required numeric balance constant. Existing design defines such UI depth only as a candidate.

**Assistant discussion (summary):**
- Full Manual is a classic RTS: human chooses every important action; low-level pathing/defense can still function.
- Semi-Auto: user groups buildings/units under **logical managers** with specific territorial scope, objectives, budgets, permissions, task-board slots and revocation rules.
- Full Auto: faction-level managers follow a civilization doctrine, issuing only authorized instructions and respecting normal gameplay economics, visibility and legality.
- Doctrine presets: balanced, war, industrial, reconstruction, expansion preparation and defensive readiness. Temperature axes are separate from control authority.
- Handover is immediate at the next authoritative fixed simulation tick for **new autonomous decisions**; already accepted work follows normal cancellation and refund rules. No duplicated resources, no vanished jobs, no reset of HP or physical entities.
- STOP should not be immediately overwritten by idle-job finding; a latched hold/resume behavior is needed.
- Policy hierarchy: civilization → sector → manager/group → unit/building; explicit zero is distinct from 'inherit'.
- Automatic switching into emergency doctrine is a **separate opt-in feature**, not implied by Full Auto.
- Players may take direct control during combat and return to Semi/Full later.

### 1.6 Explicit request to store conclusions

> Pisz wnioski do repo

**Recorded repository work during the conversation:** Created design/command-autonomy-modes-2026-10-11.md and design/command-autonomy-modes.yaml describing the three control modes, doctrine axes, manager permissions, hot handover and AUTO-01..AUTO-18 scenarios. These are design files, not tested implemented gameplay.

### 1.7 X-COM inspiration podcast

> Jakie elementy z UFO enemy unknown i terror from the deep potencjalnie mogą być w scalfagus. Podcast

**Assistant discussion (summary):** Comparative analysis of classic UFO: Enemy Unknown (1994) and X-COM: Terror from the Deep (1995). Potential **post-MVP**, not owner approvals:
1. Fog of **knowledge**, in addition to sight: detected signal → identified class → recovered material → studied technology. Discovery and samples precede use of blueprints/counters.
2. Individual soldiers: experience, wounds, morale, discipline, consequences of losing veterans; avoid superhero stat inflation.
3. Reaction fire/overwatch in real time: legal target visibility, firing arcs, aim/reaction delay, cooldown, no extra AI omniscience; no turn-based action point engine.
4. Recovery of actual physical wreckage and components: risk of destroying target completely versus capturing intact equipment; Factorio-like logistics carries salvage to real analysis facilities.
5. Enemy assaults on the real existing base; in future, interior rooms and first-person participation share the same match entities.
6. Environment-specific constraints: under-water, low-oxygen/vacuum, internal complexes, tailored equipment and sensor modalities; all playable maps must still obey DEC-030 floating-space-platform world law.
7. Geoscape/Battlescape inspiration: eventual orbital strategic map of multiple floating platforms and missions, without dropping current one-world simulation rules.
8. Rescue / transport defense / salvage and reconnaissance mission objectives, not only destroy-every-building.
**Do not copy:** mandatory turn combat, tedious individual inventory micromanagement, constant randomly forced panic, arbitrarily overlong tactical missions.

### 1.8 Dungeon Keeper / Dwarf Fortress inspiration podcast

> Dwarf fortress I dungeon keeper aspekty w scalfagus podcast

**Assistant discussion (summary):**
- Dungeon Keeper: living workplace, autonomous role fulfillment, rooms that create work demand, territory defense, managed creature needs, later direct possession of the exact persistent entity.
- Dwarf Fortress: independent actor state, specialized skills and needs, physical consequences and **emergent chain reactions**. The "bridge destroyed → transport reroutes → shortage → production blocked → repair funding conflict" story should emerge from actual simulation instead of a scripted cutscene.
- A base's role-specific needs differ by faction: MAN finite industrial stock, power and maintenance; ORG biological nutrition and living vessels; ETH networked Energy, relay links, node inventories.
- In-game history can record who built, repaired, defended or lost a bridge. Operational telemetry and historical events may support decision-making; do not create an expensive psychology system without gameplay use.
- Control mode parallels: classic RTS (full manual), delegated living dungeon (semi-auto), fortress/civilization self-management (full auto).
- Simulation AI frequency can be decoupled by responsibility: high-frequency movement/combat physics versus lower-frequency worker job selection and even lower-frequency manager decisions; do not violate authoritative state or fixed-tick determinism.
- Avoid invisible AI sabotage, universal refusal of orders, unrestricted personality/morale complexity, and copying every Dwarf Fortress sub-simulation.

### 1.9 Clarified asymmetric transport and the new ETH ability

> U ludzi przynosi się zasoby w transporterach bunkrach elektrowniach i taskociagami. U org dużymi jednostkami i żyłAmi. U eth sztafeta między pylonami i każdy pylon jest magazynem. Ale też połączenia między pylonami umożliwia powolne transportowanie jedostek czego nie mają inne

**Owner-directed facts:**
- MAN: transporters, compatible bunkers/warehouse and generation-module storage, physical conveyors/belts. Power/data cables themselves do not carry physical resource cargo.
- ORG: large living hauling units **and** organic vessels/veins.
- ETH: a hop-by-hop relay over pylons; **every pylon has finite local storage**. An additional **slow transfer of eligible units between connected pylons** is ETH-only among the three factions' internal network transport systems.
- MAN and ORG may still use legitimate physical passenger-carrying units. ETH uniqueness is **unit travel inside a pre-existing infrastructure link**, not monopoly over all transportation of passengers.

**Assistant design candidates, not approved exact balance:**
- One existing ETH network graph conveys typed resources, Energy, knowledge and now unit-in-transit payloads; not a fourth currency or teleport to any arbitrary coordinate.
- Unit must reach an eligible departure pylon and a real connected path to a destination pylon. Every hop takes time, has capacity and possible Energy cost; relay is vulnerable to queue congestion and node loss.
- Single unit identity/HP/ownership/inventory must persist; it cannot simultaneously act on map while encoded/in transit and materialize twice.
- Destination position must be collision-free; blocked arrival is handled without teleporting into obstacles.
- Breakage/interruption treatment, turret-port mode restrictions, heavy-unit eligibility and exact Energy-per-hop remain open design/balance decisions.
- Strong competitive counterplay: destroy/jam pylons to partition ETH inventories and trap/re-route reinforcement, cut MAN physical conveyor corridors, sever ORG veins or intercept giant carrier organisms.
- The ability is post-MVP0; DEC-033 first release does not contain ETH pylons, ORG veins or advanced MAN belts.

### 1.10 Explicit request for coding, then for archiving

> Klep kod

**Actual observed status:** The assistant began an implementation-oriented source inspection of apps/game/scripts/mirror_match_state.gd, mirror_view.gd, mirror_smoke.gd, mirror_batch.gd, scripts/check.sh and MVP0 numeric specification. **No new gameplay GDScript implementation was verified committed by that exchange before this archive request.** Do not interpret the code-request discussion as a completed feature or a proven green CI run.

> Zapisz dyskusje nasze do repo

This document fulfills the subsequent archive request, not an additional instruction to silently implement out-of-scope mechanics.

## 2. System-level synthesis (what must remain true)

### One world, multiple delegation levels

- One authoritative match world and one entity for each individual, whether controlled by local AI, an RTS player, a manager, a civilization doctrine, or later FPP.
- Player orders take priority over autonomous decisions. Legal movement/targeting/self-defense may remain automated *inside* the manual order.
- Full Manual / Semi-Auto / Full Auto are dynamic command-authority settings, not three different physics/economy engines.
- Every automated action passes the same ownership, fog, ability, map, budget and finite resource validation as human commands.
- Temperature (-1/0/+1) ranks preferred **legal** work, rather than granting rights, statistics or unbounded production.
- A valid idle actor is acceptable. No activity-for-activity's-sake; avoid task thrash, busy retries and repeated claims of the same job.
- Full Auto is explicitly delegated. It may perform long-horizon strategy **within** authorized objectives and constraints, not create a new civilization-wide constitution without user approval.

### Physical economy and faction asymmetry

- MAN: Matter rides physical workers, containers, transporters and conveyors into compatible finite storage; power/data cables do not teleport solids. UMU/bunkers' inventory port access is mode-dependent.
- ORG: Matter/nutrition rides physical organisms and finite vascular networks; rooted colony's upkeep creates strategic fragility.
- ETH: physical resource intake reaches eligible Nexus conversion before typed Ether freight; pylons maintain their own stocks, hops take time; network unit relay uses the same topology but a separate **unit custody** state, finite capacity and no duplication.
- Unit-over-network transfer is unique to ETH, but **not instantaneous**, unrestricted teleportation, or relocation of completed buildings by implication.
- Destroyed network links create real and deterministic supply disruption. Preserve ledger ownership and never copy resource/actor state across a partition.

### Battlefield and release isolation

- All playable terrain remains a floating platform in outer space (DEC-030).
- MVP0 scope is **only** MAN vs MAN with Command Core, MIN worker, Barracks, Rifleman, SOLID-to-Matter and basic RTS (DEC-033).
- No retroactive MVP0 requirements for FPP, UMU, ETH, ORG, production networks, global simulation, X-COM research, personalities, fatigue or pylon unit transit.
- Use Godot 4.7.2 Standard typed GDScript and reuse-first rules (DEC-034); third-party plugins require provenance, license, pinning, compatibility and tests.
- Headless, GUI and LAN must share the same game rules; cosmetic animation and agent intent must not mutate state from clients.

## 3. Status, provenance and open decisions

| Subject | Type | Status as discussed |
| --- | --- | --- |
| Three player control modes | Explicit owner direction | Design documented; code not demonstrated |
| Individual autonomous initiative with manual override | Explicit owner direction | Design documented; code not demonstrated |
| +/-1 doctrine preference axes and presets | Owner direction, axis details assistant proposals | Design documented; exact balancing pending |
| Logical group managers and budgets | Owner direction with proposed contract details | Design documented; implementation pending |
| FPP same-entity possession | Long-term intended game design | Deferred from MVP0 |
| X-COM-like intel/research/overwatch/wreck recovery | Assistant inspiration proposals | **Not owner-approved release requirements** |
| Dwarf Fortress individual histories/morale/emergence | Assistant inspiration proposals | **Not owner-approved release requirements** |
| MAN physical transport + conveyors | Owner direction, supplements prior faction docs | Post-MVP canonical direction |
| ORG huge carriers + veins | Owner direction, supplements prior faction docs | Post-MVP canonical direction |
| ETH pylons all storing finite stock | Owner direction and already developed network principles | Post-MVP canonical direction |
| ETH slow unit-over-link relay | New explicit owner direction, DEC-035 | Design documented; exact rules/TBD, no implementation claimed |
| '357' doctrine phrase | Ambiguous literal transcription | Preserve source wording; 3/5/7 UI levels only optional interpretation |
| Coding request 'Klep kod' | Requested follow-up | Source inspected, new gameplay implementation not verified |

## 4. Existing repository documentation linked to the conversation

Agent and release entry points:
- [AGENTS.md](../AGENTS.md)
- [Owner decision register, including DEC-033/034/035](../design/decisions.yaml)
- [Release authority](../design/agent-source-of-truth.yaml)
- [Current MAN mirror release contract](../design/mvp0-man-mirror-rts.yaml)
- [MVP0 numeric implementation candidate](../design/mvp0-agent-implementation-contract.yaml)
- [Source parity blockers](../design/mvp0-runtime-parity-gaps.yaml)

Autonomy:
- [Three control modes, doctrine presets and hot handover — human](../design/command-autonomy-modes-2026-10-11.md)
- [Autonomy machine-readable acceptance — AUTO-01..18](../design/command-autonomy-modes.yaml)

Faction logistics:
- [MAN/ORG/ETH and ETH unit relay — human](../design/three-faction-logistics-and-eth-unit-relay-2026-10-11.md)
- [ETH unit relay machine-readable specification — LOG and ETH-UNIT tests](../design/three-faction-logistics-and-eth-unit-relay.yaml)
- [ETH pylon storage and network mechanics](../design/eth-ether-network-mechanics.yaml)
- [MAN UMU / ORG living vessels](../design/man-power-dock-and-org-vessel-mechanics.yaml)
- [One ETH graph, ORG living veins, MAN hybrid cable separation](../design/three-network-channels-and-destruction-2026-10-11.md)
- [Faction logistics overview](../design/faction-logistics.yaml)

## 5. Agent handoff — next work, without scope creep

**P0 / release blockers (do first):**
- Inspect current MVP0 Godot implementation and existing tests rather than assume every code snippet in earlier chat has been merged.
- Reconcile map (authored ten deposits / 1660 Matter versus older coded four / 2500), fixed-tick simulation clock (candidate 20Hz vs earlier GUI 10Hz), mining and training/build constants.
- Validate finite worker cargo → own HQ Matter ledger, combat/LOS, victory, bot match/headless hash, and genuine two-client host-authoritative H-H LAN. Record real test runs.
- Preserve all prior project scenes/visual regression tests.

**Next opt-in design slices after MVP0:**
1. Actor state machine: manual order, legal tactical instinct, explicit idle/hold/resume, fixed-tick deterministic decisions.
2. Semi-Auto groups: logical manager, scoped tasks, reservations, budget, permission fences and telemetry.
3. Civilization doctrine panel and hot switching; policy hierarchy and presets, with AUTO acceptance tests.
4. True per-faction transport: MAN bulk conveyors/transporters; ORG mother carriers/finite living vessels; ETH per-pylon finite stock and slow resource-hop network.
5. ETH slow unit relay as an **independent post-MVP feature**, with identity-preserving transit ledger, bandwidth, Energy, queueing and break-handling tests.
6. Future FPP same-entity control, advanced simulations and optional X-COM/Dwarf Fortress inspirations *only after explicit product scope selection*.

**Next design questions for owner approval before ETH unit relay implementation:**
- Which ETH unit classes can relay: only MIN, also fighters, also heavy units?
- Minimum channel time and per-hop distance/size scaling?
- Energy pricing, shared lane contention with resource packets, quotas?
- Is turret-mode pylon transit possible, throttled or forbidden?
- What happens to a unit on a destroyed in-flight edge: retreat to last safe pylon, damage, death, or interception?
- Can arrival occur at a pylon under enemy fire; if so, what warning, landing locks and vulnerability apply?
- Is tech research required to unlock unit transit?

**End of conversation archive.**

## Addendum: DEC-036 — owner storage clarification (2026-10-11)

> Org magazynują w cystach. Jedna cysta może  mieć tylko jeden rodzaj surowca. Ludzie mogą w UMU magazynować miks towarów ale, wybranie jednego rodzaju towaru sprawia że pomieści się lepiej. Eth po prostu lewitują miks towarów  wokol  pylonów ale im więcej pylon magazynuje tym mniejsza ma przepustowość więc gracz powinien dążyć do posiadania bocznic w networku lub bazie pylonów przeznaczonych do magazonywanja. Gdy mówię pylony mam na myśli obeliski bo chcemy się dorozniac od StarCraft protów

**New canonical owner decision:** [DEC-036 narrative](../design/faction-storage-specialization-and-obelisk-traffic-2026-10-11.md) and [machine contract](../design/faction-storage-specialization-and-obelisk-traffic.yaml). ORG has single-resource cysts, MAN UMU supports mixed goods but gains higher effective capacity if dedicated to a single type, ETH stores mixed resources as orbiting/levitating bundles at each **Obelisk** with storage-fill-dependent throughput penalty. Mainline Obelisks should remain relatively unloaded and storage branches should handle hoarding. Player-facing naming is **Obelisk**, NOT Pylon; old technical IDs are stable aliases until explicit migration. These systems remain future post-MVP0 features.

**Important correction:** earlier candidate for background capacity-weighted equalization across *all* ETH nodes would fill central relay Obelisks and undermine the newly approved branch storage economics. DEC-036 requires opt-in eligible warehouse-node balancing with protected transit-only nodes. Formula and exact traffic costs remain tuning proposals, not owner-approved numbers.

## Addendum: DEC-037 — owner clarification of faction recovery (2026-10-11)

> Org jak zergi odnowa powolna automatyczna i szybsza przy dostępie do żył. Eth może regenerować zdrowie zielone gdy zje całą tarczę. Musi wykonać kilka cykli. Tarcza sama się regeneruje i szybciej przy obeliskach przy podłączeniu do network. U terran jednostki bio wymagają leczenia a mechaniczne serwisu . Niektóre mam mogą mieć pole siłowe ale zawsze jego regeneracja wymaga doładowania bateria lub z sieci

**Canonical recovery direction:** [DEC-037 design](../design/faction-damage-recovery-shields-and-repair-2026-10-11.md) and [YAML test plan](../design/faction-damage-recovery-shields-and-repair.yaml). ORG green HP regenerates slowly on its own and faster with live vascular access. ETH shields recharge naturally and faster on a live connected Obelisk network; they can consume an entire shield to recover some green HP, repeating shield-charge/sacrifice cycles to fully recover health. MAN biologic HP requires medicine and mechanical HP requires repairs; only some MAN actors use shields, and these **must recharge through battery or electrical grid**, never free passive recharge. Shield HP must not be confused with the stored economic Energy currency. Full-shield activation threshold and exact regeneration balance are TBD. User's "terran" and "mam" are treated as MAN context; Scalfagus does not inherit external franchise names or exact balance numbers. Post-MVP0 only; no runtime implementation or test result is claimed.

## Addendum: ETH dual transport loops — foot-flag drones and Obelisk-tip freight

> Transport eth. Pylony u podnóża jako flagi w settlers gdzie drony mogą przenosić jak sztafety. Drugi obieg to sieć eth jako proste linie proste pomiędzy czubkami obelisków i obiekty surowców lewitują od czubka obeliska do czubka in opadają do podnóża obeliska jeśli w pobliżu obeliska ma powstać nowa budowla. Jesli obelisk starci “zasilanie” np będąc całkowicie odciętym od sieci to wszystko co lewitował opada na ziemię. Obeliska może zatem magazynować lewitując lub być po prostu flagą gdzie u podnóża ma porozrzucane zasoby conohraniaja drony. Magazyniwanienorzez lewitacje oczywiście kosztuje sieć. Do sieci eth surowce na pewno mogą być wrzucone przez Nexus. Ale pytanie czy tylko? CY to ma sens?

**Owner direction:** two concurrent ETH material paths: physical flag-to-flag drone deliveries under Obelisks (physical piles and handoffs), and straight visible tip-to-tip elevated Ether network with resources levitating around the Obelisk, consuming actual network service; scheduled nearby construction lowers actual parcels to Obelisk foot. Loss of actual network levitation power/support makes suspended stock fall to real ground once. **Open question:** can raw physical materials enter the elevated network at any other point than an eligible Nexus? Baseline existing DEC-021 is Nexus-only; assistant recommends later upgrade-gated local raw ingress, and offers re-lifting already converted fallen Ether cargo as a distinct cheaper service, but neither is owner approval. See [full proposal](../design/eth-dual-loop-ground-flags-and-aerial-freight-2026-10-12.md) and [machine-readable candidate](../design/eth-dual-loop-ground-flags-and-aerial-freight.yaml). Explicitly preserve unique custody ledger, power/disconnect distinction, ground packet survival, and first MAN mirror MVP0 isolation.
