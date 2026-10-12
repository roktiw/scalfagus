from PIL import Image, ImageDraw, ImageFont
import json, os, math, zipfile
ROOT='/mnt/data/eth_orbpod_pixel_asset_pack'
FW,FH=24,32
VIEWS=['front','front_right','right_side','back_right','back']
PALETTES={
 'outline':'#24213d','outline2':'#332a55','ceramic':'#f1ecdf','shade':'#cfced9','deep':'#9d9ab8',
 'eye_outline':'#25263f','eye_white':'#f6f9f6','iris':'#42cee2','iris_dark':'#1d6995','pupil':'#172b44',
 'spark':'#ffffff','cyan':'#78f0e0','indigo':'#64508c','violet':'#b29cdf','orange':'#edaa66','coral':'#ec7859',
 'blue_shadow':'#4a4369','stone':'#3f415b','stone_light':'#76c4d6','stone_light2':'#9ee8df'
}
P=PALETTES
rgba=lambda k:P.get(k,k)

def polygon(d,points,fill,outline=None):d.polygon(points,fill=rgba(fill));(d.line(points+[points[0]],fill=rgba(outline),width=1) if outline else None)
def seg(d,pts,col='indigo',width=2):d.line(pts,fill=rgba(col),width=width)
def ellipse(d,box,color,outline=None,width=1):d.ellipse(box,fill=rgba(color),outline=rgba(outline) if outline else None,width=width)

