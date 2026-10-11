// Scalfagus test: 27 native raster icons and three 3x3 RGBA atlases.
// Run: node scripts/test-faction-emblems.mjs [output_dir]
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {join} from 'node:path';
import {inflateSync} from 'node:zlib';
const root = process.argv[2] ?? 'assets/faction-emblems';
function decodePng(path) {
  const f=readFileSync(path);
  assert.deepEqual([...f.subarray(0,8)], [137,80,78,71,13,10,26,10], 'PNG signature');
  const w=f.readUInt32BE(16),h=f.readUInt32BE(20);
  assert.equal(f[24],8,'pixel depth 8'); assert.equal(f[25],6,'RGBA color 6');
  let offset=8, parts=[];
  while(offset < f.length){const len=f.readUInt32BE(offset),tag=f.toString('ascii',offset+4,offset+8); if(tag==='IDAT')parts.push(f.subarray(offset+8,offset+8+len)); offset+=12+len; if(tag==='IEND')break;}
  const bytes=inflateSync(Buffer.concat(parts));const rgba=Buffer.alloc(w*h*4);
  for(let y=0;y<h;y++){
    const at=y*(w*4+1);assert.equal(bytes[at],0,'filter type 0');
    bytes.copy(rgba,y*w*4,at+1,at+1+w*4);
  }
  return {w,h,rgba};
}
const data=JSON.parse(readFileSync(join(root,'regions.json'),'utf8'));
assert.equal(data.schema_version,1);assert.equal(data.variants.length,3);
const ids = ['man.01','man.02','man.03','eth.01','eth.02','eth.03','org.01','org.02','org.03'];
for(const size of [16,32,64]) {
  const group=data.variants.find(x=>x.size===size);
  assert(group,'native size exists '+size);
  const sheet=decodePng(join(root,group.file));
  assert.equal(sheet.w,size*3);assert.equal(sheet.h,size*3);
  assert.deepEqual(group.regions.map(x=>x.id),ids);
  let totalOpaque=0;
  for(let i=0;i<9;i++){
    const r=group.regions[i],icon=decodePng(join(root,r.name));
    assert.equal(icon.w,size);assert.equal(icon.h,size);
    assert.deepEqual(r.region,[(i%3)*size,Math.floor(i/3)*size,size,size]);
    let visible=0,transparent=0;
    for(let y=0;y<size;y++)for(let x=0;x<size;x++){
      const idx=(y*size+x)*4,src=icon.rgba.subarray(idx,idx+4),dstidx=(((y+r.region[1])*sheet.w)+(x+r.region[0]))*4,dst=sheet.rgba.subarray(dstidx,dstidx+4);
      assert.deepEqual([...dst],[...src],`atlas mismatch ${r.id}@${size} ${x},${y}`);
      if(src[3]===0)transparent++;else visible++;
    }
    assert(visible>0&&transparent>0,`expected alpha silhouette ${r.name}`);
    assert.equal(visible,r.nontransparent_pixels);
    totalOpaque+=visible;
  }
  console.log(`OK ${size}x${size}: atlas ${sheet.w}x${sheet.h}, 9 icons, ${totalOpaque} opaque pixels`);
}
console.log('OK 27 RGBA icons and 3 atlases, all atlas rectangles match standalone source bytes');
