# Scalfagus MVP — Native Godot RTS HUD, Orders and Three-Camera Input

Date: 2026-10-11
Status: proposed executable MVP contract for coding agents; exact UI geometry and hotkey refinements are candidate values.
Owner baseline: F1 Overlord RTS, F2 Direct Unit/TPP, F3 FPS on **the same Hero/entity/world**; RTS WASD pans map, Q/E rotate, scroll zoom; unit selection and a usable RTS HUD. Current native Godot spike already has menu and three cameras but not the complete RTS selection/economy/HUD. Preserve existing stable actor state.
Main delivery plan: [MVP delivery gates](MVP-DELIVERY-GATES.md), [machine inputs](mvp-hud-and-input.yaml), [roster](mvp-man-eth-catalog.yaml), [game acceptance](mvp-man-eth-acceptance.yaml).

## One window, one world

All input/UI is implemented in **Godot Control + 3D camera/controller scripts**, not Tauri, Electron, WebView or a separate scene with a second authoritative game simulation. RTS/Direct/FPS camera modes observe and interact with the same 3D buildings/units, trees, platform border, source inventories, enemies and fixed tick combat.

## Essential player controls

| Context | Input | Expected action |
|---|---|---|
| All | F1 | Enter Overlord RTS camera / RTS command context |
| All | F2 | Direct/third-person possession of SAME Hero (retains HP, cooldown, location) |
| All | F3 | FPS possession of SAME Hero (retains HP, cooldown, location) |
| All | Tab | Cycle views (existing spike) |
| RTS | WASD | Pan camera along planar X/Z over valid platform map; **do not move Hero** |
| RTS | Q / E | Rotate RTS map camera left/right about a target or pivot |
| RTS | Scroll up/down | Zoom in/out within limits (not change elevation/map geometry) |
| RTS | Left-click unit/building | Select team-owned entity, show action/info details |
| RTS | Left drag | Draw rectangular selection and select eligible owned units inside region |
| RTS | Shift + left-click | Add/remove selected owned unit (candidate) |
| RTS | Right-click empty ground | Move selected mobile units to valid ground target |
| RTS | Right-click surface SOLID source with worker | Harvest; deliver to eligible local store |
| RTS | Right-click enemy building/unit | Attack if selected unit can legally target and has sight |
| RTS | Right-click valid site with builder order | Build planned structure using legal local materials |
| RTS | Right-click visible ground loot with suitable worker | Collect and haul physically; no instant global credit |
| RTS | HUD action buttons | Build Mother-issued worker queue, UMU/Pylon, barracks, soldier queue, pack/deploy, switch mode, salvage, repair |
| Direct/FPS | WASD | Move the **same Hero actor**, not the RTS camera |
| Direct/FPS | Mouse | Aim/orbit actor as existing camera semantics; retain collision and network game authority |
| FPS | Escape | Release captured cursor / pause/menu according to current native menu state |
| All | UI click on world backdrop | Do not select galaxy, distant planet, platform underside as enemies or resource source |

Preserve existing working Godot input where it already matches these intentions; remove conflicts only when necessary. For example pressing Q/E in RTS rotates the camera, whereas Direct/FPS may use existing aim behavior. Input contexts must not both move the Hero and RTS camera simultaneously.

## Minimal HUD regions

- **Top bar:** available locally legal Matter, stored/usable Energy, worker count, population/support used/cap, current faction and match phase. No Liquid/Gas counters suggesting those resources are collectible in first map; optionally show disabled entries only in explicit developer debug mode.
- **Bottom left:** minimap / radar of 64×64 flying jungle platform, 2 starts where explored, known SOLID rocks/deadwood and visible enemies. Platform outside square is empty starfield, not extra pathable territory.
- **Bottom center:** selection card of unit/building(s), current HP, movement/mode, worker cargo, queued jobs and costs. Show `victory_building` classification in debug overlay; optionally player-facing icon for building-class mobile UMU.
- **Bottom right:** context-sensitive actions for 5-role MAN and ETH templates; train worker/infantry, construct infrastructure/barracks, harvest, deliver, attack, repair, salvage, pack/deploy and one mode switch.
- **Alerts:** `We need more Solids` when legal Matter inventory lacking; later `We need more Liquids` and `We need more Gas` reserved but **not emitted as impossible demands on the solid-only map**. Distinguish insufficient Energy/UMU power from missing Solids. Network disconnect alerts for ETH/MAN and stalled building status are important even before fancy dashboards.
- **Match outcome:** Victory/Defeat overlay when enemy has zero valid completed living building-class entities, including packed/moving UMU. Pause/Restart/Return to Menu.
- **Camera mode label:** Overlord RTS / Direct / FPS so user understands current input lease. Switching never resets selection/Hero state except via user action.