def sprite(view,action,frame):
 im=Image.new('RGBA',(FW,FH),(0,0,0,0));d=ImageDraw.Draw(im)
 # different orbit of arms per action and per keyframe; ground hover never maps to airborne navigation
 bob=(-1 if action=='move' and frame%2==0 else 0) + (1 if action=='hide' else 0)
 yc=15+bob
 # 360-degree reconfigurable anatomical sets (3 PAIRS: upper, middle, lower)
 # upper pair, during movement they angle backward, in hide curve over the brow
 if action=='hide':
  L=[(9,yc-4),(7,yc-8),(10,yc-11),(12,yc-9)]
  R=[(15,yc-4),(17,yc-8),(14,yc-11),(12,yc-9)]
 else:
  swing=(-2 if frame%2 else 1) if action=='move' else (1 if action=='idle' and frame%2 else 0)
  L=[(9,yc-4),(7,yc-8),(5+swing,yc-13),(10,yc-10)]
  R=[(15,yc-4),(17,yc-8),(18+swing,yc-14),(14,yc-10)]
 if view in (2,3):
  L=[(9,yc-4),(8,yc-8),(7,yc-12),(11,yc-9)]
  R=[(15,yc-4),(16,yc-8),(16,yc-13),(14,yc-9)]
 if view==4:
  L=[(9,yc-4),(7,yc-9),(8,yc-14),(11,yc-10)]
  R=[(15,yc-4),(17,yc-9),(16,yc-14),(13,yc-10)]
 for poly in [L,R]:polygon(d,poly,'shade','outline');d.point((poly[2][0],poly[2][1]+2),fill=rgba('cyan'))
 # bottom pair: tail/legs/supports (2 limbs)
 if action=='hide':
  seg(d,[(9,yc+5),(5,yc+9),(8,yc+10)],'indigo',2)
  seg(d,[(15,yc+5),(19,yc+9),(16,yc+10)],'indigo',2)
 elif action=='carry':
  seg(d,[(8,yc+6),(7,yc+9),(9,yc+10)],'indigo',2)
  seg(d,[(16,yc+6),(17,yc+9),(15,yc+10)],'violet',2)
 else:
  lo=(-2 if action=='move' and frame%2 else 0)
  seg(d,[(9,yc+5),(6+lo,yc+10),(4+lo,yc+9)],'indigo',2)
  seg(d,[(15,yc+5),(18-lo,yc+10),(20-lo,yc+9)],'violet',2)
  d.point((5+lo,yc+9),fill=rgba('cyan'));d.point((19-lo,yc+9),fill=rgba('cyan'))
 # middle pair: arms and grasping pincers, 2 distinct appendages
 if action=='carry':
  seg(d,[(7,yc+1),(5,yc+5),(9,yc+9)],'orange',2)
  seg(d,[(17,yc+1),(19,yc+5),(15,yc+9)],'orange',2)
  seg(d,[(9,yc+9),(10,yc+10)],'coral',1)
  seg(d,[(15,yc+9),(14,yc+10)],'coral',1)
 elif action=='hide':
  seg(d,[(8,yc),(6,yc+5),(10,yc+7)],'orange',2)
  seg(d,[(16,yc),(18,yc+5),(14,yc+7)],'orange',2)
 elif action=='move':
  q=2 if frame%2 else -2
  seg(d,[(7,yc),(3,yc-1+q),(2,yc+2+q)],'orange',2)
  seg(d,[(17,yc),(21,yc+1-q),(22,yc+4-q)],'orange',2)
  seg(d,[(2,yc+2+q),(4,yc+4+q)],'coral',1)
  seg(d,[(22,yc+4-q),(20,yc+6-q)],'coral',1)
 else:
  q=1 if frame%2 else 0
  seg(d,[(7,yc),(3,yc-3+q),(2,yc-2+q)],'orange',2)
  seg(d,[(17,yc),(21,yc-3-q),(22,yc-2-q)],'orange',2)
  seg(d,[(2,yc-2+q),(4,yc-1+q)],'coral',1)
  seg(d,[(22,yc-2-q),(20,yc-1-q)],'coral',1)
 # the actual single spherical orb chassis
 ellipse(d,(6,yc-6,18,yc+7),'ceramic','outline',1)
 d.arc((7,yc-5,17,yc+6),30,155,fill=rgba('deep'),width=1)
 d.point((8,yc-3),fill=rgba('eye_white'))
 d.line([(8,yc+6),(15,yc+6)],fill=rgba('deep'),width=1)
 # one eye. Eye orient based on yaw, not an extra eye on back
 if view==4:
  ellipse(d,(10,yc-2,14,yc+2),'indigo','outline')
  d.point((12,yc-1),fill=rgba('cyan'))
 elif view==3:
  ellipse(d,(16,yc-2,18,yc+3),'iris_dark','eye_outline')
  d.point((17,yc-1),fill=rgba('spark'))
 elif view==2:
  ellipse(d,(15,yc-3,19,yc+4),'eye_white','eye_outline')
  ellipse(d,(16,yc-1,18,yc+3),'iris')
  d.point((17,yc),fill=rgba('pupil'))
  seg(d,[(14,yc-5),(18,yc-6)],'outline',1)
 elif view==1:
  ellipse(d,(11,yc-3,19,yc+4),'eye_white','eye_outline')
  ellipse(d,(14,yc-1,18,yc+3),'iris')
  d.point((16,yc),fill=rgba('pupil'))
  d.point((14,yc-1),fill=rgba('spark'))
  seg(d,[(11,yc-5),(17,yc-6)],'outline',1)
 else:
  if action=='hide':
   seg(d,[(8,yc-1),(16,yc)],'eye_outline',2)
   seg(d,[(8,yc-4),(16,yc-6)],'outline',1)
  else:
   ellipse(d,(8,yc-3,16,yc+4),'eye_white','eye_outline')
   ex=2 if action=='move' and frame%2 else 0
   ellipse(d,(10+ex,yc-1,14+ex,yc+3),'iris')
   d.point((12+ex,yc+1),fill=rgba('pupil'))
   d.point((11+ex,yc-1),fill=rgba('spark'))
   if action=='idle' and frame%2: seg(d,[(9,yc-6),(15,yc-6)],'outline',1)
   else:seg(d,[(9,yc-5),(15,yc-7)],'outline',1)
 # small expressive mouth, only on frontal views
 if view<2 and action!='hide':
  if action=='carry': d.arc((12,yc+3,15,yc+5),0,145,fill=rgba('outline2'),width=1)
  elif action=='idle' and frame%2: d.point((11,yc+5),fill=rgba('outline2'))
  else:seg(d,[(12,yc+5),(14,yc+5)],'outline2',1)
 # parcel foreground: physically carried object, never duplicated
 if action=='carry':
  polygon(d,[(9,yc+8),(12,yc+6),(16,yc+8),(15,yc+12),(10,yc+12)],'stone','outline')
  d.point((11,yc+8),fill=rgba('stone_light'))
  d.point((14,yc+9),fill=rgba('cyan'))
  d.point((12,yc+11),fill=rgba('stone_light2'))
 return im

actions={'idle':2,'move':4,'carry':2,'hide':3}
manifest={'schema_version':1,'project':'scalfagus','faction':'eth','asset_id':'eth.orbpod.min',
 'status':'pixel_art_prototype_not_final_approved_asset','source':'original_procedurally_authored_in_chat_2026-10-12',
 'license_source':'original_user_project_concept_computer_render','frame_width_px':FW,'frame_height_px':FH,
 'authored_views':VIEWS,'eight_sector_rows':[0,1,2,3,4,3,2,1], 'mirror_flags':[False,False,False,False,False,True,True,True],
 'sprite_render_node':'Sprite3D','filter':'nearest','transparent_background':True,
 'shadow_is_separate':True,'world_movement_domain':'ground','locomotion_visual':'hover','pivot_px':[12,30],
 'three_pairs_two_limbs_each':True,'single_eye_and_eyebrow':True,'skills_mining_carry_hide_not_automatic_aerial_flight':True,
 'actions':{}}
