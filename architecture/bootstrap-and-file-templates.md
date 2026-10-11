# Scalfagus — Boilerplate and Bootstrap: File-by-file Implementation Blueprint

Date: 2026-10-11
Status: **copyable architecture templates, not a tested working game or already-present source files**.
Companion: [Mono-Blue Tech Seed](mono-blue-tech-seed-2026-10-11.md).

## 0. Pinned tools and operating systems
- Node 24.x LTS: pin exact patch in first actual install; .node-version can advertise '24'.
- pnpm 12.7.0: **example concrete version**, update only after verification.
- Godot 4.7.2-stable Standard (GDScript, not .NET). Fetch authentic upstream binary and checksum; never invent a SHA.
- TypeScript 6.0.3 conservative baseline; TS 7.0.2 can be evaluated after tools and test runner compatibility checks.
- TS tooling after install: Vitest, Biome OR ESLint + Prettier (choose one), TypeBox + Ajv + YAML parser, Vite + React; resolve and pin exact versions in pnpm-lock.yaml after running an actual install.
- macOS Apple Silicon first; Windows x64, Ubuntu Linux x64 second. Tauri 2 + Rust stable optional, NOT a game prerequisite.
- No 'latest' tags in CI. No silent downloads or auto-running curl-to-shell.

## 1. Root package.json
~~~json
{
  "name": "scalfagus",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "packageManager": "pnpm@12.7.0",
  "engines": { "node": ">=24 <25" },
  "scripts": {
    "doctor": "node scripts/doctor.mjs",
    "dev:game": "node scripts/dev-game.mjs",
    "dev:studio": "pnpm --filter @scalfagus/studio-web dev",
    "validate:data": "pnpm --filter @scalfagus/cli validate:data",
    "generate:data": "pnpm --filter @scalfagus/cli generate:data",
    "check:ts": "pnpm -r --if-present typecheck",
    "test:ts": "pnpm -r --if-present test",
    "test:godot": "node scripts/godot-test.mjs",
    "test:contract": "pnpm --filter @scalfagus/cli test:contract",
    "lint": "pnpm -r --if-present lint",
    "ci": "pnpm doctor && pnpm validate:data && pnpm generate:data && pnpm check:ts && pnpm test:ts && pnpm test:godot",
    "package:game": "node scripts/export-game.mjs"
  }
}
~~~
Every command is an intended *contract*; packages/scripts referenced must actually exist before developers can execute it successfully. No dependencies are intentionally guessed in this template.

## 2. pnpm-workspace.yaml
~~~yaml
packages:
  - "apps/studio-web"
  - "apps/desktop"
  - "packages/*"
~~~
apps/game is **Godot-native and not an npm package**. Keep a single pnpm-lock.yaml in root and use workspace: links for TypeScript packages.

## 3. .node-version, toolchain.lock.json and tsconfig.base.json
.node-version:
~~~text
24
~~~
toolchain.lock.json:
~~~json
{
  "schema_version": 1,
  "node_major": 24,
  "pnpm_exact": "12.7.0",
  "godot_exact": "4.7.2-stable",
  "godot_flavor": "standard",
  "typescript_target": "6.0.3",
  "reviewed_release_assets": []
}
~~~
The empty assets list is intentional until an exact authoritative SHA-256 has been independently checked. No freehand hashes.

tsconfig.base.json:
~~~json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "verbatimModuleSyntax": true,
    "isolatedModules": true,
    "skipLibCheck": true
  }
}
~~~
Vite apps should override module/resolution with ESNext/Bundler in their own tsconfig. Pin and verify TS 6-compatible flags.

## 4. .editorconfig / .gitignore / .gitattributes
.editorconfig:
~~~ini
root = true
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
indent_style = space
indent_size = 2
[*.gd]
indent_size = 4
~~~
.gitignore:
~~~gitignore
node_modules/
dist/
coverage/
.env
.env.*
!.env.example
*.log
.DS_Store
apps/game/.godot/
apps/game/**/*.translation
apps/desktop/src-tauri/target/
artifacts/
.cache/
~~~
.gitattributes:
~~~gitattributes
* text=auto eol=lf
*.gd text eol=lf
*.ts text eol=lf
*.yaml text eol=lf
*.png binary
*.webp binary
*.glb binary
~~~
Commit authored assets and YAML, ignore Godot import caches, include LICENSE and THIRD_PARTY_NOTICES when licensing is decided.

## 5. scripts/bootstrap.sh — macOS/Linux, read-only by default
~~~bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
case "$1" in
  --check) exec node scripts/doctor.mjs ;;
  --install) echo "Review/install Node 24, pnpm 12.7.0 and Godot 4.7.2 from verified sources first."; exit 2 ;;
  *) echo "Usage: scripts/bootstrap.sh --check or --install"; exit 2 ;;
esac
~~~
Before implementation, support no-argument default --check safely (shell set -u otherwise rejects missing arg). Never call sudo, Homebrew, apt or downloaded shell installer invisibly. A future opt-in --install is a separate reviewed ticket.

