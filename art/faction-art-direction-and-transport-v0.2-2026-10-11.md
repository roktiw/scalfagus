# Scalfagus — Faction Art Direction & Visual Logistics v0.2

Date: 2026-10-11
Status: **owner-directed visual style, updated to approved DEC-011/012/013 logistics roles**; sprite resolutions and animation budgets remain proposed.
**Canonical precedence:** [base ecologies](../design/base-ecologies-and-expansion-2026-10-11.md), [base ecology YAML](../design/base-ecologies.yaml), and [ETH original folklore lineages](eth-ancient-aliens-folklore-and-pixel-lineages-2026-10-11.md). Older art from this conversation is a design sketch, never a verified sprite atlas.

## Purpose / sources
This art direction updates the generated concept sheet shown in conversation after the owner's explicit critique: **ORG less humanoid and far more alien visceral life; MAN maximally diverse silhouettes; ETH UFO/Interstellar with a little anime/manga**. The attached 2026-10-11 logistics discussion confirms the physical MIN/MID/MAX transports and construction behavior; relevant mechanical sources are [faction logistics](../design/faction-logistics-2026-10-11.md), [MIN/MID/MAX logistics](../design/logistics-min-mid-max-2026-10-11.md) and [unit-scale YAML](../design/logistics-unit-scales.yaml). **Image-generation posters are art references only, not individual transparent runtime sprite atlases, animation proofs or pixel-perfect technical samples.**

The displayed prior poster has a text label "swarm" under ORG. Correct interpretation is **many individually specialized organic organisms**; no compulsory central hive mind or shapeless world-consuming super-being, as per [independent agents](../design/individual-agency-and-composable-civilizations.md). Art should visually demonstrate individual jobs, not brainless interchangeable drones.

## Approved identity & exact names
| ID | Short / MID | Full |
|---|---|---|
| ORG / org | Organs / Organites | Organites Reproductive Generalismus |
| MAN / man | Manus / Manusians | Manusians Augmented Navigators |
| ETH / eth | Eters / Etherans | Etherans Transcendent Hypervisors |

## Shared art philosophy
- A classic top-down/isometric 1990s pixel-art RTS readable at very low resolution; silhouettes before decorative detail, broad value separation, recognizable motion.
- Original IP. **Inspiration ≠ tracing/repainting Giger's Alien, Factorio Biters, Protoss, UFO films, Z, Warhammer, Interstellar movie hardware or specific anime character designs.** Do not use copyrighted character silhouettes as finished sprites.
- One logic world, three camera modes: Overlord (isometric), Direct Unit (near-top-down/optional later TPP), FPS possession; asset plan must support camera proximity without expecting one 16-pixel overhead sprite to magically become a first-person 3D model.
- Each moving MIN/MID/MAX actor has a recognizable 1-second animation and visual cargo indication. Show transfer/charging/loading; no silent teleports, instantly vanishing cargo, magical spawning.
- Independent specialists each have distinctive silhouette + signature verb and pose. Avoid the generic "same humanoid with changed helmet/weapon" across seven roles, especially for ORG and MAN.
- Palette: ORG deep muddy green, black-violet, wet bone, oxidized red and subtle sickly luminescent pustules; MAN enamel blue, greys, utilitarian orange/yellow hazard markings, each material family recognizable; ETH near-black cosmic backdrop, chalk-white ceramics, iridescent indigo, soft violet/cyan rings and limited warm accents. Distinguish factions primarily by **shape and animation**, not team color alone.
- Optional team colors should map onto fixed areas and remain readable for red/green color-vision deficiency; no color-only targeting.

## ORG — Organites: truly alien specialized organisms
### OWNER art direction
Less humanoid, more evocative of dark biomechanical horror and unsettling life. Keywords: Giger-like mood, fungal stalks, blisters, wet sacs, mucus, rotting growths, cysts/boils, creeping worms and the diversity of creatures seen in the base Factorio game. The source phrase "falkow" is ambiguous; do not canonize a named creature anatomy from it without clarification.