for action,n in actions.items():
 atlas=Image.new('RGBA',(FW*n,FH*5),(0,0,0,0))
 for row,view in enumerate(range(5)):
  for frame in range(n):
   unit=sprite(view,action,frame)
   atlas.alpha_composite(unit,(FW*frame,FH*row))
 filename=f'eth_orbpod_{action}_5views.png';atlas.save(os.path.join(ROOT,filename))
 manifest['actions'][action]={'texture':filename,'frame_count':n,'atlas_width':FW*n,'atlas_height':FH*5,'fps':{'idle':3,'move':7,'carry':4,'hide':5}[action]}
# separate ground blob/shadow
shadow=Image.new('RGBA',(FW,FH),(0,0,0,0));d=ImageDraw.Draw(shadow);d.ellipse((7,28,17,30),fill=(22,24,42,120));shadow.save(ROOT+'/eth_orbpod_shadow.png')
# composite preview with checkerboard and 5-view atlas sections
mag=5; margin=18; row_h=FH*mag*5+32; widths=max(FW*n for n in actions.values())*mag
preview=Image.new('RGB',(widths+2*margin+155,(row_h+8)*len(actions)+45),(19,20,35));d=ImageDraw.Draw(preview)
d.text((margin,12),'SCALFAGUS / ETH ORBPOD  -  ART ATLAS PROTOTYPE',fill=(217,224,241))
for k,(action,n) in enumerate(actions.items()):
  top=45+k*(row_h+8)
  d.text((margin,top),f'{action.upper()}  |  {n} FRAMES x 5 VIEWS',fill=(115,229,230))
  atlas=Image.open(ROOT+f'/eth_orbpod_{action}_5views.png')
  for yy in range(atlas.height):
   for xx in range(atlas.width):
    if atlas.getpixel((xx,yy))[3]: continue
  check=Image.new('RGBA',atlas.size,(0,0,0,0));dc=ImageDraw.Draw(check)
  for yy in range(0,atlas.height,4):
   for xx in range(0,atlas.width,4):
    color=(49,49,70,255) if (xx//4+yy//4)%2 else (62,64,84,255)
    dc.rectangle((xx,yy,xx+3,yy+3),fill=color)
  check.alpha_composite(atlas)
  enlarged=check.convert('RGB').resize((atlas.width*mag,atlas.height*mag),Image.Resampling.NEAREST)
  preview.paste(enlarged,(margin,top+23))
  for j,view in enumerate(VIEWS):
    y=top+23+j*FH*mag
    d.text((margin+widths+12,y+8),view,fill=(193,187,217))
  for j in range(6):d.line((margin,top+23+j*FH*mag,margin+atlas.width*mag,top+23+j*FH*mag),fill=(75,79,106),width=1)
preview.save(ROOT+'/eth_orbpod_atlas_preview.png')
with open(ROOT+'/eth_orbpod_manifest.json','w') as f:json.dump(manifest,f,indent=2,ensure_ascii=False)
with open(ROOT+'/README.md','w') as f:
 f.write('''# ETH ORBPOD — Pixel-art prototype asset bundle\n\nOriginal, hand-constructed nearest-neighbor indexed-style RGBA sprites as a playable placeholder, inspired by the owner's concept and Scalfagus art canon. Generated concept poster shown in chat is separate from these prototype atlases.\n\n## Asset format\n- 24x32 transparent pixels each cell, ground pivot (12,30), shadow separate.\n- Five authored yaw rows: front, front-right, right-side, back-right, back.\n- Animated columns per action, frame counts and FPS in `eth_orbpod_manifest.json`.\n- `idle`, `move`, `carry`, `hide` separate transparent RGBA PNG atlases.\n- 8 sectors from 5 views using repo's DEC-017 mirror policy. Review mirror-safety with asymmetric expression/limbs before production.\n- Orb central body with **one eye and visible brow** and exactly **three pairs of universal limbs** (six total); poses show ears, grippers and support legs without fixed anatomy.\n- Movement domain is GROUND with near-ground hover VFX, not free flight.\n\n## Integration\nImport PNGs with nearest filtering and mipmapping tuned for gameplay camera. Use a Sprite3D with the atlas convention in `art/directional-sprite-five-view-v0.1.yaml`. Ground shadow sprite is separate. Use the JSON manifest for action/row/frame metadata.\n\nThese are original first-pass **prototype** art sprites intended for QA, **not an approved production asset**. Test at 320x240, and review whether all 6 limbs and eye remain legible. Their style follows repo rules; their exact final palettes, animation timing and collision are subject to art direction approval.\n''')
with zipfile.ZipFile('/mnt/data/eth_orbpod_godot_sprite_prototype.zip','w',compression=zipfile.ZIP_DEFLATED) as z:
 for name in os.listdir(ROOT):
  if name.endswith(('.png','.json','.md','.py')):z.write(os.path.join(ROOT,name),name)
print('CREATED',[(p,os.path.getsize(os.path.join(ROOT,p))) for p in sorted(os.listdir(ROOT)) if p.endswith('.png')]);print('zip bytes',os.path.getsize('/mnt/data/eth_orbpod_godot_sprite_prototype.zip'))
