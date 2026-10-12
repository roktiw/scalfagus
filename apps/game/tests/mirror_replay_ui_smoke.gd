extends SceneTree

# Scene-level acceptance: a visible pause menu can save an actual H-C match
# and the main menu opens its verified stream, with commands disabled.
const GAME = preload("res://scenes/mirror_match.tscn")
const MENU = preload("res://scenes/menu.tscn")
const REPLAY = preload("res://scripts/mirror_replay_archive.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_REPLAY_UI_FAIL: " + message)
    quit(1)

func _verify() -> void:
    var name: String = "qa-replay-ui-%d-%d" % [OS.get_process_id(), Time.get_ticks_usec()]
    ProjectSettings.set_setting("scalfagus/replay_basename", name)
    var path: String = "user://replays/" + name + ".json"
    if FileAccess.file_exists(path):
        _fail("QA replay fixture already exists: refusing to overwrite it")
        return
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var game = GAME.instantiate()
    root.add_child(game)
    await process_frame
    var worker: int = game.sim.units_for(0, "worker")[0]
    if not game.sim.issue_command(0, "gather", worker, "nw_solid_1"):
        _fail("Fixture human gather not accepted")
        return
    for i in range(65):
        game.sim.advance()
    var expected_hash: String = game.sim.replay_hash()
    var expected_tick: int = game.sim.tick
    game._toggle_pause()
    if not game.paused:
        _fail("Pause did not stop player world before replay save")
        return
    var save_button: Button = game.pause_overlay.find_child("SaveReplay", true, false) as Button
    if save_button == null:
        _fail("Pause menu has no native Save Replay button")
        return
    save_button.pressed.emit()
    if not FileAccess.file_exists(path):
        _fail("Save Replay button did not persist the local JSON file")
        return
    if not str(game.info).contains("Replay saved"):
        _fail("Player was not shown replay save feedback")
        return
    var saved: Dictionary = REPLAY.load_user(name)
    if saved.is_empty() or saved["final_hash"] != expected_hash:
        _fail("Saved match hash differs from paused simulation")
        return
    if int(saved.get("format_version", -1)) != 2 or str(saved.get("commands_hash", "")) != REPLAY.command_digest(saved["commands"]):
        _fail("Native pause Save Replay did not use verified archive format 2")
        return
    game.queue_free()
    await process_frame

    var menu = MENU.instantiate()
    root.add_child(menu)
    current_scene = menu
    await process_frame
    var watch: Button = menu.get("replay_button") as Button
    if watch == null or watch.disabled:
        _fail("Existing local replay did not enable Watch Last Replay")
        return
    watch.pressed.emit()
    await process_frame
    await process_frame
    var replay_game = current_scene
    if replay_game == null or replay_game.name != "MirrorMatch":
        _fail("Watch Replay did not open the native Godot match scene")
        return
    if not replay_game.replay_mode or replay_game.replay_session == null:
        _fail("Loaded match scene is still interactive instead of playback")
        return
    if replay_game.sim.tick > 2:
        _fail("Playback pre-simulated the archived match on GUI load")
        return
    if replay_game.sim.controllers != ["human", "bot"]:
        _fail("Playback changed Human vs Bot controller mapping")
        return
    var hq: int = replay_game.sim.units_for(0, "hq")[0]
    replay_game.selected_id = hq
    replay_game.selected_ids.assign([hq])
    replay_game._sync_visuals()
    var before: String = replay_game.sim.replay_hash()
    replay_game._hud_command("train_worker")
    if replay_game.sim.replay_hash() != before:
        _fail("Replay mode allowed local player to mutate the game")
        return
    if not replay_game.command_hud.buttons["train_worker"].disabled:
        _fail("Playback HUD left destructive production controls active")
        return

    for i in range(15):
        if replay_game.replay_session.finished:
            break
        replay_game._process(0.25)
    if not replay_game.replay_session.finished or not replay_game.replay_session.verified:
        _fail("Visible replay did not complete deterministic tick verification")
        return
    if replay_game.sim.replay_hash() != expected_hash or replay_game.sim.tick != expected_tick:
        _fail("Visible playback diverged from saved human RTS match")
        return
    if replay_game.speed != 0:
        _fail("Verified replay did not stop advancing at its recorded last tick")
        return
    replay_game.queue_free()
    await process_frame

    # A corrupted local replay must leave the currently displayed menu
    # untouched, rather than silently starting a fresh Human-vs-Bot match.
    var corrupted: Dictionary = saved.duplicate(true)
    corrupted["commands"][0]["action"] = "altered-rejected-command"
    var forged: FileAccess = FileAccess.open(path, FileAccess.WRITE)
    if forged == null:
        _fail("Could not write isolated test-only corrupted replay fixture")
        return
    forged.store_string(JSON.stringify(corrupted) + "\n")
    forged.close()
    var faulty_menu = MENU.instantiate()
    root.add_child(faulty_menu)
    current_scene = faulty_menu
    await process_frame
    faulty_menu.replay_button.pressed.emit()
    await process_frame
    if current_scene != faulty_menu:
        _fail("Corrupted format-2 replay changed the current scene")
        return
    if not faulty_menu.replay_error.visible or not str(faulty_menu.replay_error.text).contains("command_history_mismatch"):
        _fail("Corrupted replay did not show command hash mismatch to player")
        return
    faulty_menu.queue_free()
    await process_frame
    DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
    ProjectSettings.set_setting("scalfagus/replay_basename", "last-human-match")
    print("SCALFAGUS_REPLAY_UI_PASS")
    quit(0)
