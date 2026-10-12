extends SceneTree

func _initialize() -> void:
    call_deferred("_run")

func _fail(reason: String) -> void:
    push_error("SCALFAGUS_COMMAND_UI_FAIL: " + reason)
    quit(1)

func _run() -> void:
    var menu = load("res://scenes/menu.tscn").instantiate()
    root.add_child(menu)
    await process_frame
    menu._open_options()
    await process_frame
    await process_frame
    var bounds := Rect2(Vector2.ZERO, root.get_visible_rect().size)
    if not bounds.encloses(menu.back_button.get_global_rect()):
        _fail("Settings Back button is outside the viewport")
        return
    if menu.back_button.get_parent() == menu.settings_scroll:
        _fail("Settings Back is inside the scrollable content")
        return
    for dimensions in [Vector2i(960, 540), Vector2i(1280, 720)]:
        root.content_scale_size = dimensions
        await process_frame
        await process_frame
        if not Rect2(Vector2.ZERO, Vector2(dimensions)).encloses(menu.back_button.get_global_rect()):
            _fail("Back button clipped at %s" % dimensions)
            return
    menu.back_button.pressed.emit()
    if menu.options_panel.visible:
        _fail("Settings Back did not return to main menu")
        return
    menu.queue_free()
    await process_frame
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var game = load("res://scenes/mirror_match.tscn").instantiate()
    root.add_child(game)
    await process_frame
    await process_frame
    var sim = game.sim
    var hq: int = sim.units_for(0, "hq")[0]
    game.selected_ids.assign([hq])
    game.selected_id = hq
    game._sync_visuals()
    if not Rect2(Vector2.ZERO, root.get_visible_rect().size).encloses(game.command_hud.dock.get_global_rect()):
        _fail("Bottom HUD is clipped outside the viewport")
        return
    if game.command_hud.portrait.texture == null or game.command_hud.unit_name.text != "COMMAND CORE":
        _fail("Selected HQ portrait or identity missing")
        return
    var sprite = game.unit_nodes[hq].get_node("Visual")
    print("SCALFAGUS_HQ_SOURCE_ROWS ", sprite.source_rows)
    var image: Image = sprite.sprite.texture.get_image()
    for sector in range(8):
        sprite._apply(sector)
        var region: Rect2 = sprite.sprite.region_rect
        var opaque: int = 0
        for y in range(int(region.position.y), int(region.end.y)):
            for x in range(int(region.position.x), int(region.end.x)):
                if image.get_pixel(x, y).a >= 0.5:
                    opaque += 1
        if opaque < 500:
            _fail("HQ view %d renders empty speckles (%d pixels)" % [sector, opaque])
            return
    sim.players[0]["matter"] = 100
    sim.mined_matter = 100
    game._sync_visuals()
    game.command_hud.buttons["train_worker"].pressed.emit()
    if sim.entities[hq]["train_kind"] != "worker" or sim.players[0]["matter"] != 65:
        _fail("HUD production bypassed or failed authoritative debit")
        return
    game._toggle_pause()
    var tick: int = sim.tick
    game._process(1.0)
    if not game.paused or sim.tick != tick:
        _fail("Pause menu did not stop simulation")
        return
    game._match_settings()
    await process_frame
    game.settings_overlay._close_options()
    if game.settings_overlay != null or not game.pause_overlay.visible:
        _fail("In-match Settings did not return to pause menu")
        return
    game._toggle_pause()
    if game.paused:
        _fail("Resume did not restore gameplay")
        return
    game.queue_free()
    await process_frame
    print("SCALFAGUS_COMMAND_UI_PASS: sticky back, portraits, opaque HQ views, production, pause/settings/resume")
    quit(0)
