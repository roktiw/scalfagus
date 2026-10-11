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
    if resources.size() != 4:
        _fail("Expected all four resource sources")
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
            var visual: Node = node.get_node_or_null("Visual")
            var sprite: Sprite3D = visual.get("sprite")
            if sprite != null and sprite.texture != null and sprite.texture.get_width() == 40:
                tree_sprite_count += 1
    if tree_sprite_count < 2:
        _fail("Tree terrain reverted to cube placeholders")
        return

    var game_camera: Camera3D = world.get("camera")
    if game_camera == null or game_camera.size > 65.0:
        _fail("Human RTS camera starts too zoomed out")
        return
    var window_width: int = int(ProjectSettings.get_setting(
        "display/window/size/window_width_override", 0))
    var window_height: int = int(ProjectSettings.get_setting(
        "display/window/size/window_height_override", 0))
    if window_width < 1280 or window_height < 720:
        _fail("Project startup window is too small")
        return

    print("SCALFAGUS_MIRROR_VISUAL_PASS")
    quit(0)
