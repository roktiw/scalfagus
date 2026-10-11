# Scalfagus — MVP 0.1: One-Faction RTS, Two Player Slots

Date: 2026-10-11
Status: **owner-approved release-scope decision DEC-033; design only, not implemented**.
Canonical machine-readable scope: [mvp0-man-mirror-rts.yaml](mvp0-man-mirror-rts.yaml).
Acceptance: [mvp0-man-mirror-acceptance.yaml](mvp0-man-mirror-acceptance.yaml).
Agent sequence: [mvp0-man-mirror-backlog.yaml](mvp0-man-mirror-backlog.yaml).

## The entire promise

**One real, finishable classic RTS game**, exactly two players, the **same MAN faction on both sides**, three interchangeable controller combinations:
- **Human vs Human**: two separate Godot game clients connected to one locally hosted authoritative match, via loopback or LAN. No split screen, hotseat, Internet matchmaking, accounts or cloud required.
- **Human vs Computer**: same match; slot 1 human, slot 2 deterministic legal scripted bot; optionally reverse slots.
- **Computer vs Computer**: both slots scripted legal bots; playable headless at accelerated speed or observable in a graphical spectator view at normal speed.

Both slots are generic `player_slot` objects. A player is human or bot; that selection **must not change rules, unit stats, ownership, fog or legal command validation**. MAN vs MAN mirrors prove that the RTS is fun, responsive and fair before ETH, ORG or asymmetric balance.

## Product cut line

**In:** Godot 4.7.2 Standard + typed GDScript; one floating-space-platform map Verdant Divide (brown-soil jungle, visible rim/space, hard world bounds); fixed authoritative simulation; two mirrored starting bases; select units; move/attack; gather finite SOLID→Matter and deliver it physically; build one barracks; train worker and rifleman; combat, LOS blocked by trees, victory/defeat, bot, LAN/loopback session, menu/HUD, restart, logged reproducible bot matches.

**Out:** ETH and ORG playable; faction-specific Ether networks; MAN UMU and its modes, cable conveyor networks, crates beyond actual worker cargo, salvage/recycling, energy supply grids, liquid/gas mining, hero progression, FPP possession, TPP/Direct unit, air/naval units, orbital travel/platform motion, fog-of-war sophistication beyond small radius visibility, upgrades/tech trees, multiplayer over the public Internet, matchmaking/lobby accounts, editor, mobile/web release, LLM bot actions per tick.

This is a **temporary simplified initial ruleset**, not a rewrite or rejection of approved full Scalfagus faction lore. All original designs remain archived future targets. DEC-030 mandatory space platforms still applies. DEC-031 defines future RTS+FPP final perspectives; **this micro-MVP exposes Overlord RTS only**, with the existing FPP/TPP spike retained in development but not promised as part of playable MVP 0.1.

## Smallest viable economy and roster

Exactly four MAN templates, not five:
1. `man_command_core` / HQ — the initial completed victory building; trains workers and receives harvested Matter. No separate depot/power-grid in this slice.
2. `man_min` / Worker — moves, gathers finite SOLID into physically carried cargo, returns to HQ and constructs Barracks; no teleporting resource credit.
3. `man_barracks` — one worker can construct it near a valid build site; trains riflemen from available deposited Matter.
4. `man_rifleman` — the only fighting unit: moves, attacks enemy workers/soldiers/buildings with fixed range, cooldown, HP and simple LOS against real tree-trunk cover.

**Resources:** Matter is the only spendable resource in MVP 0.1. SOLID sources are finite, deposit requires an actual worker at HQ and source/cargo/HQ balances must conserve units. **Energy remains canonical in the wider design (DEC-001), but its production/transport/spending implementation is explicitly deferred**, not approximated with unrestricted credits. No second resource icon implying a real mechanic.

**Starting state (candidate fixture):** each side gets one completed HQ and three workers; no barracks or soldiers. Both spawns have mirrored build space and reachable finite deposits. First complete gameplay should use these symmetric starts.

**Win:** eliminate every opponent completed `victory_building`, including their HQ and any completed barracks; if all are lost, match ends. Workers/soldiers left alive do not prevent defeat. No instant win on hero death (the Hero is not required in this micro-MVP). Draw/timeout is explicitly supported: if a scenario time cap is reached or neither side can legally win, report draw with reason, never invent a winner. Surrender is optional, not a substitute for destruction victory.

**Balance numbers:** prices, HP, damage, movement, mining and build/production times in YAML are **unapproved starting hypotheses**, not current canon and not proven balanced. Use versioned overrides for tuning.

## Session and authority

