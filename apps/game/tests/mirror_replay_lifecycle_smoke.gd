extends SceneTree
const MATCH = preload("res://scripts/mirror_match_state.gd")
const REPLAY = preload("res://scripts/mirror_replay_archive.gd")

func _initialize() -> void:
    call_deferred("_run")

func _fail(reason: String) -> void:
    push_error("SCALFAGUS_REPLAY_LIFECYCLE_FAIL: " + reason)
    quit(1)

func _until(sim: MirrorMatchState, condition: Callable, limit: int) -> bool:
    for i in range(limit):
        if condition.call():
            return true
        if sim.finished:
            return false
        sim.advance()
    return bool(condition.call())

func _verified(sim: MirrorMatchState, phase: String) -> bool:
    var archive: Variant = JSON.parse_string(JSON.stringify(REPLAY.capture(sim)))
    var result: Dictionary = REPLAY.playback(archive)
    if not bool(result.get("ok", false)):
        _fail("%s: %s" % [phase, result])
        return false
    if result["hash"] != sim.replay_hash() or not sim.matter_is_conserved():
        _fail("Checkpoint hash or Matter mismatch: " + phase)
        return false
    print("SCALFAGUS_REPLAY_CHECKPOINT ", phase, " tick=", sim.tick, " commands=", sim.human_command_history.size(), " hash=", result["hash"])
    return true

func _run() -> void:
    var sim: MirrorMatchState = MATCH.new()
    sim.setup(42, ["human", "bot"])
    var workers: Array[int] = sim.units_for(0, "worker")
    for i in range(workers.size()):
        if not sim.issue_command(0, "gather", workers[i], "nw_solid_1" if i < 2 else "nw_solid_2"):
            _fail("Initial gather rejected")
            return
    if not _until(sim, func(): return sim.players[0]["matter"] >= 135, 10000):
        _fail("Real gather/delivery did not fund training and construction")
        return
    var hq: int = sim.units_for(0, "hq")[0]
    if not sim.issue_command(0, "train_worker", hq):
        _fail("Funded Worker training rejected")
        return
    if not sim.issue_command(0, "build_barracks", workers[0], Vector2i(13, 12)):
        _fail("Funded Barracks order rejected")
        return
    if not _verified(sim, "production-and-build-queued"):
        return
    if not _until(sim, func(): return not sim.units_for(0, "barracks").is_empty(), 3000):
        _fail("Recorded Barracks construction did not complete")
        return
    if sim.units_for(0, "worker").size() != 4:
        _fail("Recorded Worker production did not complete")
        return
    sim.issue_command(0, "gather", workers[0], "nw_solid_1")
    if not _until(sim, func(): return sim.players[0]["matter"] >= 50, 6000):
        _fail("Economy did not fund Rifleman")
        return
    var barracks: int = sim.units_for(0, "barracks")[0]
    if not sim.issue_command(0, "train_rifleman", barracks):
        _fail("Recorded Rifleman production rejected")
        return
    if not _verified(sim, "rifleman-queued"):
        return
    if not _until(sim, func(): return not sim.units_for(0, "rifleman").is_empty(), 300):
        _fail("Rifleman did not spawn")
        return
    var rifle: int = sim.units_for(0, "rifleman")[0]
    if not sim.issue_command(0, "move", rifle, Vector2i(50, 53)):
        _fail("Scout move rejected")
        return
    var attacked: bool = false
    for i in range(4000):
        if sim.finished or not sim.entities.has(rifle):
            break
        for target in sim.sorted_ids():
            if sim.entities[target]["owner"] == 1 and sim.can_see(0, sim.entities[target]["pos"]):
                attacked = sim.issue_command(0, "attack", rifle, target)
                break
        if attacked:
            break
        sim.advance()
    if not attacked:
        _fail("No accepted integer-target attack in human-bot fixture")
        return
    if not _verified(sim, "accepted-attack"):
        return
    var valid: Dictionary = REPLAY.capture(sim)
    for mutation in [
        ["seed", -1, "invalid_seed"],
        ["format_version", 1.5, "unsupported_format"],
        ["format_version", 1, "unsupported_format"],
        ["final_tick", MATCH.MAX_TICKS + 1, "invalid_final_tick"],
        ["final_hash", 123, "invalid_final_hash"],
        ["commands_hash", "short", "invalid_commands_hash"],
        ["commands", "wrong-type", "invalid_commands"],
        ["controllers", ["human", true], "invalid_controllers"],
        ["map_hash", {}, "invalid_map_metadata"],
        ["map_id", [], "invalid_map_metadata"],
        ["map_source_sha", null, "invalid_map_metadata"],
        ["archive_type", {}, "unsupported_archive"],
        ["rules", [], "invalid_rules_metadata"]
    ]:
        var malformed: Dictionary = valid.duplicate(true)
        malformed[mutation[0]] = mutation[1]
        var rejected: Dictionary = REPLAY.playback(malformed)
        if rejected.get("reason", "") != mutation[2]:
            _fail("Malformed %s was not rejected cleanly: %s" % [mutation[0], rejected])
            return
    var malformed: Dictionary = valid.duplicate(true)
    malformed["commands"][0]["accepted"] = 1
    if REPLAY.playback(malformed).get("reason", "") != "invalid_outcome":
        _fail("Non-boolean accepted outcome passed validation")
        return
    malformed = valid.duplicate(true)
    malformed["commands"][0]["argument"] = {"type": "cell", "value": [1.5, 2]}
    if REPLAY.playback(malformed).get("reason", "") != "unsupported_argument":
        _fail("Fractional tile coordinates passed validation")
        return
    print("SCALFAGUS_REPLAY_VALIDATION_PASS: 15 malformed schema cases")
    while not sim.finished:
        sim.advance()
    sim.issue_command(0, "stop", rifle)
    if not _verified(sim, "terminal-with-rejected-command"):
        return
    var altered_history: Dictionary = REPLAY.capture(sim)
    altered_history["commands"][-1]["action"] = "changed-terminal-attempt"
    if REPLAY.playback(altered_history).get("reason", "") != "command_history_mismatch":
        _fail("Changed rejected command history was accepted with unchanged state hash")
        return
    var basename: String = "qa-full-replay-%d-%d" % [OS.get_process_id(), Time.get_ticks_usec()]
    var saved: String = REPLAY.save_user(REPLAY.capture(sim), basename)
    if saved == "" or not bool(REPLAY.playback(REPLAY.load_user(basename)).get("ok", false)):
        _fail("Complete match file round-trip diverged")
        return
    DirAccess.remove_absolute(ProjectSettings.globalize_path(saved))
    sim.setup(42, ["human", "bot"])
    if not sim.human_command_history.is_empty() or not _verified(sim, "setup-clears-history"):
        return
    print("SCALFAGUS_REPLAY_LIFECYCLE_PASS")
    quit(0)
