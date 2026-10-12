extends SceneTree

# Post-merge MVP0 Human-vs-Bot integration regression. Native Godot is
# required; committing this script does NOT constitute a passing QA run.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const REPLAY = preload("res://scripts/mirror_replay_archive.gd")
const SESSION = preload("res://scripts/mirror_replay_session.gd")
const GAME = preload("res://scenes/mirror_match.tscn")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_SINGLEPLAYER_INTEGRATION_FAIL: " + message)
    quit(1)

func _verify() -> void:
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var game: Node3D = GAME.instantiate()
    root.add_child(game)
    await process_frame

    var sim: MirrorMatchState = game.get("sim")
    var deck = game.get("command_hud")
    var mini = deck.get("minimap") if deck != null else null
    var fog = game.get("fog")
    if sim == null or mini == null or fog == null:
        _fail("Native integrated match lacks simulation, minimap, or fog")
        return

    var own_hq: int = sim.units_for(0, "hq")[0]
    var enemy_hq: int = sim.units_for(1, "hq")[0]
    var enemy_cell: Vector2i = sim.entities[enemy_hq]["pos"]
    var baseline_hash: String = sim.replay_hash()

    if mini._vision_state(enemy_cell) != 0 or mini._entity_is_visible(sim.entities[enemy_hq]):
        _fail("Minimap leaked the enemy HQ through unexplored shroud")
        return
    if mini._vision_state(sim.entities[own_hq]["pos"]) != 2:
        _fail("Minimap hid the currently visible friendly HQ")
        return

    var hidden: Dictionary = {}
    var seen: Dictionary = {}
    for sid in sim.sources.keys():
        var deposit: Dictionary = sim.sources[sid]
        if fog.is_visible(deposit["pos"], 0):
            seen = deposit
        else:
            hidden = deposit
    if seen.is_empty() or hidden.is_empty():
        _fail("Map fixture requires at least one visible and one hidden Matter source")
        return
    if not mini._source_is_visible(seen) or mini._source_is_visible(hidden):
        _fail("Minimap Matter source visibility diverged from real fog")
        return

    # Explored terrain remains remembered, but live hidden stock/actors
    # still cannot be exposed by reusing the complete simulation dictionaries.
    fog.discovered[0][enemy_cell] = true
    fog.discovered[0][hidden["pos"]] = true
    if mini._vision_state(enemy_cell) != 1:
        _fail("Explored-but-unseen minimap geography not dimmed")
        return
    if mini._entity_is_visible(sim.entities[enemy_hq]) or mini._source_is_visible(hidden):
        _fail("Explored minimap reveals hidden live unit or resource state")
        return
    if sim.replay_hash() != baseline_hash or not sim.matter_is_conserved():
        _fail("Drawing or querying minimap mutated authoritative gameplay")
        return

    # Construction interruption switched the hash to v6. Capture, result
    # provenance and playback must use the same rule identity.
    if sim.result()["rules"] != MATCH.RULES_ID:
        _fail("Result rules metadata still mismatches authoritative hash")
        return
    var archive: Dictionary = REPLAY.capture(sim)
    if archive["rules"] != MATCH.RULES_ID:
        _fail("Fresh replay archive does not declare active v6 rules")
        return
    if not bool(REPLAY.prepare(archive).get("ok", false)):
        _fail("New v6 replay could not validate its own rules")
        return
    var obsolete: Dictionary = archive.duplicate(true)
    obsolete["rules"] = "mvp0-man-mirror-v5-3x3-world2m"
    if REPLAY.prepare(obsolete).get("reason", "") != "rules_mismatch":
        _fail("Obsolete v5 capture incorrectly accepted after v6 rules")
        return

    # Restart is a fresh replay timeline. Old explored cells are not
    # allowed to carry over into the newly reconstructed HUD/minimap.
    var session: MirrorReplaySession = SESSION.new()
    if not bool(session.begin(archive).get("ok", false)):
        _fail("Cannot initialize playback session from valid archive")
        return
    game.set("replay_mode", true)
    game.set("replay_session", session)
    game._restart_replay()
    var restarted: MirrorMatchState = game.get("sim")
    if restarted != session.sim or restarted.tick != 0:
        _fail("Replay restart did not install the fresh authoritative match")
        return
    if fog.is_discovered(enemy_cell, 0) or fog.is_discovered(hidden["pos"], 0):
        _fail("Replay restart leaked previously discovered hidden cells")
        return
    if restarted.replay_hash() != baseline_hash or not restarted.matter_is_conserved():
        _fail("Replay restart did not reproduce exact initial state and Matter")
        return

    print("SCALFAGUS_SINGLEPLAYER_INTEGRATION_PASS")
    quit(0)
