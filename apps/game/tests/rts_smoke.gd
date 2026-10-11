extends SceneTree

# Run after Godot --editor --import with --headless --script res://tests/rts_smoke.gd
func _initialize() -> void:
    call_deferred("_verify")

func _verify() -> void:
    var scene: PackedScene = load("res://scenes/main.tscn")
    if scene == null:
        push_error("RTS smoke: scene not found")
        quit(1)
        return
    var game: Node3D = scene.instantiate()
    root.add_child(game)
    await process_frame
    await process_frame
    if game.get("view_mode") != 0:
        push_error("RTS smoke: RTS is not the default camera")
        quit(2)
        return
    var units: Array = game.get("selectable_units")
    if units.size() < 5:
        push_error("RTS smoke: expected hero, MAN workers, buildings")
        quit(3)
        return
    if game.get_node_or_null("ETH_Nexus") == null or game.get_node_or_null("MAN_UMU") == null:
        push_error("RTS smoke: two faction fixtures missing")
        quit(4)
        return
    if game.get_node_or_null("Water_-4") == null:
        push_error("RTS smoke: jungle water fixture missing")
        quit(5)
        return
    var hero: CharacterBody3D = game.get_node("Hero")
    if not hero.get("selected"):
        push_error("RTS smoke: initial hero selection missing")
        quit(6)
        return
    var focus_before: Vector3 = game.get("camera_focus")
    game.set("camera_focus", focus_before + Vector3(4.0, 0.0, -3.0))
    game.call("_update_camera", 0.0)
    var focus_after: Vector3 = game.get("camera_focus")
    if focus_after == focus_before:
        push_error("RTS smoke: camera focus did not update")
        quit(7)
        return
    var target: Vector3 = hero.global_position + Vector3(2.5, 0.0, 0.0)
    hero.call("issue_move", target)
    if not hero.get("has_command"):
        push_error("RTS smoke: move command not registered")
        quit(8)
        return
    for mode in [1, 2, 0]:
        game.call("_apply_mode", mode)
        if not hero.is_inside_tree() or hero.get("entity_id") != "man.hero.prototype-001":
            push_error("RTS smoke: authoritative hero replaced")
            quit(9)
            return
    if game.get_node_or_null("HUD/SelectedUnitHud") != null:
        push_error("RTS smoke: unexpected flat HUD path")
        quit(10)
        return
    print("SCALFAGUS_RTS_SMOKE_PASS: camera focus, two-faction fixture, commands, selection, shared actor")
    quit(0)
