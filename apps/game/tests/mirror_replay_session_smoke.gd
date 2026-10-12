extends SceneTree

# One-player incremental replay must be equivalent to the batch verifier,
# without simulating all future ticks before the first rendered frame.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const REPLAY = preload("res://scripts/mirror_replay_archive.gd")
const SESSION = preload("res://scripts/mirror_replay_session.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_REPLAY_SESSION_FAIL: " + message)
    quit(1)

func _verify() -> void:
    var recorded: MirrorMatchState = MATCH.new()
    recorded.setup(42, ["human", "bot"])
    var worker: int = recorded.units_for(0, "worker")[0]
    if not recorded.issue_command(0, "gather", worker, "nw_solid_1"):
        _fail("Fixture first human gather rejected")
        return
    for i in range(80):
        recorded.advance()
    if not recorded.issue_command(0, "stop", worker):
        _fail("Fixture STOP rejected")
        return
    if recorded.issue_command(0, "train_worker", worker):
        _fail("Worker trained a Worker without a command HQ")
        return
    for i in range(110):
        recorded.advance()
    var original_hash: String = recorded.replay_hash()
    var original_archive: Dictionary = REPLAY.capture(recorded)
    if original_archive["format_version"] != 2 or not original_archive.has("commands_hash"):
        _fail("Session fixture missing Mac-verified replay format 2 integrity")
        return
    var roundtrip: Variant = JSON.parse_string(JSON.stringify(original_archive))
    var session: MirrorReplaySession = SESSION.new()
    var start: Dictionary = session.begin(roundtrip)
    if not bool(start.get("ok", false)):
        _fail("Session rejected genuine JSON replay: " + str(start))
        return
    if session.sim.tick != 0:
        _fail("Session pre-simulated the replay before first rendered tick")
        return
    if session.sim.replay_hash() == original_hash:
        _fail("Unplayed session already has recorded final hash")
        return
    var result: Dictionary = {}
    var steps: int = 0
    while not session.finished and steps <= int(original_archive["final_tick"]) + 1:
        result = session.step()
        steps += 1
        if not bool(result.get("ok", false)):
            _fail("Session diverged: " + str(result))
            return
    if not session.finished or not session.verified:
        _fail("Session never reached verified terminal tick")
        return
    if steps != recorded.tick + 1:
        _fail("Session consumed unexpected number of rendered tick frames")
        return
    if session.sim.replay_hash() != original_hash:
        _fail("Streamed playback does not equal recorded human match")
        return
    if session.next_command != recorded.human_command_history.size():
        _fail("Some human attempts were not reproduced")
        return
    var again: Dictionary = session.step()
    if not bool(again.get("complete", false)) or not bool(again.get("ok", false)):
        _fail("Completed session did not remain completed")
        return
    if not bool(REPLAY.playback(roundtrip).get("ok", false)):
        _fail("Standalone batch verifier differs from streaming session")
        return

    var invalid: Dictionary = original_archive.duplicate(true)
    invalid["map_hash"] = "wrong-map-hash"
    var blocked: MirrorReplaySession = SESSION.new()
    if bool(blocked.begin(invalid).get("ok", true)) or blocked.sim != null:
        _fail("Forged map provenance started an invalid replay")
        return
    # Edits to rejected commands are invisible to the state hash, but
    # MUST be rejected by the new format-2 ordered command checksum.
    var forged_history: Dictionary = original_archive.duplicate(true)
    forged_history["commands"][2]["action"] = "changed-rejected-command"
    var hash_guard: MirrorReplaySession = SESSION.new()
    if hash_guard.begin(forged_history).get("reason", "") != "command_history_mismatch" or hash_guard.sim != null:
        _fail("Interactive replay bypassed rejected-command history integrity")
        return
    var changed: Dictionary = original_archive.duplicate(true)
    changed["commands"][0]["argument"] = {"type": "string", "value": "nw_solid_2"}
    var failed: MirrorReplaySession = SESSION.new()
    if not bool(failed.begin(changed).get("ok", false)):
        _fail("Well-formed but altered replay did not initialize")
        return
    var mismatch: Dictionary = {}
    for i in range(int(changed["final_tick"]) + 2):
        mismatch = failed.step()
        if failed.finished:
            break
    if bool(mismatch.get("ok", false)) or not failed.finished or failed.verified:
        _fail("Altered human target passed verification")
        return

    print("SCALFAGUS_REPLAY_SESSION_PASS")
    quit(0)
