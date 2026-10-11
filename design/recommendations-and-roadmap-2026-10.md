# Consolidated recommendations and delivery roadmap
Date: 2026-10-11
Status: recommended, not a delivery commitment.

## Product thesis
Ship an excellent ~30-minute autonomous RTS first. The unique hook is an observable AI base that the player can direct or take over, not maximal simulation complexity. Extend one tested system to strategic MID and open-ended industrial MAX.

## Design hierarchy
Core simulation: resource conservation, ownership, fog, unit capability, deterministic order acceptance.
Session context: campaign/skirmish/multiplayer.
Match scale: min/mid/max.
Control preset: autonomous_rts/classic_rts/architect/commander/avatar/hybrid.
Controller slots: human/scripted_ai/llm.
Scenario: map, objectives, teams and rules.
All layers compose via a validated, versioned resolved config; no combinatorial menu of disconnected game modes.

## Inspirations, trimmed by relevance
- Warcraft II + StarCraft: immediate, readable RTS controls and asymmetric combat, across every scale.
- Z: contestable sectors, factories, dynamic frontlines; high value in MIN.
- Dungeon Keeper: meaningful autonomous base, worker doctrines and possession; autonomy in MIN, direct FPS much later.
- Settlers I/II + Factorio: finite inventories, visible cargo movement, depots and production; complexity scales MIN to MAX.
- Earth 2150: meaningful unit chassis/weapon customization and terrain; presets in MIN, combinations in MID, optimization in MAX.
- Civilization I/II: tech trees, scouting, specialization, diplomacy and megaprojects; short research MIN, long-horizon systems MAX.
- Battlezone II + Machines: RTS/direct possession on one world, future feature.
- Aliens vs Predator + Enemy Territory/Quake Wars + Tribes 2 + Quake III: race-specific FPS and objectives, future gameplay not Alpha prerequisite.
- LLM lab: strategic agents via same validated game API; observer-only tournaments after stable deterministic simulation.

## Recommendation matrix
| Capability | MIN first | MID extension | MAX extension |
|---|---|---|---|
| Core RTS + combat + fog | required | inherited | inherited |
| Base planner and intervention | required | multi-base | multi-colony |
| Matter/Volatiles/Energy | required | same | same |
| Hauling and stockpiles | automatic compact | route disruption | freight optimization |
| Research | curated | branching | long-term |
| Unit designer | preset loadouts | module select | deep specialization |
| Diplomacy/espionage | exclude default | optional scenarios | optional |
| LLM observer/co-player | API foundation, optional | beta | tournaments |
| FPS possession | no dependency | future experiment | optional |
| Large shared-team multiplayer | defer | proof of concept | later showcase |

## Executable sequence and gates
P0. Compare Godot, Recoil and Babylon.js using same headless economy + selection + deterministic action test. Choose empirically; FPS capability matters but must not dominate early selection.
P1. One-faction MIN vertical slice: AI builds productive base; human overrides; 3 resources; basic combat; one victory objective; no hidden AI resource grants.
P2. Three-faction MIN alpha/beta: starter loadouts, balanced matchups, rapid UI, maps, observer/bot test harness, telemetry and human testing. Target 20–40 min and retain legacy 25–40 standard 1v1 hypothesis.
P3. MID: multi-base specialization, routes and disrupted supply, extra terrain mechanics and modules. Target 40–80 min without padded costs.
P4. LLM beta can parallelize after agent contract: provider-neutral local/API clients, bounded observations and actions, budgets, fallbacks, action logs, observer, multiple-model competitions.
P5. MAX: large networks, multi-colony, long save/resume, optional diplomacy, science and megaprojects, sustained unattended simulation.
P6. FPS hybrid and larger multiplayer: one authoritative RTS world, faction-specific direct controls, multiplayer permission/arbitration. Not core MVP.

## Balancing / QA
- Track full distributions of match length and faction win rates; do not call subjective 7/7 inspiration ratings development commitments.
- Human and AI difficulty results are separated; LLM strength is NOT faction balance.
- Add strategic choices, not only higher HP and prices, when lengthening MID.
- Limit overpowered first rushes and unwinnable late-game turtling; meaningful scouting/counterplay for every race.
- Test automatic base development and complete manual strategy with identical economy checks.
- Confirm disruption of a bridge/depot actually disrupts supply; test AI recovery.
- Conserve Matter/Volatiles/Energy in all scales; avoid phantom cargo shortcuts.
- Show why the AI chose a building and why any factory is stalled.
- In LLM matches record accepted actions, model metadata, token/cost stats and timeouts for replay and comparisons.
- Do not let non-shipping features pollute MIN UX.

## Follow-up to DEC-014: full building relocation is optional research

The complete conversation is indexed in [faction economy and construction](faction-economy-and-construction-conversation-2026-10-11.md).
The proposed ability to transplant whole ORG buildings slowly through living vessels or
move ETH buildings faster via an Energy-costed railgun beam remains **OPEN / NOT APPROVED**;
see [building relocation options](building-relocation-design-options-2026-10-11.md).
Existing MAN tracked/mobile modules and selected ETH meditation/levitation are kept distinct
from free-moving every constructed building. A first playable MIN economy should
be complete and balanced **without** whole-building translocation. Evaluate any such
feature later against strategic expansion, fog of war, cargo conservation, siege,
map control and player micro-management.

## Cuts
No mandatory individual hunger/morale cycle; no large catalog of crafting reagents; no detailed per-unit organs or damage system; no bureaucracy/legal simulation; no required micromanagement of carriers; no FPS or LLM dependency for basic skirmish.

## Questions needing future approval
Winning condition and map roster for MIN; mandatory features vs custom toggles; starting income and pace; choice of engine after benchmark; MAX time controls and save policy; definitive roadmap scope and estimates.
