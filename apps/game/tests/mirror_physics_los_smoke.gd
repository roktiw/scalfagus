extends SceneTree

# Local physics verification after real native Godot physics_frames.
# This covers presentation raycasting; authoritative damage remains in
# deterministic MirrorMatchState and is not modified by rendered physics.
const GAME = preload("res://scenes/mirror_match.tscn")
const GEOM = preload("res://scripts/mirror_geometry.gd")
const LOS = preload("res://scripts/mirror_physics_los_3d.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(reason: String) -> void:
    push_error("SCALFAGUS_MIRROR_PHYSICS_LOS_FAIL: " + reason)
    quit(1)

func _verify() -> void:
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var world = GAME.instantiate()
    root.add_child(world)
    await physics_frame
    await physics_frame
    var tile_colliders: Node3D = world.get("terrain_physics_root")
    if tile_colliders == null:
        _fail("World did not build native physics terrain")
        return
    var solids: int = 0
    var liquids: int = 0
    for child in tile_colliders.get_children():
        var body: StaticBody3D = child as StaticBody3D
        if body == null:
            _fail("Terrain colliders must be StaticBody3D")
            return
        var shape: CollisionShape3D = body.get_node_or_null("Collider") as CollisionShape3D
        if shape == null or not (shape.shape is BoxShape3D):
            _fail("Terrain lost its native BoxShape3D")
            return
        var kind: String = str(body.get_meta("scalfagus_obstacle", ""))
        if kind == "tree":
            solids += 1
            if body.collision_layer != LOS.LOS_MASK:
                _fail("Tree is missing projectile occlusion mask")
                return
        elif kind == "water":
            liquids += 1
            if body.collision_layer != LOS.SURFACE_MASK:
                _fail("Water incorrectly blocks visibility rays")
                return
        else:
            _fail("Terrain has unknown physical obstacle " + kind)
            return
    if solids != 49 or liquids != 148:
        _fail("Expected exact authored raster: 49 trunks, 148 water cells")
        return

    # Trunks obscure straight shots; water is *walk-blocked* but transparent
    # above the surface. Positions deliberately have no nearby structures.
    var trunk: Dictionary = world.physics_los_probe(Vector2i(19, 15), Vector2i(23, 15))
    if bool(trunk.get("clear", true)) or str(trunk.get("hit_kind", "")) != "tree":
        _fail("Native PhysicsDirectSpaceState3D ray missed an authored tree")
        return
    var pond: Dictionary = world.physics_los_probe(Vector2i(31, 20), Vector2i(33, 20))
    if not bool(pond.get("clear", false)):
        _fail("Water should not stop an above-water LOS ray")
        return

    var sim = world.get("sim")
    var hq_id: int = sim.units_for(0, "hq")[0]
    var hq: Dictionary = sim.entities[hq_id]
    var hq_body: StaticBody3D = world.get("unit_nodes")[hq_id].get_node_or_null("FootprintBody") as StaticBody3D
    if hq_body == null or int(hq_body.get_meta("scalfagus_entity_id", -1)) != hq_id:
        _fail("Completed building collider lost stable authoritative entity ID")
        return
    var target: Dictionary = world.physics_los_probe(Vector2i(14, 9), Vector2i(9, 9), hq_id)
    if not bool(target.get("clear", false)) or int(target.get("hit_entity_id", -1)) != hq_id:
        _fail("A target building must be hit at its near 3x3 face")
        return
    var through: Dictionary = world.physics_los_probe(Vector2i(14, 9), Vector2i(4, 9))
    if bool(through.get("clear", true)) or int(through.get("hit_entity_id", -1)) != hq_id:
        _fail("A completed HQ did not obstruct a shot through its entire 6m body")
        return

    # The simulation controls death; removing visuals releases the physics
    # collider at the next safe engine frame.
    sim._damage(hq_id, 2000, 1)
    world._sync_visuals()
    await physics_frame
    await physics_frame
    through = world.physics_los_probe(Vector2i(14, 9), Vector2i(4, 9))
    if not bool(through.get("clear", false)):
        _fail("Destroyed HQ retained stale 3D occlusion")
        return
    if not sim.matter_is_conserved():
        _fail("Raycast or collider teardown modified match Matter")
        return
    world.queue_free()
    print("SCALFAGUS_MIRROR_PHYSICS_LOS_PASS")
    quit(0)