### Forbidden default shortcut
No upright humanoid shoulders, two arms/two legs, rifle in hands, standard marine torso, generic Xenomorph long-headed silhouette, matching copies of Factorio's recognizable Biters/Spitters. Organic life should be visually legible, **not** a single undifferentiated shapeless blob. Even slime-bearing organisms have stable anatomy enabling a role and attack tell.

### Unit shape vocabulary (all proposals)
- MIN worker: small 4–8 legged grub/mollusc with prominent scoop/pincers and visibly swollen cargo crop; fast, distinctive harvest antenna; 100% nonhumanoid.
- MID harvester: low-bodied worm or shell-bearing crawler with multiple independent cargo vesicles, tentacular grabbing stalks, heavy gait; carries several slots; slower gathering/movement than MIN.
- MAX mother: enormous **flying biological cargo creature** with buoyant bladders, hanging sacks and grasping tentacles, broad readable silhouette, **conspicuous loading/unloading points** on both flanks. **Starts with fly -> stop/hover -> receive one worker/one cargo item -> fly -> stop/hover -> dispatch one at a time**; in-motion receive/dispatch is a **researched mid-game** ability, limited extra ports later (DEC-011). May carry specialist passengers. This is not a queen-mind/psychic hive. Move path must remain readable from far above.
- Combat roles as highly specialized unrelated anatomies: pouncing thorn-stalker (Fighter), spore/spit organ (Shooter), long-range gas-pod siege worm (Artillery), plated rolling shell (Tank), membranous aerial organism (Flyer), two-sensory-lobe coordinator/healer (Specialist), not 7 humanoid classes with different guns.
- Architecture: living chambers, branching **physically connected** breathing vascular tissue growing outward from an anchored Nexus, colony-grown storage and incubation, small accents of fungi/mucus (not a continuous Zerg-like green creep carpet), strong negative space allowing clicking and placement. New buildings sprout where nourished tendrils arrive; branches without their rooted connection gradually wither and remote branches additionally need home-origin physical feeding.

### Physical logistics animation beat
MIN extracts a finite packet -> cargo crop visibly fills -> approaches a **stopped** MID or hovering MAX mother for sequential handoff, one worker/item at a time -> mother loads an occupied sac -> moves on its cyclic route -> stops at destination to dispatch -> workers take the sac to a rooted vascular branch. **Only later research** allows a mother to receive/dispatch while moving. If a distant rooted building misses periodic **home-origin nourishment deliveries** or its vascular link is cut, show an independent visible starvation/wither warning; failed handoff visibly retries. No free cargo cloning, and growth/build resource usage remains finite.
Build tiers from owner notes: ORG MIN grows L1 building, MID grows L2, mother/MAX can support growing L3; building level != chassis scale.
Gameplay risk read at a glance: very large moving mother can be ambushed; no generic immortal floating base.

## MAN — Manusians: make every family look different
### OWNER art direction
Variety is a civilization signature. Avoid a row of blue-armored nearly identical humanoids. Include real human faces or helmets, pressurized space suits, industrial laborers, exoskeletons, powered armor, mechs, vehicles, rigs, robots, articulated autonomous tools. Their coherence comes from engineering principles, modular fasteners, manufacturers' badges, hoses, painted steel and physical logistics—not one silhouette.

### Distinct unit families (proposed)
- MIN independent miner/mechanic: human in a working vacuum suit **or** compact autonomous drilling rover; manually harvests/hauls one small load; repairs nearby machines/buildings where authorized and physically supplied.
- Infantry shooter: visibly human sized, non-identical to worker's stance and kit.
- Exosuit: broad powered limbs and mechanical joint geometry; movement slower/heavier than infantry.
- Mech: unmistakably taller articulated piloted/autonomous industrial walker; cockpit and leg silhouette.
- Wheeled/tracked vehicle: low horizontal body and wheel/tracks; anti-vehicle or convoy identity.
- Artillery: trailing/long barrel and recoil silhouette separate from mech/infantry.
- Air reconnaissance/transport: aircraft/drone with a different silhouette, not simply floating heavy infantry.
- Autonomous AI/cybernetic mutation (Akira/Strogg inspired) are **unit families within MAN**, not compulsory independent playable factions. Reject direct recognizably copyrighted designs.

