# Scalfagus Coding-Agent Playbook: Discover → Wrap → Verify

Effective 2026-10-11: **DEC-034 Reuse First**. Read [ADR-0004](../architecture/adr-0004-godot-reuse-first-wrappers.md) and the [module registry](../architecture/godot-third-party-candidates.yaml) before editing gameplay code. Do not reintroduce Tauri. Do not override the newer **DEC-033 MAN-vs-MAN RTS micro MVP** with old MAN+ETH/TPP/FPP tasks.

## Mandatory before-you-code search

For each new feature/subsystem/component:

1. **Search current Scalfagus:** relevant `.gd`, `.tscn`, `/addons`, `.yaml` and open PR branches. Determine whether a port or node is already implemented or in review.
2. **Search the pinned Godot 4.7.2 docs:** identify classes, current methods, known limitations; built-in functionality has priority over copied code.
3. **Search Godot AssetLib and at least one relevant GitHub source** when engine primitives do not sufficiently cover the task. Inspect `README`, license, release/tag/commit, issues, binary/native dependencies, maintainer history and required OS/Web exports.
4. **Record an explicit decision:**
   - `REUSE_EXISTING`: modify existing repo wrapper/scene; no new framework.
   - `WRAP_GODOT`: thin GDScript adapter on Godot built-in node/service (default).
   - `WRAP_GITHUB`: pinned, audited GitHub module behind the port, with a minimal integration spike.
   - `GAME_DOMAIN_CODE`: only Scalfagus-specific rules/protocol, with at least two rejected reusable alternatives or a clear statement why generic modules cannot implement the unique rule.
5. **Run proof before merge:** Godot 4.7.2 headless import/tests plus manual macOS GUI tests for camera, selection, rendering and controls. Add Windows/Linux/Web export checks for runtime extensions; do not claim tests executed if only YAML/mock assertions passed.

## Agent output required in each PR

Paste this under `Reuse evidence` (fill every answer):

```text
Feature / micro MVP gate:
Existing Scalfagus component checked:
Godot API used + official documentation URL:
GitHub/AssetLib candidates checked + link:
Decision (REUSE_EXISTING / WRAP_GODOT / WRAP_GITHUB / GAME_DOMAIN_CODE):
Why chosen + why alternatives were rejected:
Wrapper / interface and its callers:
Dependency release + FULL pinned commit + license/notice (or N/A):
Godot 4.7.2 import test: PASS/FAIL/NOT RUN (logs/link):
Unit/integration tests: PASS/FAIL/NOT RUN (command + evidence):
Manual UI, Windows/Linux/Web checks: PASS/FAIL/NOT RUN:
Security/fog/authority/stock checks:
Rollback procedure:
```

**No boilerplate 'all good' acceptance.** If plugin license, version, release build or source are unclear, mark `blocked_upstream_review` and keep the builtin fallback. Preserve source attribution in `THIRD_PARTY_NOTICES` when vendoring. Never dynamically download third-party scripts from the internet in shipping game code.

## Provider behavior examples

### RTS move command
- `RTSCameraController` wraps `Camera3D` + `InputMap`. It emits view changes only.
- `SelectionPort` wraps Godot raycasts and filtered snapshots; returns stable `entity_id`s, not raw physics nodes for user authority.
- `CommandGateway` validates slot/tick/fog/cost and commits a legal move order.
- `NavigationPort` wraps Godot `AStarGrid2D` and maps XZ grid positions to 3D. It caches/invalidate cells after new buildings or destroyed obstacles. Do not write a bespoke A* or trust client's precomputed path.
- `UnitMotionPort` wraps `CharacterBody3D`; follows chosen waypoints and reports blocked/stuck outcomes.
- `HUDPort` wraps Godot Controls showing selected units/command state. Debug minimap is not fog-safe until gated.

### Bot movement in headless C-C
The bot asks for **exactly the same Move command** as a human. It does not mutate `CharacterBody3D.position` directly. Its policy may later be produced by an approved statecharts addon; gameplay legality remains in the host `CommandGateway`.

### Netcode (H-H)
Use `ENetMultiplayerPeer` rather than a new UDP stack. Network input is UNTRUSTED. Ownership and fog are checked server-side; replicate filtered snapshots, not a complete exposed GameState. Headless bots and host-client paths share simulation and command validation; no silent rule differences.

### Menus and control remapping
Use `Control`, `Theme`, `InputMap`, `ConfigFile`; add Keychain only after it proves 4.7.2, profile persistence and key conflict handling. No HTML/CSS/React launcher.

## Third-party upgrade PR rules

- Vendor only reviewed **full immutable commit or verified release** in `apps/game/addons/vendor_id/`; pin metadata in [registry](../architecture/godot-third-party-candidates.yaml). If a source archive is used, record SHA-256 and upstream release page.
- Keep vendor code unmodified; customize behavior in `scripts/adapters`. If a fork is needed, record the fork/patch and license.
- Bring license/notice with source. MIT plugin license does not necessarily cover bundled sample sprites/fonts.
- Audit autoloads, editor privileges, data persistence, filesystem/network accesses, compiled native binaries and dependencies.
- Do not require unsupported GDExtensions for macOS/Windows/Linux/Web because a plugin demo works on a developer's platform.
- Verify uninstall/rollback without losing `GameState`, data schemas or player input bindings.

## MVP-specific acceptance focus

Current release is **MAN mirror classic RTS**: [DEC-033 YAML](../design/mvp0-man-mirror-rts.yaml) and [acceptance fixtures](../design/mvp0-man-mirror-acceptance.yaml). First priorities are camera/selection/navigation and shared authoritative commands, then real Matter worker delivery, Barracks, Rifleman, fair H-C/C-C bot, native LAN H-H, all-completed-buildings victory and deterministic replay/metrics. Do not spend MVP budget on ETH, possession polish, exotic shaders or a generalized ECS framework before these pass.

## If you cannot find reusable code

A short, well-tested **game-specific component** is acceptable. Explain why all relevant built-in and GitHub choices were unsuitable, state its public port, expose no forbidden authority, and add tests. The rule is **no unnecessary reimplementation**, not 'make Scalfagus impossible without a GitHub package for every line of code'.
