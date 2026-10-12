extends SceneTree

# Real viewport-pointer regression: direct calls to _open_options() alone
# cannot prove the buttons are clickable. Uses native Viewport.push_input.
const MENU = preload("res://scenes/menu.tscn")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_MENU_POINTER_FAIL: " + message)
    quit(1)

func _click(button: Button) -> void:
    var point: Vector2 = button.get_global_rect().get_center()
    var motion := InputEventMouseMotion.new()
    motion.position = point
    motion.global_position = point
    root.push_input(motion, true)
    var down := InputEventMouseButton.new()
    down.position = point
    down.global_position = point
    down.button_index = MOUSE_BUTTON_LEFT
    down.pressed = true
    root.push_input(down, true)
    var up := InputEventMouseButton.new()
    up.position = point
    up.global_position = point
    up.button_index = MOUSE_BUTTON_LEFT
    up.pressed = false
    root.push_input(up, true)

func _verify() -> void:
    var menu := MENU.instantiate()
    root.add_child(menu)
    current_scene = menu
    await process_frame
    await process_frame

    var background: ColorRect = menu.get_child(0) as ColorRect
    var play: Button = menu.get("play_button")
    var options: Button = menu.get("options_button")
    var back: Button = menu.get("back_button")
    var menu_controls: VBoxContainer = menu.get("menu_panel")
    var option_controls: VBoxContainer = menu.get("options_panel")
    if background == null or play == null or options == null or back == null:
        _fail("Missing viewport background or native clickable menu buttons")
        return
    if background.mouse_filter != Control.MOUSE_FILTER_IGNORE:
        _fail("Fullscreen color overlay intercepts mouse input")
        return
    if menu.mouse_filter == Control.MOUSE_FILTER_IGNORE or options.mouse_filter == Control.MOUSE_FILTER_IGNORE:
        _fail("Menu or button cannot receive pointer input")
        return
    var view_size: Vector2 = root.get_visible_rect().size
    if menu.size.x < view_size.x - 2.0 or menu.size.y < view_size.y - 2.0:
        _fail("Main menu did not stretch to the complete native viewport")
        return

    _click(options)
    await process_frame
    if not option_controls.visible or menu_controls.visible:
        _fail("Actual pointer click did not activate OPTIONS")
        return
    _click(back)
    await process_frame
    if option_controls.visible or not menu_controls.visible:
        _fail("Actual pointer click did not activate BACK")
        return

    # No direct function call: PLAY must be a genuinely clickable Button.
    _click(play)
    await process_frame
    await process_frame
    if current_scene == null or current_scene.name != "MirrorMatch":
        _fail("Actual pointer click did not launch the single-player RTS scene")
        return
    var match_state = current_scene.get("sim")
    if match_state == null or match_state.controllers != ["human", "bot"]:
        _fail("PLAY did not start exactly one human and one bot")
        return
    print("SCALFAGUS_MENU_POINTER_PASS")
    quit(0)
