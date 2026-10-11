#!/usr/bin/env node
import { spawn } from 'node:child_process';
import { existsSync } from 'node:fs';
import { dirname, resolve, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const project = join(root, 'apps', 'game', 'project.godot');
if (!existsSync(project)) {
  console.error('S1 Godot project not scaffolded yet. Start with the engine camera/possession spike.');
  process.exit(2);
}
const command = process.env.GODOT_BIN || 'godot';
const child = spawn(command, ['--path', join(root, 'apps', 'game')], {
  stdio: 'inherit', shell: false
});
child.once('error', err => {
  console.error('Unable to launch Godot:', err.message);
  process.exitCode = 1;
});
child.once('close', code => {
  if (process.exitCode === undefined) process.exitCode = code ?? 1;
});