### MAN logistics shape grammar
Base fantasy: **an independently repositionable assembly of modular facilities**, not a single fixed Nexus. Specialized modules walk on articulated legs or crawl on tracked platforms; industry can form self-sufficient islands without a home tether, subject to normal fog-of-war.
- MIN: compact independent mining bot or engineer; direct harvest and fallback carry/repair.
- MID: **mobile articulated conveyor platform in 3-cell and 5-cell lengths**, with visible cargo packages physically riding individual belt segments, junction handshake and readable direction arrows/lights. **Also has a one-person bunker configuration** with a visible real soldier inside; it cannot operate belt/bunker/wall at full throughput simultaneously.
- MID defense transition: **Sentry Wall** unfolds and disconnects from the cargo line; ejects remaining real packages behind the chosen wall-facing into legal cells/receiver; belt stops flowing during fortification. Show side shields and barrier teeth.
- MAX: **slow ground-only mobile warehouse** on wide tracks/wheels with tall boxy silhouette, distinct storage doors/slots. May settle into **Bunker**; ejects cargo to legal local space/depot before transformation and deploys firing apertures/occupant slots. Does not fly.
- MAN repair: a visible retractable weld/arm tool, finite carried materials and cycle time; repair other units/buildings, not unlimited free regeneration.
- Long conveyor chains are allowed but visibly expensive/attackable, with finite throughput, splitters, buffers, exposed chokepoints and time costs when converted to defenses. Do not visually turn every square of terrain into a thick blue belt.

### Physical logistics animation beat
Miner removes Matter packet -> miner deposits on belt feeder -> packet physically passes along finite 3/5-cell segments -> splitter chooses branch and fills finite buffer -> MAX warehouse receives packet -> upon attack, MID flips to wall or MAX to bunker, stops cargo service, physical cargo packages unload behind protection -> repair units restore damage using finite materials. The **cargo is always conserved**.

## ETH — Etherans: UFO + Interstellar + restrained anime/manga
### OWNER art direction
Less conventional shiny gold Protoss fantasy or medieval crystal palace; **more enigmatic UFO technology, Interstellar cosmic silence and orbital geometry, with a touch of sleek anime/manga machinery**. Smooth ceramic hulls, magnetic levitation, gravity ring silhouettes, subtle anime-like dramatic compositions, uncanny calm, large negative space and precise light; no overwhelming magic crystal spikes or ornately gold-plated armor.

### Distinct shape families (proposed)
- MIN: tiny levitating courier/extractor resembling one clear saucer, folded-lens probe, or compact disk with visible single cargo capsule.
- MID: **canon multi-mode PYLON**: stepped geometric core, compact halo, visible cargo compartments and distinct poses for STORAGE, NETWORK RELAY and TURRET. Its construction beam relay is visible in NETWORK mode. Optional specialized **meditation -> levitating move** must be visually distinct and suspend incompatible operations. The former mobile Relay Skiff may remain as a separate specialist craft, but is **not the default MID economic role**.
- MAX: **NEXUS-class from initial deployment**: monumental ancient-alien *pyramid/ziggurat/quasi-sphinx* foundation plus domes, orbital halos, lenses and archives. The MAX is not the previous mere pylon-with-big-turret. It stores local architectural patterns, supports network construction and anchors self-operating remote ETH expansions after initial sync. Only specifically equipped structures may later levitate after costly meditation.
- Combat elites: slim, economical designs with radar/lens head shapes and optional stylized anime accents, little resemblance to Protoss Templar gold pauldrons. Hunter specialists may have stealth optics/ritual gear without reproducing Predator mask/weapons.
- ETH construction: MIN stays at site in **NETWORK mode** with a blue energy beam to the nearest eligible larger MID/ MAX node for finite time; it does not drop a Protoss sphere then fly off. MID pylon supports relay construction and conditional defensive turret stance; MAX is immediate Nexus. Beam exposure has strategic significance, but how much the enemy detects through fog is still open. Show meditation in several deliberate visual phases with clear input/output lock.

