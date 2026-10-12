extends SceneTree

# Import + scene-regression test. The MAN mirror must use actual five-view
# sprites (not just procedural cubes), and open with an appropriately sized UI.
func _initialize() -> void:
    call_deferred("_verify")

func _fail(why: String) -> void:
    push_error("SCALFAGUS_MIRROR_VISUAL_FAIL: " + why)
    quit(1)

func _verify() -> void:
    var packed: PackedScene = load("res://scenes/mirror_match.tscn")
    if packed == null:
        _fail("Cannot load mirror RTS scene")
        return
    var world: Node3D = packed.instantiate()
    root.add_child(world)
    await process_frame
    await process_frame

    var sprites: Dictionary = world.get("unit_nodes")
    var sim = world.get("sim")
    if sprites.size() != 8:
        _fail("Expected 2 HQ and 6 workers in mirrored starting state")
        return

    var workers: int = 0
    var hqs: int = 0
    for id in sprites.keys():
        var actor: Node3D = sprites[id]
        var visual: Node = actor.get_node_or_null("Visual")
        if visual == null or not (visual.get("sprite") is Sprite3D):
            _fail("Entity #%d lost its Sprite3D directional atlas" % id)
            return
        var sprite: Sprite3D = visual.get("sprite")
        if sprite.texture == null or not sprite.region_enabled:
            _fail("Entity #%d has no active sprite texture/region" % id)
            return
        var e: Dictionary = sim.entities[id]
        var kind: String = str(e["kind"])
        if kind == "hq":
            var body: StaticBody3D = actor.get_node_or_null("FootprintBody") as StaticBody3D
            var collision: CollisionShape3D = null
            if body != null:
                collision = body.get_node_or_null("FootprintShape") as CollisionShape3D
            if collision == null or not (collision.shape is BoxShape3D):
                _fail("HQ lost its actual Godot 3D collision")
                return
            if absf((collision.shape as BoxShape3D).size.x * actor.scale.x - 6.0) > 0.01:
                _fail("HQ collision should be exactly six metres wide")
                return
        if kind == "worker":
            workers += 1
            if sprite.texture.get_width() != 32 or sprite.texture.get_height() != 240:
                _fail("Worker atlas has wrong five-view frame dimensions")
                return
        elif kind == "hq":
            hqs += 1
            if sprite.texture.get_width() != 128 or sprite.texture.get_height() != 640:
                _fail("HQ lander atlas is unavailable")
                return
    if workers != 6 or hqs != 2:
        _fail("Unexpected source-unit sprites in starting match")
        return

    var resources: Dictionary = world.get("source_nodes")
    if resources.size() != 10:
        _fail("Expected all ten authored resource sources")
        return
    for sid in resources.keys():
        var ore: Node3D = resources[sid]
        if ore.get_node_or_null("Visual") == null:
            _fail("Resource %s lost its rock sprite" % str(sid))
            return

    var tree_sprite_count: int = 0
    var terrain_root: Node3D = world.get("world_root")
    for node in terrain_root.get_children():
        if node is Node3D and node.get_node_or_null("Visual") != null:
            var tree_visual: Node = node.get_node_or_null("Visual")
            var tree_sprite: Sprite3D = tree_visual.get("sprite")
            if tree_sprite != null and tree_sprite.texture != null and tree_sprite.texture.get_width() == 40:
                tree_sprite_count += 1
    if tree_sprite_count < 2:
        _fail("Tree terrain reverted to cube placeholders")
        return

    var game_camera: Camera3D = world.get("camera")
    if game_camera == null or game_camera.size > 130.0:
        _fail("Human RTS camera starts too zoomed out")
        return
    if sim.tile_meters != 2.0:
        _fail("Godot scene lost authored 2 metre scale")
        return
    var northwest_hq: int = sim.units_for(0, "hq")[0]
    var nw_cell: Vector2i = sim.entities[northwest_hq]["pos"]
    var nw_node: Node3D = sprites[northwest_hq]
    if nw_node.position != Vector3(nw_cell.x * 2.0, 0.0, nw_cell.y * 2.0):
        _fail("Simulation grid and render space are misaligned")
        return
    if int(ProjectSettings.get_setting("display/window/size/viewport_width", 0)) != 1280 or int(ProjectSettings.get_setting("display/window/size/viewport_height", 0)) != 720:
        _fail("Project lost its baseline logical viewport")
        return
    if int(ProjectSettings.get_setting("display/window/size/window_width_override", 0)) != 0 or int(ProjectSettings.get_setting("display/window/size/window_height_override", 0)) != 0:
        _fail("Project reintroduced a forced native window size")
        return

    print("SCALFAGUS_MIRROR_VISUAL_PASS")
    quit(0)
