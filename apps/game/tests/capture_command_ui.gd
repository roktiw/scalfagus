extends SceneTree

# Render-only local QA captures; excluded from release exports.
var output: String

func _initialize() -> void:
    output = OS.get_environment("SCALFAGUS_CAPTURE_DIR")
    if output == "":
        push_error("SCALFAGUS_CAPTURE_DIR is required")
        quit(1)
        return
    DirAccess.make_dir_recursive_absolute(output)
    call_deferred("_run")

func _capture(filename: String) -> void:
    await process_frame
    await process_frame
    await RenderingServer.frame_post_draw
    var image := root.get_texture().get_image()
    if image.save_png(output.path_join(filename)) != OK:
        push_error("Cannot save UI capture")
        quit(1)

func _run() -> void:
    var menu = load("res://scenes/menu.tscn").instantiate()
    root.add_child(menu)
    await _capture("menu.png")
    menu._open_options()
    await _capture("settings.png")
    menu.queue_free()
    await process_frame
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var game = load("res://scenes/mirror_match.tscn").instantiate()
    root.add_child(game)
    game.set_process(false)
    game.selected_id = game.sim.units_for(0, "hq")[0]
    game.selected_ids.assign([game.selected_id])
    game._sync_visuals()
    await _capture("command-hud.png")
    game._toggle_pause()
    await _capture("pause.png")
    game._match_settings()
    await _capture("match-settings.png")
    print("SCALFAGUS_UI_CAPTURE_PASS")
    game.queue_free()
    await process_frame
    quit(0)
