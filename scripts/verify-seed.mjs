#!/usr/bin/env node
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { dirname, resolve, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const file = path => readFileSync(join(root, path), 'utf8');
const factions = file('design/factions.yaml');
const names = file('design/faction-naming-conventions-2026-10-11.md');
const decisions = file('design/decisions.yaml');
const pkg = JSON.parse(file('package.json'));

assert.equal(pkg.name, 'scalfagus');
assert.equal(pkg.private, true);
assert.equal(pkg.packageManager, 'pnpm@12.7.0');
const exactNames = [
  ['org', 'Organs', 'Organites', 'Organites Reproductive Generalismus'],
  ['man', 'Manus', 'Manusians', 'Manusians Augmented Navigators'],
  ['eth', 'Eters', 'Etherans', 'Etherans Transcendent Hypervisors']
];
for (const [id, short, mid, full] of exactNames) {
  assert.ok(factions.includes('  - id: ' + id + '\n'), 'missing faction ID: ' + id);
  assert.ok(factions.includes('    name_short: ' + short + '\n'), 'missing short name for ' + id);
  assert.ok(factions.includes('    name_mid: ' + mid + '\n'), 'missing mid name for ' + id);
  assert.ok(factions.includes('    name_full: ' + full + '\n'), 'missing full name for ' + id);
  assert.ok(names.includes(full), 'naming canon missing ' + full);
}
assert.match(decisions, /topic: faction_three_level_backronym_naming/);
assert.match(decisions, /topic: individuality_over_hivemind/);
console.log('Seed contract checks OK: 3 canonical IDs, 3-tier naming, decision registry and root package');