### Physical logistics animation beat
Small courier/saucer picks up a finite physical capsule -> delivers to a **MID pylon** -> MID switches STORAGE/NETWORK roles to route or accept finite couriers -> local **MAX Nexus** receives/stores patterns and anchors construction. Under attack a MID pylon closes transfer gates, meditates for a visible duration and shifts to TURRET while **keeping its cargo sealed**, rather than MAX becoming a turret. When an ETH MIN builds, a visible blue beam reaches a valid higher node and stays active until construction completes. Every handoff has range, time and inventory state. ETH control is spatial network topology + timing, not magical resource teleportation.

## Mandatory clarity: distinguish same-tier transport silhouettes
| Tier | ORG | MAN | ETH |
|---|---|---|---|
| MIN | Fast tiny worm/grub with jaw/scoop/crop | Human mining suit or small drill rover, visible manipulator | Small flying saucer/probe with one cargo capsule |
| MID | Armored low crawler with multi-sac back | 3/5-cell tracked conveyor / 1-person bunker / outward sentry wall | Multi-mode pylon with STORAGE / NETWORK / TURRET poses; specialist levitation after meditation |
| MAX | Giant **flying** mother with hanging sacs + loader arms; hover to load at first | Huge **ground-only** track depot deployable as bunker | **Nexus-class** ancient pyramid/ziggurat with dome/orb/halo and local pattern archive from first deployment |
| Movement identity | Roaming and looping | Building connected corridors | Physical courier shuttles + network handoffs |
| Defense identity | Escort/evasion + living protection | Reconfigure belt/depot as fortification | Sacrifice pylon throughput during meditation/defense |

## Art sequencing: only build what validates the mechanics
**A0:** style board, neutral terrain, 3 faction silhouettes, transport silhouette comparison. **The existing generated art board is A0 only**, and may contain generative misspellings, premature unit features or incorrect tile labels.
**A1 (technical sprites):** one ORG MIN, MID, mother and one traceable vascular-bud structure; one MAN MIN, 3-cell MID (including bunker/wall poses) and MAX depot; one ETH MIN NETWORK builder, MID pylon (storage/relay/turret poses) and MAX Nexus pyramid; plus one shared deposit, one neutral package and an unobstructed grid. Use silhouette blocks/rough 4-frame cycles before polished art.
**A2 (animation proving physical logistics):** ORG mother **stops** to load/unload early, demonstrates **researched** moving transfer later, ORG vascular branch cut/wither; MAN belt packet flow, one-person bunker and wall mode; ETH MIN blue construction beam, MID pylon cargo lock/meditation and MAX Nexus expansion pattern sync.
**A3 (gameplay art):** one MAN Hero (Engineer/Commander/Specialist starting-kit differentiators), one hostile actor, buildings and obstacles for Overlord->Direct->FPS test.
**A4 (production later):** 8-direction move/facing sprites if demonstrated necessary, terrain transitions, shadows, health/cargo indicators and distinct combat animations per family.

## Practical image generation constraints
- The current image is a **composite concept poster** (labels, multiple scenes, illumination effects), not a pixel-perfect 8/16/32/64px indexed palette spritesheet. Do **not** crop it blindly and treat the result as transparent individual game sprites.
- Game assets need explicit transparency, alpha edges, grid alignment, source/author/rights, scale metadata, unit anchors, facing directions, action frames and separate shadow/selection layers.
- For game shipping, regenerate clean individual sprites or paint/redraw original sprite assets based on art direction, and validate alpha frame bounding boxes and readability at minimum 320×240. AI concept art must be art-reviewed before being used as source asset.
- A small FPS close-up cannot use a 24–48px RTS sprite as though it were fully modelled: pair hero sprites with simple Godot 3D body/collision/low-poly proxy or specifically authored FPS visual representation, with the **same underlying actor and equipment**.

## IP and gameplay guardrails
- Do not reproduce specific xenomorph cranial contours, recognizable Factorio Biter jaw arrangements, Protoss crests, Stargate symbols, Interstellar film ships, Lem characters or Z character asset outlines.
- ORG individual agents retain autonomy; monstrous biology is not automatically one hive mind.
- ETH aura is technology/awareness; not a resource teleporter or guaranteed supernatural omnipotence.
- MAN engineering silhouette diversity is welcome but must remain equally legible when 20 units occupy the same battlefield.
- No aesthetic details may create a new fourth resource or override finite transport/repair/build costs.