Windows scripts/bootstrap.ps1:
~~~powershell
param([switch]$Check, [switch]$Install)
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot ".."))
if ($Install) {
  Write-Host "Install vetted Node 24, pnpm 12.7.0, Godot 4.7.2 and Git manually."
  exit 2
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  throw "Node.js 24 is required."
}
node scripts/doctor.mjs
exit $LASTEXITCODE
~~~

## 6. scripts/doctor.mjs — Node standard library only
~~~js
import { spawnSync } from 'node:child_process';
import { existsSync } from 'node:fs';
import process from 'node:process';

function command(program, args = []) {
  const result = spawnSync(program, args, { encoding: 'utf8', shell: false });
  return result.status === 0 ? (result.stdout || result.stderr).trim() : null;
}

const problems = [];
for (const filename of ['package.json', 'pnpm-workspace.yaml', 'apps/game/project.godot']) {
  if (!existsSync(filename)) problems.push('Missing file: ' + filename);
}
if (Number(process.versions.node.split('.')[0]) !== 24) {
  problems.push('Node 24 LTS required: found ' + process.version);
}
const pnpm = command('pnpm', ['--version']);
if (!pnpm?.startsWith('12.')) problems.push('pnpm 12 missing or wrong version: ' + pnpm);
const godot = command(process.env.GODOT_BIN || 'godot', ['--version']);
if (!godot?.startsWith('4.7.2')) problems.push('Godot 4.7.2 missing or wrong version: ' + godot);
if (!command('git', ['--version'])) problems.push('Git is missing');
console.log(JSON.stringify({
  node: process.version, pnpm, godot, platform: process.platform, arch: process.arch
}, null, 2));
for (const p of problems) console.error('ERROR ' + p);
process.exitCode = problems.length ? 1 : 0;
~~~
Check version EXACT pin rather than startsWith in the finished doctor. GODOT_BIN supports nonstandard installed names. The doctor must sanitize machine/user paths before exporting troubleshooting summaries.

## 7. scripts/dev-game.mjs
~~~js
import { spawn } from 'node:child_process';
import process from 'node:process';

const program = process.env.GODOT_BIN || 'godot';
const child = spawn(program, ['--path', 'apps/game'], {
  stdio: 'inherit',
  shell: false
});
child.once('error', err => { console.error(err.message); process.exitCode = 1; });
child.once('close', code => { process.exitCode = code ?? 1; });
~~~
No Tauri or Node WebSocket is required for direct local Godot development.

## 8. Godot bare minimum scene/config
apps/game/project.godot:
~~~ini
config_version=5
[application]
config/name="Scalfagus"
run/main_scene="res://scenes/main.tscn"
[display]
window/size/viewport_width=1280
window/size/viewport_height=720
~~~
apps/game/scenes/main.tscn:
~~~ini
[gd_scene load_steps=2 format=3]
[ext_resource type="Script" path="res://scripts/app/main.gd" id="1_main"]
[node name="Main" type="Node3D"]
script = ExtResource("1_main")
[node name="OverlordCamera" type="Camera3D" parent="."]
projection = 1
current = true
[node name="DirectCamera" type="Camera3D" parent="."]
projection = 1
[node name="FpsCamera" type="Camera3D" parent="."]
projection = 0
~~~
apps/game/scripts/app/main.gd:
~~~gdscript
extends Node3D

@onready var overlord_camera: Camera3D = $OverlordCamera
@onready var direct_camera: Camera3D = $DirectCamera
@onready var fps_camera: Camera3D = $FpsCamera

enum ViewMode { OVERLORD, DIRECT, FPS }
var mode: ViewMode = ViewMode.OVERLORD

func _ready() -> void:
    set_view(ViewMode.OVERLORD)

func set_view(next_mode: ViewMode) -> void:
    mode = next_mode
    overlord_camera.current = mode == ViewMode.OVERLORD
    direct_camera.current = mode == ViewMode.DIRECT
    fps_camera.current = mode == ViewMode.FPS
~~~
This is only a camera **shell**, not actual RTS/FPS possession: add terrain/collision, real existing Hero, controller lease, actor-follow transforms, a unified weapon and command validation before claiming a playable proof. Run Godot 4.7.2 --headless --editor --import --quit to check scene syntax before accepting implementation.

## 9. Typed schema → authored YAML → Godot JSON
Use packages/schemas with TypeBox + Ajv (or Zod with tested JSON Schema generation; choose ONE canonical library). Example:
~~~ts
import { Type, type Static } from '@sinclair/typebox';

export const FactionSchema = Type.Object({
  schema_version: Type.Literal(1),
  id: Type.Union([Type.Literal('org'), Type.Literal('man'), Type.Literal('eth')]),
  name_short: Type.String(),
  name_mid: Type.String(),
  name_full: Type.String()
});
export type Faction = Static<typeof FactionSchema>;
~~~
packages/game-data/factions/man.yaml:
~~~yaml
schema_version: 1
id: man
name_short: Manus
name_mid: Manusians
name_full: Manusians Augmented Navigators
~~~
Validation MUST check exact full backronyms and original three IDs, hero talent DAG, resource IDs only matter/volatiles/energy, no negative recipe cost, collisions, unit role/domain constraints and cross-file references. Create sorted bundle, SHA-256 and generated rules.v1.json. Godot loader verifies schema_version/content_hash. Never import historical design YAML directly.

