extends SceneTree

# Run with: godot --headless --path apps/game --script res://tests/smoke.gd
# Before testing: godot --headless --path apps/game --editor --import --quit

func _initialize() -> void:
    call_deferred("_verify")

func _verify() -> void:
    var scene: PackedScene = load("res://scenes/main.tscn")
    if scene == null:
        push_error("Cannot load Scalfagus main.tscn")
        quit(1)
        return
    var main: Node3D = scene.instantiate()
    root.add_child(main)
    await process_frame
    await process_frame

    var hero: Node = main.get_node_or_null("Hero")
    var camera: Camera3D = main.get_node_or_null("UnifiedCamera")
    var terrain: Node = main.get_node_or_null("Terrain")
    var lander: Node = main.get_node_or_null("Lander")
    if hero == null or camera == null or terrain == null or lander == null:
        push_error("Required actors/terrain/camera/lander absent")
        quit(2)
        return

    var viz: Node = hero.get_node_or_null("Visual")
    var rows: Array[int] = [0, 1, 2, 3, 4, 3, 2, 1]
    var flip: Array[bool] = [false, false, false, false, false, true, true, true]
    for sector in range(8):
        var data: Dictionary = viz.resolve_sector(float(sector) * 45.0)
        if int(data["row"]) != rows[sector] or bool(data["flip"]) != flip[sector]:
            push_error("Wrong five-view sector %d" % sector)
            quit(3)
            return

    var id_before: String = hero.entity_id
    for mode in [0, 1, 2, 0]:
        main._apply_mode(mode)
        if hero.entity_id != id_before or hero.hp != 100:
            push_error("View changed authoritative Hero identity/HP")
            quit(4)
            return
        if mode == 2 and hero.display.visible:
            push_error("FPS camera should not render own billboard")
            quit(5)
            return
        if mode != 2 and not hero.display.visible:
            push_error("RTS/TPP camera should show Hero billboard")
            quit(6)
            return

    if hero.display.sprite.texture.get_height() != 48 * 5:
        push_error("Five-row Hero atlas incorrectly sized")
        quit(7)
        return
    print("SCALFAGUS_SMOKE_PASS: one world, three modes, 5->8 mapping, same hero, PNG import")
    quit(0)
