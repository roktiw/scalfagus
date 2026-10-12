extends RefCounted
class_name MirrorReplaySession

# Drive an existing match renderer with the same deterministic simulation,
# but apply recorded human attempts before each original host tick.
# Unlike batch replay, this never simulates the entire match on GUI startup.
const REPLAY = preload("res://scripts/mirror_replay_archive.gd")

var sim: MirrorMatchState
var commands: Array = []
var next_command: int = 0
var final_tick: int = -1
var expected_hash: String = ""
var finished: bool = false
var verified: bool = false
var error: String = ""

func begin(document: Variant) -> Dictionary:
    var prepared: Dictionary = REPLAY.prepare(document)
    if not bool(prepared.get("ok", false)):
        error = str(prepared.get("reason", "invalid_replay"))
        return {"ok": false, "reason": error}
    sim = prepared["sim"]
    commands = prepared["commands"]
    final_tick = int(prepared["final_tick"])
    expected_hash = str(prepared["final_hash"])
    next_command = 0
    finished = false
    verified = false
    error = ""
    return {"ok": true, "reason": "ready", "total_ticks": final_tick}

func step() -> Dictionary:
    if sim == null:
        return {"ok": false, "reason": "not_initialized"}
    if finished:
        return {"ok": verified, "complete": true, "reason": "replay_verified" if verified else error}
    while next_command < commands.size() and int(commands[next_command]["tick"]) == sim.tick:
        var command: Dictionary = commands[next_command]
        var decoded: Dictionary = REPLAY._argument(command["argument"])
        if not bool(decoded.get("ok", false)):
            error = "unsupported_argument"
            finished = true
            return {"ok": false, "reason": error, "command_index": next_command}
        var accepted: bool = sim.issue_command(
            int(command["slot"]), str(command["action"]),
            int(command["actor_id"]), decoded["value"]
        )
        if accepted != bool(command["accepted"]):
            error = "command_outcome_diverged"
            finished = true
            return {"ok": false, "reason": error, "command_index": next_command}
        next_command += 1
    if sim.tick == final_tick:
        finished = true
        if next_command != commands.size():
            error = "unplayed_commands"
            return {"ok": false, "reason": error}
        verified = sim.replay_hash() == expected_hash
        error = "" if verified else "state_hash_mismatch"
        return {
            "ok": verified, "complete": true,
            "reason": "replay_verified" if verified else error,
            "hash": sim.replay_hash(), "expected_hash": expected_hash,
            "ticks": sim.tick, "commands": next_command
        }
    if sim.finished:
        error = "finished_before_recorded_tick"
        finished = true
        return {"ok": false, "reason": error}
    sim.advance()
    return {"ok": true, "complete": false, "ticks": sim.tick}
