extends SceneTree

# No GitHub Actions runner dependency: actual local Godot smoke validates the
# remappable RTS InputMap and Keychain's embedded Options panel.
const MENU = preload("res://scenes/menu.tscn")
const MATCH = preload("res://scenes/mirror_match.tscn")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(why: String) -> void:
    push_error("SCALFAGUS_KEYCHAIN_RTS_FAIL: " + why)
    quit(1)

func _verify() -> void:
    var keychain: Node = root.get_node_or_null("Keychain")
    if keychain == null or keychain.get("selected_profile") == null:
        _fail("Keychain autoload or current profile was not initialized")
        return

    # T trains workers; W belongs exclusively to RTS camera pan.
    var expected: Dictionary = {
        "rts_pan_up": KEY_W,
        "rts_pan_down": KEY_S,
        "rts_pan_left": KEY_A,
        "rts_pan_right": KEY_D,
        "rts_build_barracks": KEY_B,
        "rts_train_worker": KEY_T,
        "rts_train_rifleman": KEY_R,
        "rts_pause": KEY_P,
        "rts_speed_up": KEY_EQUAL,
        "rts_speed_down": KEY_MINUS
    }
    for action in expected.keys():
        if not InputMap.has_action(action):
            _fail("Missing InputMap action " + str(action))
            return
        # Read project defaults rather than the mutable runtime InputMap:
        # users are explicitly allowed to remap all of these actions.
        var project_action: Dictionary = ProjectSettings.get_setting(
            "input/" + str(action), {}
        )
        var found: bool = false
        for mapping in project_action.get("events", []):
            var mapped_key := mapping as InputEventKey
            if mapped_key != null and (
                    mapped_key.physical_keycode == int(expected[action])
                    or mapped_key.keycode == int(expected[action])):
                found = true
        if not found:
            _fail("Project default binding missing for " + str(action))
            return

    var editor: PackedScene = load("res://addons/keychain/ShortcutEdit.tscn")
    if editor == null:
        _fail("Selected Keychain ShortcutEdit addon component is unavailable")
        return

    var menu := MENU.instantiate()
    root.add_child(menu)
    await process_frame
    menu.call("_open_options")
    await process_frame
    var controls: Control = menu.get("shortcut_editor") as Control
    if controls == null or not controls.is_inside_tree():
        _fail("Options did not embed the vendored Keychain ShortcutEdit")
        return
    menu.call("_close_options")
    menu.queue_free()
    await process_frame

    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var game := MATCH.instantiate()
    root.add_child(game)
    await process_frame
    var sim = game.get("sim")
    var hqs: Array[int] = sim.units_for(0, "hq")
    if hqs.is_empty():
        _fail("Cannot inspect RTS training hotkeys without a Command Core")
        return
    var hq: Dictionary = sim.entities[hqs[0]]
    game.set("selected_id", int(hqs[0]))

    # Isolate keyboard test from the user's saved Keychain profile.
    # Temporarily map the action to T; restore their mapping afterwards.
    var saved_bindings: Array[InputEvent] = InputMap.action_get_events("rts_train_worker")
    InputMap.action_erase_events("rts_train_worker")
    var temporary_t := InputEventKey.new()
    temporary_t.physical_keycode = KEY_T
    InputMap.action_add_event("rts_train_worker", temporary_t)

    # Pressing W must not train Workers anymore. Keychain remapping must be
    # observed by event.is_action_pressed, not duplicated hardcoded KEY_W.
    var w := InputEventKey.new()
    w.physical_keycode = KEY_W
    w.pressed = true
    game.call("_unhandled_input", w)
    if str(hq["train_kind"]) != "":
        _fail("W conflicted with Worker production")
        return

    sim.mined_matter = 100
    sim.players[0]["matter"] = 100
    var t := InputEventKey.new()
    t.physical_keycode = KEY_T
    t.pressed = true
    game.call("_unhandled_input", t)
    if str(hq["train_kind"]) != "worker" or int(sim.players[0]["matter"]) != 65:
        _fail("T did not route legal Worker production through MatchState")
        return

    # Swap the mapped key at runtime. InputMap must change the command
    # WITHOUT editing mirror_view.gd or sending a fabricated direct order.
    hq["train_kind"] = ""
    hq["train_left"] = 0
    InputMap.action_erase_events("rts_train_worker")
    var remapped := InputEventKey.new()
    remapped.physical_keycode = KEY_Y
    InputMap.action_add_event("rts_train_worker", remapped)
    game.call("_unhandled_input", t)
    if str(hq["train_kind"]) != "":
        _fail("Old T key remained active after remapping")
        return
    var y := InputEventKey.new()
    y.physical_keycode = KEY_Y
    y.pressed = true
    game.call("_unhandled_input", y)
    if str(hq["train_kind"]) != "worker":
        _fail("New Y key did not control production after remapping")
        return
    InputMap.action_erase_events("rts_train_worker")
    for binding in saved_bindings:
        InputMap.action_add_event("rts_train_worker", binding)

    # Pan uses the actual action state, not hardcoded physical scancodes.
    var before: Vector3 = game.get("camera_center")
    Input.action_press("rts_pan_up")
    game.call("_process", 0.016)
    Input.action_release("rts_pan_up")
    var after: Vector3 = game.get("camera_center")
    if after.z >= before.z:
        _fail("RTS camera did not consume remappable pan action")
        return

    print("SCALFAGUS_KEYCHAIN_RTS_PASS")
    quit(0)
