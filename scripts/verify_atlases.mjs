#!/usr/bin/env node
// No dependencies; deterministic input validation of provisional PNG atlases.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { resolve, dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const assets = join(root, 'apps/game/assets');
const manifest = JSON.parse(readFileSync(join(assets, 'manifest.json'), 'utf8'));
assert.equal(manifest.schema_version, 1);
assert.equal(manifest.runtime_source_views, 5);
assert.equal(manifest.runtime_sectors, 8);
assert.deepEqual(manifest.sector_source_rows, [0,1,2,3,4,3,2,1]);
assert.deepEqual(manifest.sector_flip_h, [false,false,false,false,false,true,true,true]);
let count = 0;
for (const entry of manifest.source_assets) {
  assert.match(entry.filename, /^[\w.-]+\.png$/);
  const input = readFileSync(join(assets, entry.filename));
  assert.equal(input.subarray(0,8).toString('hex'), '89504e470d0a1a0a', entry.filename + ' PNG signature');
  const width = input.readUInt32BE(16), height = input.readUInt32BE(20);
  const bitDepth = input.readUInt8(24), colorType = input.readUInt8(25);
  assert.equal(width, entry.frame_size_px[0] * entry.columns, entry.filename + ' width');
  assert.equal(height, entry.frame_size_px[1] * 5, entry.filename + ' height');
  assert.equal(bitDepth, 8, entry.filename + ' bit depth');
  assert.equal(colorType, 6, entry.filename + ' must use RGBA not magenta background');
  assert.equal(createHash('sha256').update(input).digest('hex'), entry.sha256, entry.filename + ' sha256');
  assert.equal(entry.source_row_names.length, 5);
  count++;
}
console.log(`ASSET_MANIFEST_PASS ${count} transparent, region-aligned PNG atlases (prototype only)`);