## RTS selection/commands and world boundaries

Only selectable game entities with actual world positions and visibility may enter a selection. Draw rectangle in screen space; resolve actual owned 3D actor selection with projected positions. Do not include noninteractive space backdrop, decorative platform frame or hidden enemy entities. Camera pan has bounded footprint with limited edge padding so it can show the visible platform rim and some cosmic outside, but **cannot move gameplay actors out of bounds**.

Orders are submitted to one central command validator:
1. Eligible actor ownership, command type and viewport mode.
2. Legality (ground unit movement, team sight/fog, target HP, required equipment).
3. Real time/physical resources and local network connectivity.
4. Accepted/rejected result with clear in-HUD reason; game state changes only via authoritative simulation tick.
5. Worker autonomy obeys player task/policy and no unapproved strategic self-expansion.

## Faction-specific UX hints

- **MAN:** UMU button cycles deployed generator-warehouse, deployed generator-bunker, packed ground travel; explain support/power and inventory unavailable in travel. Show real nearby crate count and nearest accessible source for worksite; hybrid cable service and range visually.
- **ETH:** pylon visualization indicates network links/Nexus path, current available typed Ether balances, storage or turret mode, relay rate/brownout. Do NOT invent two separate ETH networks in UI. Construction preview draws the real blue worker→Nexus/channel link and indicates site committed vs remote reserved resources.
- **Cross-faction loot:** amber solids shown as MAN cube or ETH orb; origin packaging does not prevent enemy worker collection. Show separate `loose world packet` icon and count; no UI duplication with original depot inventory.
- **Combat:** tree trunk hard LOS and collision should be clear when issuing blocked attack orders. Fade leafy canopy covering selected units without disabling cover collider.

## Production UI

MAN Command Core and ETH Nexus train MIN; MAN Barracks and ETH Manifestation Chamber train the basic soldier. One FIFO queue per producer; buttons show real Matter cost and operational Energy, queue progress and support cap. If queue cannot start because of no Matter, unreachable packet, no Energy, no local connection or no supply, show correct reason instead of phantom global wallet.

## Native screen-size and accessibility test

Existing project offers 960×540 / 640×360 / 320×240 resolutions. Use readable minimal HUD first at **960×540**, then verify no critical buttons, selection counts or win overlay clip at lower presets. Keep text readable at original retro output scale; avoid relying only on SOLID amber color to distinguish a loot type. HUD must tolerate long entity names and zero inventory counts without overlapping menus.

## Acceptance/test requirements

- RTS WASD pans map without moving Hero; Q/E yaw rotates about focus; scroll zoom respects min/max.
- Right-click orders fail safely on outside-platform space or impassable water; bot and players share legality.
- Unit drag selection works for multiple owned soldiers and skips enemy world-frame assets.
- F1/F2/F3 never spawn multiple Hero objects, change HP or grant units free vision.
- Top bar reports REAL scoped balances, not double-counted across worker cargo/Nexus/ETH edge.
- UMU remains building-class if packed; turret Pylon remains building; victory transition correct.
- Invalid build from a resource deficit shows appropriate message and doesn't consume resources.
- Game over restart resets world, RNG and event ledger once; does not reuse stale drops or add duplicate inventories.

## Explicitly deferred UI

Advanced unit grouping, dozens of tactical stances, configurable hotkey editor, network graph debugging dashboards, 5+ producer panels, multiplayer chat, full campaign navigation, planetary travel GUI, spherical globe minimap and ORG water-unit interfaces are post-MVP.

**Note:** A design YAML and Markdown requirement alone is NOT UI implementation. The agent must integrate real Godot `Control` scenes, input-map actions, authoritative RTS click picking and native headless/unit/UI smoke tests.