- **Exactly two match slots**, each with `controller_type: human|bot`. `spectator` is an observer, never a third playing slot.
- **One authoritative GameState** per match. A host process (either a human's Godot client or standalone local server) owns simulation ticks and validates commands; clients never send direct world-state edits. The local bot calls the same command validator.
- Human-human MVP: Host on one device and Join from second device on the same LAN; two instances on one device via loopback are accepted for QA. Each client has its own normal Overlord viewport. Avoid split screen and Internet connectivity requirements.
- No prediction/rollback/lockstep promise for MVP 0.1: client orders carry player ID, sequence number, target entity and parameters; host validates ownership, resources, visibility, range and placement, applies on fixed ticks, broadcasts authoritative state deltas or compact snapshots. Invalid/duplicate/out-of-order commands are rejected safely. Keep fixed-order application across slots.
- Only the host generates random values and owns `seed`; replay records accepted command stream + versions/hashes. The same initial state and legal commands must replay to an equal result on pinned runtime; cross-platform bit-identical physics not assumed.
- In **computer-computer** the host can advance ticks without waiting for wall-clock/rendering and emit a structured result; GUI spectator samples the exact same state while running in real time.
- No host migration or reconnect requirement for MVP. Host disconnect aborts the match cleanly. Client disconnect shows a clear result/error rather than freezing or awarding an automatic victory without an approved rule.

## Minimal Overlord UX

Main Menu: Start Match → controller selection **H-H (Host/Join LAN), H-C, C-C (Watch)**; direct CLI for headless bot tournaments.
Overlord only: left-click/select + drag-box; right-click on ground to move and on enemy to attack; worker select resource for gather; Barracks placement after choosing a worker; HQ queue Worker; Barracks queue Rifleman; Stop and attack-move may be deferred until the basic commands are stable.
HUD: Matter count, selected unit(s) HP/orders, relevant build/train button, both team indicators and match timer/result. Clear ownership colors, resource and enemy visibility, no FPP/TPP instructions in the shipped mode. A mini-map, hotkeys and full tutorial are P1 polish, not a release blocker.

## Minimum credible AI

One deterministic scripted economy/combat bot used identically in H-C and C-C:
`collect -> deliver -> build_barracks -> produce_riflemen -> scout -> legal_attack -> repeat`.
No omniscient enemy unit tracking: basic team vision rules shared with human clients. Stuck-path timeout and legal fallback. It must be able to win or lose, not merely wander. Add a second `rush` or `defend` strategy after the first complete game as a balance fixture, not a new LLM runtime.

## MVP quality bars and release gates

1. One client can play H-C from menu to real win or defeat and restart without developer intervention.
2. Two human clients can join the same LAN/loopback match, issue orders simultaneously and observe the same HP, Matter, units and victory; no double creation/split brain.
3. C-C works both in a GUI spectator mode and `godot --headless` CLI, completes without human input and emits versioned JSONL results.
4. A worker actually reaches a source, carries finite Matter back and spends it on construction/training, with **no packet cloning**.
5. Two comparable mirrored starts, bounds respected, physical trees block movement and line-of-sight; water is impassable and unmineable.
6. Host validation blocks issuing orders for enemy units, phantom resources, out-of-bounds building and repeat command application.
7. Deterministic fixed seed + accepted commands yields reproducible logs and end-state hash on pinned runtime.
8. Measure bot match throughput, sim tick rate and memory usage, report actual results rather than asserting a performance target.
9. Legacy F1/F2/F3 smoke is retained while code migration is in progress; player-facing micro-MVP exposes only RTS and never claims FPP/TPP completeness.
10. No ETH, UMU network, hero talent tree or cloud multiplayer work may block first working 1v1.

## Dependency-oriented implementation order

**Vertical Slice A — Single local match:** authoritative state + mirror MAN spawn + worker gathering + one barracks + riflemen combat + victory, all inside one Godot instance.

**Vertical Slice B — Generic bot controller:** one legal scripted bot, playable H-C, C-C in one instance, shared validator.

**Vertical Slice C — Headless batch:** same rules without graphics, unpaced simulation ticks, JSONL stats and replay hash; first MAN mirror tests.

**Vertical Slice D — LAN human-human:** host-authoritative Godot commands/snapshots, Host/Join; two real clients and simultaneous RTS control. This is **required** to ship the specified MVP, not deferred to a later version.

**Vertical Slice E — Quality:** RTS UX, mirror-side parity, no softlocks, end-to-end automated tests, player playtest, packaging.

## What happens next

After proving one-race multiplayer RTS is fun and stable: restore richer MAN logistics/UMU/Energy, then playable ETH with asymmetric economy and comparative headless balance; ORG later. FPP Possession (DEC-031) remains approved for the broader game but is **not required for 0.1**. Do not implement everything simultaneously.

## Supersession and code reality

DEC-033 supersedes **DEC-025's release requirement of two playable factions in the first playable MVP**, along with corresponding `MVP-DELIVERY-GATES.md`, `mvp-implementation-backlog.yaml`, `AGENT-MVP-IMPLEMENTATION.md` old delivery scope and prior three-camera MVP acceptance criteria. Historical files remain valuable *future* references, not the active 0.1 task list. No source code was changed by this design decision; the checked-in Godot game currently remains an engine/camera prototype, not this complete multiplayer RTS.
