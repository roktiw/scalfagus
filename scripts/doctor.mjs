#!/usr/bin/env node
import { existsSync, readFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { dirname, join, resolve } from 'node:path';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const mode = process.argv[2] || '--all';
if (!['--all', '--repo'].includes(mode)) {
  console.error('Usage: node scripts/doctor.mjs [--repo|--all]');
  process.exit(2);
}
const problems = [];
for (const path of [
  'package.json',
  'pnpm-workspace.yaml',
  'toolchain.lock.json',
  'AGENTS.md',
  'architecture/mono-blue-tech-seed-2026-10-11.md',
  'design/decisions.yaml',
  'design/factions.yaml'
]) {
  if (!existsSync(join(root, path))) problems.push('Missing ' + path);
}

let configuration;
try {
  const packagePath = join(root, 'package.json');
  const toolchainPath = join(root, 'toolchain.lock.json');
  if (existsSync(packagePath) && existsSync(toolchainPath)) {
    const pkg = JSON.parse(readFileSync(packagePath, 'utf8'));
    const toolchain = JSON.parse(readFileSync(toolchainPath, 'utf8'));
    configuration = {
      package_manager: pkg.packageManager,
      node_target: toolchain.node_major,
      pnpm_target: toolchain.pnpm_exact,
      godot_target: toolchain.godot_exact
    };
    if (pkg.packageManager !== 'pnpm@' + toolchain.pnpm_exact) {
      problems.push('packageManager and toolchain pnpm versions disagree');
    }
  }
} catch (error) {
  problems.push('Invalid JSON configuration: ' + error.message);
}

function version(program, args = ['--version']) {
  const result = spawnSync(program, args, {
    encoding: 'utf8', shell: false, timeout: 12000
  });
  if (result.error || result.status !== 0) return null;
  return (result.stdout || result.stderr).trim();
}

const actual = { node: process.version, platform: process.platform, arch: process.arch };
if (mode === '--all') {
  if (Number(process.versions.node.split('.')[0]) !== 24) problems.push('Install Node.js 24 LTS');
  actual.pnpm = version('pnpm');
  if (configuration && actual.pnpm !== configuration.pnpm_target) {
    problems.push('Install pnpm ' + configuration.pnpm_target + ' (found ' + (actual.pnpm || 'missing') + ')');
  }
  const godotExecutable = process.env.GODOT_BIN || 'godot';
  actual.godot = version(godotExecutable);
  if (configuration && !actual.godot?.startsWith('4.7.2')) {
    problems.push('Install official Godot ' + configuration.godot_target + ' and set GODOT_BIN if needed');
  }
  actual.git = version('git');
  if (!actual.git) problems.push('Install Git');
}

console.log(JSON.stringify({ mode, configuration, actual, ok: problems.length === 0, problems }, null, 2));
process.exitCode = problems.length === 0 ? 0 : 1;
