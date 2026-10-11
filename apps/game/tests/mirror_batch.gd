extends SceneTree

# Usage: godot --headless --path apps/game --script res://tests/mirror_batch.gd -- --matches 10 --seed 42
# No LLM/network calls. Each match is an independent accelerated Godot simulation.
const MATCH = preload("res://scripts/mirror_match_state.gd")

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var args: PackedStringArray = OS.get_cmdline_user_args()
    var matches: int = 1
    var base_seed: int = 42
    var output_path: String = ""
    var i: int = 0
    while i < args.size():
        var a: String = args[i]
        if a == "--matches" and i + 1 < args.size():
            i += 1
            matches = int(args[i])
        elif a.begins_with("--matches="):
            matches = int(a.trim_prefix("--matches="))
        elif a == "--seed" and i + 1 < args.size():
            i += 1
            base_seed = int(args[i])
        elif a.begins_with("--seed="):
            base_seed = int(a.trim_prefix("--seed="))
        elif a == "--output" and i + 1 < args.size():
            i += 1
            output_path = args[i]
        elif a.begins_with("--output="):
            output_path = a.trim_prefix("--output=")
        i += 1
    if matches < 1 or matches > 100000:
        push_error("--matches must be between 1 and 100000")
        quit(2)
        return

    var file: FileAccess = null
    if output_path != "":
        file = FileAccess.open(output_path, FileAccess.WRITE)
        if file == null:
            push_error("Cannot write results: " + output_path)
            quit(3)
            return

    var started: int = Time.get_ticks_msec()
    var wins: Array[int] = [0, 0]
    var draws: int = 0
    for n in range(matches):
        var match_state = MATCH.new()
        match_state.setup(base_seed + n, ["bot", "bot"])
        while not match_state.finished:
            match_state.advance()
        var result: Dictionary = match_state.result()
        if not bool(result["matter_conserved"]):
            push_error("Matter conservation failed, seed=%d" % (base_seed + n))
            quit(4)
            return
        if match_state.winner < 0:
            draws += 1
        else:
            wins[match_state.winner] += 1
        var record: String = JSON.stringify(result)
        if file != null:
            file.store_line(record)
        if matches <= 10:
            print("SCALFAGUS_MIRROR_RESULT " + record)
    if file != null:
        file.close()
    var seconds: float = maxf(0.001, float(Time.get_ticks_msec() - started) / 1000.0)
    print("SCALFAGUS_MIRROR_BATCH_PASS " + JSON.stringify({
        "matches": matches, "wins": wins, "draws": draws,
        "seconds": seconds, "matches_per_second": float(matches) / seconds
    }))
    quit(0)
