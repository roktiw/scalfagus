extends SceneTree

# Local one-human replay regression. Captures BOTH valid and invalid human
# commands, serializes to JSON, replays the same bot seed and verifies hash.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const REPLAY = preload("res://scripts/mirror_replay_archive.gd")

func _initialize() -> void:
    call_deferred("_run")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_HUMAN_REPLAY_FAIL: " + message)
    quit(1)

func _run() -> void:
    var sim: MirrorMatchState = MATCH.new()
    sim.setup(42, ["human", "bot"])
    if sim.finished:
        _fail("Authored Verdant failed initial spawn")
        return
    var worker0: int = sim.units_for(0, "worker")[0]
    var worker1: int = sim.units_for(0, "worker")[1]
    var home_source: String = "nw_solid_1"
    # Multiple human intents in the same tick, including an incorrect attack:
    # the rejected_commands hash field must reproduce too.
    if not sim.issue_command(0, "gather", worker0, home_source):
        _fail("Legal starting resource path rejected")
        return
    if not sim.issue_command(0, "move", worker1, sim.entities[worker1]["pos"]):
        _fail("Legal same-cell move was rejected")
        return
    if sim.issue_command(0, "attack", worker0, 12345):
        _fail("Worker illegally ordered to attack")
        return
    for i in range(55):
        sim.advance()
    if not sim.issue_command(0, "stop", worker1):
        _fail("Valid human STOP was rejected")
        return
    for i in range(65):
        sim.advance()
    if not sim.issue_command(0, "gather", worker1, "nw_solid_2"):
        _fail("Second worker could not receive an authored gather order")
        return
    for i in range(155):
        sim.advance()
    if not sim.matter_is_conserved():
        _fail("Baseline human-bot Matter conservation failed")
        return

    var archive: Dictionary = REPLAY.capture(sim)
    var attempts: Array = archive["commands"]
    if attempts.size() != 5 or bool(attempts[2]["accepted"]):
        _fail("Human attempts missing rejected order or in-tick order")
        return
    if archive["controllers"] != ["human", "bot"]:
        _fail("Replay did not preserve human-bot controllers")
        return
    if attempts[0]["argument"]["type"] != "string" or attempts[1]["argument"]["type"] != "cell":
        _fail("Replay lost target argument types")
        return
    if int(attempts[0]["tick"]) != 0 or int(attempts[1]["tick"]) != 0 or int(attempts[2]["tick"]) != 0:
        _fail("Replay lost multi-command ordering within a tick")
        return

    # Godot's JSON parser and file round-trip may normalize JSON numbers.
    var json: String = JSON.stringify(archive, "  ")
    var decoded: Variant = JSON.parse_string(json)
    if not (decoded is Dictionary):
        _fail("Replay did not encode to a pure JSON document")
        return
    var verified: Dictionary = REPLAY.playback(decoded)
    if not bool(verified.get("ok", false)):
        _fail("Legitimate round-trip replay diverged: " + str(verified))
        return
    if str(verified["hash"]) != sim.replay_hash() or int(verified["ticks"]) != sim.tick:
        _fail("Human-bot playback produced a different deterministic hash")
        return

    var name: String = "qa-mirror-human-42"
    var destination: String = REPLAY.save_user(archive, name)
    if destination.is_empty():
        _fail("Replay could not be written to local user://replays")
        return
    var loaded: Dictionary = REPLAY.load_user(name)
    if loaded.is_empty() or not bool(REPLAY.playback(loaded).get("ok", false)):
        _fail("Saved replay file did not match original human-bot game")
        return
    var outside: String = REPLAY.save_user(archive, "../not_allowed")
    if not outside.is_empty() or not REPLAY.load_user("../not_allowed").is_empty():
        _fail("Replay filename traversal was accepted")
        return
    DirAccess.remove_absolute(ProjectSettings.globalize_path(destination))

    var tampered: Dictionary = archive.duplicate(true)
    tampered["map_hash"] = "not-the-authored-verdant-map"
    if REPLAY.playback(tampered).get("reason", "") != "map_mismatch":
        _fail("Map provenance check did not fail closed")
        return

    tampered = archive.duplicate(true)
    tampered["rules"] = "invented-rules"
    if REPLAY.playback(tampered).get("reason", "") != "rules_mismatch":
        _fail("Rules version check did not fail closed")
        return

    tampered = archive.duplicate(true)
    tampered["commands"][1]["accepted"] = false
    if REPLAY.playback(tampered).get("reason", "") != "command_outcome_diverged":
        _fail("Forged success/failure outcome was silently accepted")
        return

    tampered = archive.duplicate(true)
    tampered["commands"][1]["argument"] = {"type": "cell", "value": [5, 16]}
    if bool(REPLAY.playback(tampered).get("ok", false)):
        _fail("Tampered human move destination returned a valid final hash")
        return

    tampered = archive.duplicate(true)
    tampered["commands"][4]["tick"] = 1
    if REPLAY.playback(tampered).get("reason", "") != "non_monotonic_commands":
        _fail("Reordered command ticks were not rejected")
        return

    tampered = archive.duplicate(true)
    tampered["commands"][0]["slot"] = 1
    if REPLAY.playback(tampered).get("reason", "") != "unauthorized_slot":
        _fail("Human replay allowed an unauthorized bot-owned slot")
        return

    tampered = archive.duplicate(true)
    tampered["commands"][1]["argument"] = {"type": "unsupported", "value": null}
    if REPLAY.playback(tampered).get("reason", "") != "unsupported_argument":
        _fail("Arbitrary unsupported Variant was accepted in replay")
        return

    tampered = archive.duplicate(true)
    tampered["commands"].remove_at(2)
    if bool(REPLAY.playback(tampered).get("ok", false)):
        _fail("Omitting a rejected attempt did not alter final replay hash")
        return

    # Exporting multiple times must not consume the replay history nor add
    # an input tick. Bot attempts are regenerated, never double-applied.
    if archive["commands"] != REPLAY.capture(sim)["commands"]:
        _fail("Replay capture mutated command history")
        return
    print("SCALFAGUS_HUMAN_REPLAY_PASS")
    quit(0)
