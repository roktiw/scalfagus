// Compare generated emblems by actual RGBA pixels, not zlib PNG compression bytes.
// Usage: node scripts/compare-faction-emblems.mjs committed_dir regenerated_dir
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { inflateSync } from 'node:zlib';

const committed = process.argv[2];
const generated = process.argv[3];
if (!committed || !generated) {
  console.error('Usage: compare-faction-emblems.mjs <committed_dir> <generated_dir>');
  process.exit(2);
}

function parsePng(file) {
  const bytes = readFileSync(file);
  assert.deepEqual([...bytes.subarray(0, 8)], [137,80,78,71,13,10,26,10], 'PNG signature');
  const width = bytes.readUInt32BE(16);
  const height = bytes.readUInt32BE(20);
  assert.equal(bytes[24], 8, 'RGBA pixel depth');
  assert.equal(bytes[25], 6, 'RGBA color type');
  let pos = 8;
  const blocks = [];
  while (pos < bytes.length) {
    const length = bytes.readUInt32BE(pos);
    const kind = bytes.toString('ascii', pos + 4, pos + 8);
    if (kind === 'IDAT') blocks.push(bytes.subarray(pos + 8, pos + 8 + length));
    pos += 12 + length;
    if (kind === 'IEND') break;
  }
  const raw = inflateSync(Buffer.concat(blocks));
  const pixels = Buffer.alloc(width * height * 4);
  const stride = width * 4;
  assert.equal(raw.length, height * (stride + 1), 'raw PNG size');
  for (let row = 0; row < height; row++) {
    const from = row * (stride + 1);
    assert.equal(raw[from], 0, 'PNG filter type 0');
    raw.copy(pixels, row * stride, from + 1, from + stride + 1);
  }
  return { width, height, pixels };
}

const originalRegions = JSON.parse(readFileSync(join(committed, 'regions.json'), 'utf8'));
const regeneratedRegions = JSON.parse(readFileSync(join(generated, 'regions.json'), 'utf8'));
assert.deepStrictEqual(regeneratedRegions, originalRegions, 'regions.json must match exactly');
let count = 0;
for (const variant of originalRegions.variants) {
  const filenames = [variant.file, ...variant.regions.map(r => r.name)];
  for (const name of filenames) {
    const a = parsePng(join(committed, name));
    const b = parsePng(join(generated, name));
    assert.equal(a.width, b.width, name + ' width');
    assert.equal(a.height, b.height, name + ' height');
    assert.deepStrictEqual(a.pixels, b.pixels, name + ' RGBA bytes');
    count++;
  }
}
console.log(`FACTION_EMBLEMS_REGEN_PASS ${count} RGBA images pixel-identical`);
