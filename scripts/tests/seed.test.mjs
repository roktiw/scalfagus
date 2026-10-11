import { test } from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');

test('repository seed configuration is structurally sound', () => {
  const result = spawnSync(process.execPath, ['scripts/doctor.mjs', '--repo'], {
    cwd: root, encoding: 'utf8'
  });
  assert.equal(result.status, 0, result.stdout + result.stderr);
});

test('approved faction identities match active YAML', () => {
  const result = spawnSync(process.execPath, ['scripts/verify-seed.mjs'], {
    cwd: root, encoding: 'utf8'
  });
  assert.equal(result.status, 0, result.stdout + result.stderr);
});

test('game launch clearly fails until native game project exists', () => {
  const result = spawnSync(process.execPath, ['scripts/dev-game.mjs'], {
    cwd: root, encoding: 'utf8'
  });
  assert.equal(result.status, 2, result.stdout + result.stderr);
  assert.match(result.stderr, /S1 Godot project not scaffolded yet/);
});
