extends SceneTree

# Real native scene-level regression for one-human victory, defeat, draw,
# clean replay-safe retry and return to main menu. No direct fake UI state.
const GAME = preload("res://scenes/mirror_match.tscn")
const UI = preload("res://scripts/mirror_match_result_overlay.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(reason: String) -> void:
    push_error("SCALFAGUS_MATCH_RESULT_FAIL: " + reason)
    quit(1)

func _finish_by_hq_loss(world: Node3D, defeated_side: int) -> void:
    var sim = world.get("sim")
    var headquarters: Array[int] = sim.units_for(defeated_side, "hq")
    assert(headquarters.size() == 1)
    sim._damage(headquarters[0], 5000, 1 - defeated_side)
    sim._check_end()
    world._sync_visuals()

func _verify() -> void:
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var world: Node3D = GAME.instantiate()
    root.add_child(world)
    current_scene = world
    await process_frame

    var sim = world.get("sim")
    var original_hash: String = sim.replay_hash()
    if sim.finished or world.get("match_result_overlay") != null:
        _fail("An unfinished Human-vs-Bot match showed terminal overlay")
        return
    if sim.controllers != ["human", "bot"]:
        _fail("Wrong initial controllers")
        return
    _finish_by_hq_loss(world, 1)
    var overlay: MirrorMatchResultOverlay = world.get("match_result_overlay") as MirrorMatchResultOverlay
    if overlay == null or not overlay.visible or overlay.headline.text != "VICTORY":
        _fail("Defeating enemy HQ did not display a visible player victory")
        return
    if overlay.restart_button == null or overlay.menu_button == null or not overlay.save_button.visible:
        _fail("Victory menu lost Play Again, Main Menu or Save Replay")
        return
    if overlay.mouse_filter != Control.MOUSE_FILTER_STOP or (overlay.get_node("ResultShade") as Control).mouse_filter != Control.MOUSE_FILTER_STOP:
        _fail("Terminal modal fails to block world pointer input")
        return
    var post_victory_hash: String = sim.replay_hash()
    world._sync_visuals()
    if world.get("match_result_overlay") != overlay:
        _fail("Repeated UI sync spawned multiple result overlays")
        return
    if sim.replay_hash() != post_victory_hash or sim.replay_hash() == original_hash:
        _fail("Result rendering changed the game state")
        return
    world._toggle_pause()
    if world.paused:
        _fail("Terminal result allowed a second hidden pause screen")
        return
    world._process(4.0)
    if sim.replay_hash() != post_victory_hash:
        _fail("Finished match still advances under result screen")
        return

    # A *real native button signal* triggers scene replacement, not a
    # direct call to constructor or a shallow test of label strings.
    overlay.restart_button.pressed.emit()
    await process_frame
    await process_frame
    var retry: Node = current_scene
    if retry == null or retry == world or retry.name != "MirrorMatch":
        _fail("Play Again did not launch a new match scene")
        return
    var retry_sim = retry.get("sim")
    if retry_sim == null or retry_sim.tick != 0 or retry_sim.finished:
        _fail("Play Again inherited an old finished world or nonzero tick")
        return
    if retry_sim.controllers != ["human", "bot"]:
        _fail("Play Again did not preserve one-human mode")
        return
    if retry.get("match_result_overlay") != null:
        _fail("Old modal leaked into a fresh match")
        return
    if not retry_sim.matter_is_conserved():
        _fail("Restart incorrectly transferred Matter between matches")
        return

    # On the restarted match, player-side completed HQ elimination must
    # produce DEFEAT; terminal Esc must not open another competing panel.
    _finish_by_hq_loss(retry, 0)
    var loss_ui: MirrorMatchResultOverlay = retry.get("match_result_overlay") as MirrorMatchResultOverlay
    if loss_ui == null or loss_ui.headline.text != "DEFEAT":
        _fail("Loss of player's final HQ did not display DEFEAT")
        return
    loss_ui.menu_button.pressed.emit()
    await process_frame
    await process_frame
    if current_scene == null or current_scene.name != "MainMenu":
        _fail("Result screen Main Menu action did not return to native menu")
        return
    if str(ProjectSettings.get_setting("scalfagus/mirror_mode", "")) != "human_bot":
        _fail("Main Menu kept a stale spectator/replay mode")
        return

    # Spectator results refer to map slots, not a fake human victory.
    current_scene.queue_free()
    await process_frame
    ProjectSettings.set_setting("scalfagus/mirror_mode", "bot_bot")
    var spectator: Node3D = GAME.instantiate()
    root.add_child(spectator)
    current_scene = spectator
    await process_frame
    _finish_by_hq_loss(spectator, 1)
    var spect_ui: MirrorMatchResultOverlay = spectator.get("match_result_overlay") as MirrorMatchResultOverlay
    if spect_ui == null or spect_ui.headline.text != "NORTHWEST WINS" or spect_ui.save_button.visible:
        _fail("Bot spectator incorrectly showed player victory or offered human replay save")
        return

    # Simultaneously eliminated completed HQs must display DRAW, not an
    # arbitrary victory, and still give the user a menu/retry path.
    spectator.queue_free()
    await process_frame
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var drawn: Node3D = GAME.instantiate()
    root.add_child(drawn)
    current_scene = drawn
    await process_frame
    var draw_sim = drawn.get("sim")
    for side in range(2):
        var id: int = draw_sim.units_for(side, "hq")[0]
        draw_sim._damage(id, 5000, 1 - side)
    draw_sim._check_end()
    drawn._sync_visuals()
    var draw_ui: MirrorMatchResultOverlay = drawn.get("match_result_overlay") as MirrorMatchResultOverlay
    if draw_sim.winner != -1 or draw_ui == null or draw_ui.headline.text != "DRAW":
        _fail("Mutual building elimination did not render DRAW")
        return
    if not draw_sim.matter_is_conserved():
        _fail("Draw screen mutated final Matter custody")
        return
    print("SCALFAGUS_MATCH_RESULT_PASS")
    quit(0)
