// Scalfagus faction emblems. No dependencies; deterministic pixel icons/PNG RGBA.
// Run: node scripts/build-faction-emblems.mjs [output_dir]
// Source drawings are rasterized independently at 16/32/64 px, not photographic resizes.
import { deflateSync } from 'node:zlib';
import { writeFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
const OUTPUT = process.argv[2] ?? 'assets/faction-emblems';
const P = {
 ink:'#0c1424', shadow:'#14263f', dark:'#07111d', white:'#f1f3df', warm:'#fff2d6',
 blue:'#297ac3', blue2:'#55c8ed', blue3:'#123f73', orange:'#ed883e', orange2:'#ffca74',
 cyan:'#47dbeb', iris:'#236cca', indigo:'#394a9a', gold:'#e7c57b',
 red:'#d3494d', red2:'#fc8663', deepred:'#5e253c', crimson:'#982f42',
 bone:'#e8c49c', lime:'#a3bd60', green:'#506e46', purple:'#765f9e',
};
const rgb = x => [parseInt(x.slice(1,3),16),parseInt(x.slice(3,5),16),parseInt(x.slice(5,7),16),255];
class Canvas {
  constructor(s) {this.s=s;this.data=new Uint8Array(s*s*4);}
  px(x,y,color){x=Math.round(x);y=Math.round(y);if(x<0||y<0||x>=this.s||y>=this.s)return;const i=4*(y*this.s+x);this.data.set(rgb(P[color]||color),i);}
  val(n){return Math.round(n*this.s/16);}
  box(x0,y0,x1,y1,c){const a=this.val(x0),b=this.val(y0),xx=this.val(x1),yy=this.val(y1);for(let y=b;y<yy;y++)for(let x=a;x<xx;x++)this.px(x,y,c);}
  line(x0,y0,x1,y1,c,weight=1){let ax=this.val(x0),ay=this.val(y0),bx=this.val(x1),by=this.val(y1);let d=Math.max(Math.abs(bx-ax),Math.abs(by-ay));for(let i=0;i<=d;i++){let x=d?Math.round(ax+(bx-ax)*i/d):ax,y=d?Math.round(ay+(by-ay)*i/d):ay;let r=Math.max(0,Math.round(weight*this.s/16)-1);for(let dy=-r;dy<=r;dy++)for(let dx=-r;dx<=r;dx++)this.px(x+dx,y+dy,c);}}
  polygon(points,c){let pts=points.map(([x,y])=>[this.val(x),this.val(y)]);for(let y=0;y<this.s;y++)for(let x=0;x<this.s;x++){let on=false;for(let i=0,j=pts.length-1;i<pts.length;j=i++){let [xi,yi]=pts[i],[xj,yj]=pts[j];if(((yi>y)!=(yj>y))&&(x<(xj-xi)*(y-yi)/(yj-yi)+xi))on=!on;}if(on)this.px(x,y,c)}}
  path(points,c,weight=1){for(let i=1;i<points.length;i++)this.line(...points[i-1],...points[i],c,weight)}
  ellipse(cx,cy,rx,ry,c,fill=true){let x0=this.val(cx-rx),x1=this.val(cx+rx),y0=this.val(cy-ry),y1=this.val(cy+ry);const a=(x1-x0)/2||1,b=(y1-y0)/2||1,xx=(x1+x0-1)/2,yy=(y1+y0-1)/2;for(let y=y0;y<y1;y++)for(let x=x0;x<x1;x++){const q=((x-xx)/a)**2+((y-yy)/b)**2;if(fill?q<=1:q>=.60&&q<=1)this.px(x,y,c)}}
}
function framed(canvas,faction){const p=canvas;
if(faction==='man'){p.box(1,1,15,15,'ink');p.box(1,1,15,2,'blue3');p.box(1,14,15,15,'blue3');p.box(1,1,2,15,'blue3');p.box(14,1,15,15,'blue3');p.box(2,2,14,3,'blue');p.box(2,13,14,14,'blue');p.box(2,2,3,14,'blue');p.box(13,2,14,14,'blue');p.box(1,1,4,3,'white');p.box(12,1,15,3,'white');p.box(1,12,4,15,'white');p.box(12,12,15,15,'white');p.box(6,1,10,2,'orange');}
if(faction==='eth'){p.ellipse(8,8,7,7,'indigo');p.ellipse(8,8,6,6,'ink');p.ellipse(8,8,6,6,'blue3',false);p.px(p.val(8),p.val(1),'gold');p.px(p.val(8),p.val(14),'gold');p.px(p.val(1),p.val(8),'gold');p.px(p.val(14),p.val(8),'gold');}
if(faction==='org'){p.polygon([[8,1],[15,14],[1,14]],'crimson');p.polygon([[8,3],[13,13],[3,13]],'ink');p.path([[8,1],[15,14],[1,14],[8,1]],'red');p.box(7,2,9,3,'red2');}
}
function drawMan(p,v,s){framed(p,'man');
 if(v===1){ // open palm with node
  p.box(5,4,6,9,'warm');p.box(7,3,8,9,'warm');p.box(9,3,10,9,'warm');p.box(11,5,12,9,'warm');
  p.polygon([[4,7],[5,7],[7,9],[10,8],[12,9],[11,12],[9,13],[7,13],[5,11]],'white');
  p.polygon([[5,9],[7,11],[7,13],[5,11]],'blue');p.ellipse(8,10,1.3,1.3,'orange');
  if(s>=32){p.line(7,4,7,7,'blue2');p.line(9,4,9,7,'blue2');p.px(p.val(8),p.val(10),'orange2');}
 }
 if(v===2){ // glove construction
  for(const [x,t] of [[4,6],[6,5],[8,4],[10,5]]){p.box(x,t,x+1.6,9,'white');if(s>=32)p.box(x,t+2,x+1.6,t+2.5,'blue');}
  p.polygon([[4,8],[6,8],[6,9],[11,8],[12,11],[10,13],[6,13],[4,11]],'white');p.box(5,12,11,13,'blue');p.line(7,12,8,11,'orange');p.line(8,11,9,12,'orange');
  if(s>=32){p.box(5,9,6,11,'blue2');p.box(10,10,11,12,'blue2')}
 }
 if(v===3){ // gripping glove and industry slash
  p.line(4,12,11,4,'orange',2);p.polygon([[6,7],[7,5],[10,5],[12,7],[12,10],[10,12],[7,12],[5,10]],'white');p.box(6,7,12,8,'blue3');p.line(7,8,10,8,'blue2');p.box(7,10,11,11,'blue');
  if(s>=32){p.line(10,6,12,5,'orange2');p.box(8,11,10,12,'warm');}
 }
}
function drawEth(p,v,s){framed(p,'eth');
 if(v===1){ // watching stellar eye
  p.polygon([[2.7,8],[5.5,5.8],[8,5],[10.6,5.8],[13.3,8],[10.6,10.1],[8,11],[5.5,10.1]],'white');
  p.ellipse(8,8,3,3,'cyan');p.ellipse(8,8,1.6,2.2,'iris');p.ellipse(8,8,0.9,1.2,'ink');p.line(8,3,8,6,'gold');p.line(8,10,8,13,'gold');
  if(s>=32){p.ellipse(7,7,0.5,0.5,'white');p.line(3,8,4,8,'blue2');p.line(12,8,13,8,'blue2');}
 }
 if(v===2){ // luminous iris / lens
  p.ellipse(8,8,5,5,'cyan');p.ellipse(8,8,3.8,3.8,'iris');p.ellipse(8,8,2.5,2.5,'indigo');p.ellipse(8,8,1.8,1.8,'ink');p.line(8,2,8,4,'white');p.line(8,12,8,14,'white');p.line(2,8,4,8,'white');p.line(12,8,14,8,'white');
  if(s>=32){for(let k=0;k<8;k++){let a=k*Math.PI/4;p.line(8+3*Math.cos(a),8+3*Math.sin(a),8+4*Math.cos(a),8+4*Math.sin(a),'blue2');}p.ellipse(7,7,0.6,0.6,'white');}
 }
 if(v===3){ // orbital eye
  p.ellipse(8,8,4.2,4.2,'cyan');p.ellipse(8,8,2.4,2.5,'iris');p.ellipse(8,8,1.3,1.5,'ink');p.ellipse(8,8,6,1.2,'gold',false);p.line(2,8,5,8,'gold');p.line(11,8,14,8,'gold');
  if(s>=32){p.line(8,2,8,4,'white');p.box(7,6,8,7,'white');p.px(p.val(4),p.val(12),'gold');}
 }
}
function drawOrg(p,v,s){framed(p,'org');
 if(v===1){ // bifurcated chitin mandibles, no eyeball
  p.polygon([[4,7],[6,5],[7,4],[6,8],[8,11],[7,12],[5,11]],'bone');
  p.polygon([[12,7],[10,5],[9,4],[10,8],[8,11],[9,12],[11,11]],'bone');
  p.polygon([[7.5,7],[8.5,7],[9.5,10],[8,12],[6.5,10]],'red');
  p.ellipse(8,9.5,0.7,1.6,'red2');
  if(s>=32){p.line(5,7,6,6,'warm');p.line(11,7,10,6,'warm');p.line(6,11,7,12,'deepred');}
 }
 if(v===2){ // larval germination pods
  p.line(8,4,8,12,'lime');p.line(8,7,5,10,'lime');p.line(8,7,11,10,'lime');
  p.ellipse(8,7,1.8,2.0,'red');p.ellipse(5.5,10.5,1.8,2,'red');p.ellipse(10.5,10.5,1.8,2,'red');
  if(s>=32){for(const [x,y] of [[8,7],[5.5,10.5],[10.5,10.5]]){p.ellipse(x-.5,y-.6,.5,.5,'red2');}p.line(8,5,8,6,'green');}
 }
 if(v===3){ // open spined maw, deliberately NOT eye
  p.polygon([[7,4],[9,4],[11,7],[11,10],[9,13],[7,13],[5,10],[5,7]],'bone');
  p.ellipse(8,8.5,2.4,4,'red');p.box(7,6,9,11,'ink');
  for(let y=6;y<=11;y+=2){p.line(6.5,y,7.5,y+.6,'warm');p.line(9.5,y,8.5,y+.6,'warm');}
  p.line(4,6,2.5,5,'bone');p.line(12,6,13.5,5,'bone');
  if(s>=32){p.line(5,11,3,13,'bone');p.line(11,11,13,13,'bone');p.box(7.5,7,8.5,9,'deepred');}
 }
}
function pngEncode(w,h,rgba){const sig=Buffer.from([137,80,78,71,13,10,26,10]);const ihdr=Buffer.alloc(13);ihdr.writeUInt32BE(w,0);ihdr.writeUInt32BE(h,4);ihdr[8]=8;ihdr[9]=6;
let raw=Buffer.alloc(h*(1+w*4));for(let y=0;y<h;y++){raw[y*(w*4+1)]=0;Buffer.from(rgba.buffer,rgba.byteOffset+y*w*4,w*4).copy(raw,y*(w*4+1)+1);}
const table=new Uint32Array(256);for(let n=0;n<256;n++){let c=n;for(let k=0;k<8;k++)c=c&1?0xedb88320^(c>>>1):c>>>1;table[n]=c>>>0;}
function chunk(type,bytes){const tag=Buffer.from(type),len=Buffer.alloc(4);len.writeUInt32BE(bytes.length);let crc=0xffffffff;for(const ch of Buffer.concat([tag,bytes]))crc=table[(crc^ch)&255]^(crc>>>8);crc=(crc^0xffffffff)>>>0;const cb=Buffer.alloc(4);cb.writeUInt32BE(crc);return Buffer.concat([len,tag,bytes,cb]);}
return Buffer.concat([sig,chunk('IHDR',ihdr),chunk('IDAT',deflateSync(raw,{level:9})),chunk('IEND',Buffer.alloc(0))]);}
const factions=['man','eth','org'];const indexes=[];mkdirSync(OUTPUT,{recursive:true});
for(const s of [16,32,64]){const sheet = new Uint8Array(s*3*s*3*4),rows=[];
 for(let r=0;r<3;r++)for(let c=0;c<3;c++){
  const faction=factions[r],variant=c+1,icon=new Canvas(s);(faction==='man'?drawMan:faction==='eth'?drawEth:drawOrg)(icon,variant,s);
  let nontransparent=0;for(let i=0;i<s*s;i++)if(icon.data[i*4+3])nontransparent++;
  for(let y=0;y<s;y++)for(let x=0;x<s;x++){
   let si=(y*s+x)*4,dx=c*s+x,dy=r*s+y,di=(dy*(s*3)+dx)*4;sheet.set(icon.data.subarray(si,si+4),di);
  }
  const name=`${faction}_${String(variant).padStart(2,'0')}_${s}.png`;writeFileSync(join(OUTPUT,name),pngEncode(s,s,icon.data));rows.push({id:`${faction}.${String(variant).padStart(2,'0')}`,name,region:[c*s,r*s,s,s],nontransparent_pixels:nontransparent});
 }
 const atlas=`faction-emblems-${s}.png`;writeFileSync(join(OUTPUT,atlas),pngEncode(3*s,3*s,sheet));indexes.push({size:s,file:atlas,regions:rows});
}
writeFileSync(join(OUTPUT,'regions.json'),JSON.stringify({schema_version:1,version:'0.1',status:'candidate emblems; ORG symbol unapproved',variants:indexes},null,2)+'\n');
console.log(`Generated 27 standalone icons + three 3x3 atlases in ${OUTPUT}`);
