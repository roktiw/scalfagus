extends SceneTree

func _initialize() -> void:
    call_deferred("_verify")

func _verify() -> void:
    var menu := load("res://scenes/menu.tscn") as PackedScene
    if menu == null:
        push_error("Missing main menu scene")
        quit(1)
        return
    var screen := menu.instantiate()
    root.add_child(screen)
    await process_frame
    if screen.get("menu_panel") == null or screen.get("options_panel") == null:
        push_error("Main menu controls missing")
        quit(2)
        return
    screen.call("_open_options")
    if not (screen.get("options_panel") as Control).visible or (screen.get("menu_panel") as Control).visible:
        push_error("Options view failed")
        quit(3)
        return
    screen.call("_close_options")
    if (screen.get("options_panel") as Control).visible or not (screen.get("menu_panel") as Control).visible:
        push_error("Main menu back transition failed")
        quit(4)
        return
    if not ResourceLoader.exists("res://scenes/main.tscn"):
        push_error("Start scene missing")
        quit(5)
        return
    var mirror := load("res://scenes/mirror_match.tscn") as PackedScene
    if mirror == null:
        push_error("MVP 0.1 mirror RTS scene missing")
        quit(6)
        return
    print("SCALFAGUS_MENU_PASS")
    quit(0)