## 10. Hero fixture and acceptance tests
Hero talents fixture:
~~~yaml
schema_version: 1
starter_kits: [engineer, commander, specialist]
nodes:
  - { id: tools, branch: engineer, requires: [], excludes: [], cost: 1 }
  - { id: targeting, branch: specialist, requires: [], excludes: [], cost: 1 }
  - { id: combat_engineer, branch: bridge, requires: [tools, targeting], excludes: [], cost: 1 }
  - { id: field_architect, branch: engineer, requires: [tools], excludes: [demolitionist], cost: 2 }
  - { id: demolitionist, branch: specialist, requires: [targeting], excludes: [field_architect], cost: 2 }
~~~
Tests: all refs valid, graph acyclic, starter kits accessible, one Engineer->Specialist pivot possible, one Specialist->Commander pivot possible after more nodes defined, choices never secretly delete prior talents.

Three-camera game test: stable Hero actor ID; Overlord -> Direct -> FPS -> Overlord; unchanged world authority and weapon cooldown; enemy behind wall cannot be hit; resources cannot increase without credited sources; workers continue autonomous delivery; Hero death releases input and camera.

## 11. Tauri/Electron starter boundary
Implement React/Vite Studio as ordinary web app first. Later Tauri v2 packages the developer interface and launches *already exported* Godot executable as a platform-specific sidecar:
- Tauri config bundle.externalBin points at named binary; file in src-tauri/binaries must use target-triple suffix.
- Scope shell:allow-spawn for ONLY that sidecar and validated known argument variants; no arbitrary 'args:true' or 'shell:true'.
- Game runs in its own window with no IPC on its FPS frame-critical path.
- Separate packaging artifact: Scalfagus Studio.app and Scalfagus.app; Studio is not required to start the game.
- On macOS sign/notarize actual app bundles in a protected workflow; never place Apple developer credentials in repo.
Electron alternative if all-launcher-in-TS matters: Electron Forge plus contextIsolation true, sandbox true, nodeIntegration false, restrictive preload contextBridge and CSP. Its Chromium bundle/attack surface is larger; not preferred without concrete need.

## 12. GitHub Actions blueprint (tags shown solely as illustrative examples)
~~~yaml
name: check
on:
  pull_request:
  push:
    branches: [main]
permissions:
  contents: read
jobs:
  tooling:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "24"
      - name: Install pnpm
        run: npm install --global pnpm@12.7.0
      - run: pnpm install --frozen-lockfile
      - run: pnpm validate:data
      - run: pnpm check:ts
      - run: pnpm test:ts
~~~
BEFORE enabling protected release, pin GitHub actions by reviewed immutable SHA, commit valid frozen pnpm-lock.yaml, and add a separate Godot headless job with reviewed verified Godot binary. Don't equate a TS-only green workflow with finished game runtime. The example needs platform/network and lockfile checks and should not be copied as "secure final release CI".

Godot smoke flow:
~~~
godot --headless --path apps/game --editor --import --quit
godot --headless --path apps/game --script res://tests/headless_smoke.gd
godot --headless --path apps/game --export-release "macOS" /absolute/output/game.zip
~~~
Export preset name and template installation must be real and tested; a macOS .app may be wrapped in zip for CI artifacts, but exported exact format follows current Godot presets.

## 13. File-by-file PR ordering and verification
PR-01: root manifests, scripts, pinned toolchain+doctor, AGENTS.md, readme, no code generation magic. Verify on clean Mac.
PR-02: TypeBox/Ajv schemas + all three faction YAML + checks + generated bundle and content hash. Verify with tests and pinned pnpm lock.
PR-03: Godot project/scenes/three cameras, one real actor, fixed tick and headless smoke; verify import and real camera switch.
PR-04: economy/job AI and RTS commands; verify resources and no duplicate actor.
PR-05: Hero starter kits and tiny open graph, cross-perspective ability; verify non-hero win path.
PR-06: pixel-art asset/near-FPS billboards/geometry benchmark; remove visual cheats, inspect on 1080p and high DPI.
PR-07: one original map, enemy, 10–25 minute playable proof. Verify by human playtest.
PR-08: React Studio and optional Tauri launcher only if there is clear non-game utility.

## Documentation references
- [Mono-Blue Tech Seed](mono-blue-tech-seed-2026-10-11.md)
- [One authoritative world ADR](adr-0001-one-authoritative-game-world.md)
- [Desktop shell ADR](adr-0002-desktop-shell-boundary.md)
- https://pnpm.io/workspaces
- https://godotengine.org/download/archive/
- https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
- https://v2.tauri.app/develop/sidecar/
- https://www.electronjs.org/docs/latest/tutorial/security/
