extends RefCounted
class_name MirrorMatchState

# MVP 0.1: authoritative rules for a two-slot MAN mirror match.
# Pure state: no cameras, rendering, input nodes, or wall-clock delays.
const BOARD: int = 64
const MAX_TICKS: int = 5400
const DIRECTIONS: Array[Vector2i] = [
    Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)
]
const COST_WORKER: int = 35
const COST_BARRACKS: int = 100
const COST_RIFLEMAN: int = 50
const HP: Dictionary = {"hq": 1200, "worker": 50, "barracks": 650, "rifleman": 100}

var tick: int = 0
var seed: int = 42
var next_id: int = 1
var finished: bool = false
var winner: int = -1
var finish_reason: String = ""
var controllers: Array[String] = []
var players: Array[Dictionary] = []
var entities: Dictionary = {}
var sources: Dictionary = {}
var terrain: Dictionary = {}
var events: Array[Dictionary] = []
var mined_matter: int = 0
var lost_matter: int = 0
var spent_matter: int = 0
var rejected_commands: int = 0

func setup(match_seed: int = 42, slot_controllers: Array = ["human", "bot"]) -> void:
    seed = match_seed
    tick = 0
    next_id = 1
    finished = false
    winner = -1
    finish_reason = ""
    entities.clear()
    sources.clear()
    terrain.clear()
    events.clear()
    controllers.clear()
    players.clear()
    mined_matter = 0
    lost_matter = 0
    spent_matter = 0
    rejected_commands = 0
    for slot in range(2):
        controllers.append(str(slot_controllers[slot]) if slot < slot_controllers.size() else "bot")
        players.append({"matter": 0, "kills": 0})
    _build_terrain()
    sources["west"] = {"pos": Vector2i(17, 31), "stock": 900}
    sources["east"] = {"pos": Vector2i(46, 33), "stock": 900}
    sources["center_n"] = {"pos": Vector2i(31, 13), "stock": 350}
    sources["center_s"] = {"pos": Vector2i(32, 50), "stock": 350}
    for side in range(2):
        var hx: int = 8 if side == 0 else 55
        _spawn("hq", side, Vector2i(hx, 32))
        for offset in range(3):
            _spawn("worker", side, Vector2i(hx + (2 if side == 0 else -2), 30 + offset * 2))

func _build_terrain() -> void:
    # Fixed, symmetrical, walkable corridors; neutral impassable water/tree cells.
    for y in range(9, 19):
        terrain[Vector2i(29, y)] = "water"
        terrain[Vector2i(34, 63 - y)] = "water"
    for y in range(24, 29):
        terrain[Vector2i(30, y)] = "tree"
        terrain[Vector2i(33, 63 - y)] = "tree"
    for x in [21, 22, 41, 42]:
        terrain[Vector2i(x, 22)] = "tree"
        terrain[Vector2i(63 - x, 41)] = "tree"

func _spawn(kind: String, owner: int, pos: Vector2i) -> int:
    var id: int = next_id
    next_id += 1
    entities[id] = {
        "id": id, "kind": kind, "owner": owner, "pos": pos, "hp": int(HP[kind]),
        "order": "idle", "target_id": -1, "target_pos": pos, "source_id": "",
        "cargo": 0, "work_ticks": 0, "cooldown": 0,
        "train_kind": "", "train_left": 0, "build_pos": Vector2i(-1, -1)
    }
    return id

func sorted_ids() -> Array[int]:
    var result: Array[int] = []
    for key in entities.keys():
        result.append(int(key))
    result.sort()
    return result

func units_for(owner: int, kind: String = "") -> Array[int]:
    var result: Array[int] = []
    for id in sorted_ids():
        var e: Dictionary = entities[id]
        if int(e["owner"]) == owner and (kind == "" or str(e["kind"]) == kind):
            result.append(id)
    return result

func _distance(a: Vector2i, b: Vector2i) -> int:
    return absi(a.x - b.x) + absi(a.y - b.y)

func _in_bounds(p: Vector2i) -> bool:
    return p.x >= 1 and p.y >= 1 and p.x < BOARD - 1 and p.y < BOARD - 1

func _blocked(p: Vector2i) -> bool:
    if not _in_bounds(p) or terrain.has(p):
        return true
    for id in sorted_ids():
        var e: Dictionary = entities[id]
        if str(e["kind"]) in ["hq", "barracks"] and e["pos"] == p:
            return true
    return false

func _can_build(p: Vector2i, owner: int) -> bool:
    if _blocked(p):
        return false
    for id in sorted_ids():
        var e: Dictionary = entities[id]
        if str(e["order"]) == "build" and e["build_pos"] == p:
            return false
    var hqs: Array[int] = units_for(owner, "hq")
    return not hqs.is_empty() and _distance(p, entities[hqs[0]]["pos"]) <= 9

func _line_clear(from_pos: Vector2i, to_pos: Vector2i) -> bool:
    var x: int = from_pos.x
    var y: int = from_pos.y
    var dx: int = absi(to_pos.x - x)
    var dy: int = absi(to_pos.y - y)
    var sx: int = 1 if x < to_pos.x else -1
    var sy: int = 1 if y < to_pos.y else -1
    var error: int = dx - dy
    while x != to_pos.x or y != to_pos.y:
        var doubled: int = 2 * error
        if doubled > -dy:
            error -= dy
            x += sx
        if doubled < dx:
            error += dx
            y += sy
        if terrain.get(Vector2i(x, y), "") == "tree":
            return false
    return true

func can_see(side: int, target: Vector2i) -> bool:
    for id in sorted_ids():
        var e: Dictionary = entities[id]
        if int(e["owner"]) != side:
            continue
        var vision: int = 9 if str(e["kind"]) == "hq" else 8
        if _distance(e["pos"], target) <= vision and _line_clear(e["pos"], target):
            return true
    return false

func _reject() -> bool:
    rejected_commands += 1
    return false

func issue_command(side: int, action: String, actor_id: int, arg: Variant = null) -> bool:
    if finished or side < 0 or side > 1 or not entities.has(actor_id):
        return _reject()
    var e: Dictionary = entities[actor_id]
    if int(e["owner"]) != side:
        return _reject()
    var kind: String = str(e["kind"])
    match action:
        "stop":
            if kind not in ["worker", "rifleman"]:
                return _reject()
            e["order"] = "idle"
            e["target_id"] = -1
        "move":
            if kind not in ["worker", "rifleman"] or not (arg is Vector2i) or not _in_bounds(arg):
                return _reject()
            e["order"] = "move"
            e["target_pos"] = arg
            e["target_id"] = -1
        "gather":
            if kind != "worker" or not (arg is String) or not sources.has(arg):
                return _reject()
            if int(sources[arg]["stock"]) <= 0:
                return _reject()
            e["order"] = "gather"
            e["source_id"] = arg
            e["work_ticks"] = 0
        "build_barracks":
            if kind != "worker" or not (arg is Vector2i):
                return _reject()
            if int(players[side]["matter"]) < COST_BARRACKS or not _can_build(arg, side):
                return _reject()
            players[side]["matter"] = int(players[side]["matter"]) - COST_BARRACKS
            spent_matter += COST_BARRACKS
            e["order"] = "build"
            e["build_pos"] = arg
            e["work_ticks"] = 45
        "train_worker", "train_rifleman":
            var training_worker: bool = action == "train_worker"
            var price: int = COST_WORKER if training_worker else COST_RIFLEMAN
            if kind != ("hq" if training_worker else "barracks"):
                return _reject()
            if str(e["train_kind"]) != "" or int(players[side]["matter"]) < price:
                return _reject()
            players[side]["matter"] = int(players[side]["matter"]) - price
            spent_matter += price
            e["train_kind"] = "worker" if training_worker else "rifleman"
            e["train_left"] = 45 if training_worker else 65
        "attack":
            if kind != "rifleman" or not (arg is int) or not entities.has(arg):
                return _reject()
            var enemy: Dictionary = entities[arg]
            if int(enemy["owner"]) == side or not can_see(side, enemy["pos"]):
                return _reject()
            e["order"] = "attack"
            e["target_id"] = arg
        _:
            return _reject()
    events.append({"tick": tick, "owner": side, "actor": actor_id, "action": action})
    return true

func _next_step(start: Vector2i, goal: Vector2i, adjacent_ok: bool) -> Vector2i:
    if _distance(start, goal) <= (1 if adjacent_ok else 0):
        return start
    var queue: Array[Vector2i] = [start]
    var came: Dictionary = {}
    came[start] = start
    var index: int = 0
    var finish: Vector2i = start
    var found: bool = false
    while index < queue.size():
        var cur: Vector2i = queue[index]
        index += 1
        if _distance(cur, goal) <= (1 if adjacent_ok else 0):
            finish = cur
            found = true
            break
        for d in DIRECTIONS:
            var nxt: Vector2i = cur + d
            if came.has(nxt) or _blocked(nxt):
                continue
            came[nxt] = cur
            queue.append(nxt)
    if not found:
        return start
    while came[finish] != start:
        finish = came[finish]
    return finish

func _walk(e: Dictionary, dest: Vector2i, adjacent_ok: bool = true) -> void:
    if tick % 3 != 0:
        return
    var pos: Vector2i = e["pos"]
    e["pos"] = _next_step(pos, dest, adjacent_ok)

func _nearest_source(pos: Vector2i) -> String:
    var choice: String = ""
    var best: int = 1000000
    var ids: Array = sources.keys()
    ids.sort()
    for source_id in ids:
        var source: Dictionary = sources[source_id]
        if int(source["stock"]) > 0 and _distance(pos, source["pos"]) < best:
            best = _distance(pos, source["pos"])
            choice = str(source_id)
    return choice

func _worker_tick(e: Dictionary) -> void:
    var order: String = str(e["order"])
    var side: int = int(e["owner"])
    if order == "move":
        _walk(e, e["target_pos"], false)
        if e["pos"] == e["target_pos"]:
            e["order"] = "idle"
    elif order == "gather":
        if int(e["cargo"]) > 0:
            var hqs: Array[int] = units_for(side, "hq")
            if hqs.is_empty():
                e["order"] = "idle"
                return
            var hq: Dictionary = entities[hqs[0]]
            if _distance(e["pos"], hq["pos"]) <= 1:
                players[side]["matter"] = int(players[side]["matter"]) + int(e["cargo"])
                e["cargo"] = 0
            else:
                _walk(e, hq["pos"])
        else:
            var sid: String = str(e["source_id"])
            if not sources.has(sid) or int(sources[sid]["stock"]) <= 0:
                sid = _nearest_source(e["pos"])
                e["source_id"] = sid
            if sid == "":
                e["order"] = "idle"
                return
            var src: Dictionary = sources[sid]
            if _distance(e["pos"], src["pos"]) <= 1:
                e["work_ticks"] = int(e["work_ticks"]) + 1
                if int(e["work_ticks"]) >= 6:
                    var picked: int = mini(10, int(src["stock"]))
                    src["stock"] = int(src["stock"]) - picked
                    e["cargo"] = picked
                    mined_matter += picked
                    e["work_ticks"] = 0
            else:
                _walk(e, src["pos"])
    elif order == "build":
        var site: Vector2i = e["build_pos"]
        if _distance(e["pos"], site) > 1:
            _walk(e, site)
        else:
            e["work_ticks"] = int(e["work_ticks"]) - 1
            if int(e["work_ticks"]) <= 0:
                if _can_build(site, side):
                    _spawn("barracks", side, site)
                else:
                    # Site became invalid; spent resources remain accounted as loss.
                    events.append({"tick": tick, "owner": side, "action": "build_site_lost"})
                e["order"] = "idle"

func _rifleman_tick(e: Dictionary) -> void:
    if int(e["cooldown"]) > 0:
        e["cooldown"] = int(e["cooldown"]) - 1
    var order: String = str(e["order"])
    if order == "move":
        _walk(e, e["target_pos"], false)
        if e["pos"] == e["target_pos"]:
            e["order"] = "idle"
    elif order == "attack":
        var enemy_id: int = int(e["target_id"])
        if not entities.has(enemy_id):
            e["order"] = "idle"
            return
        var enemy: Dictionary = entities[enemy_id]
        if not can_see(int(e["owner"]), enemy["pos"]):
            e["order"] = "idle"
            return
        if _distance(e["pos"], enemy["pos"]) <= 6 and _line_clear(e["pos"], enemy["pos"]):
            if int(e["cooldown"]) == 0:
                _damage(enemy_id, 8, int(e["owner"]))
                e["cooldown"] = 10
        else:
            _walk(e, enemy["pos"])

func _damage(entity_id: int, points: int, attacker: int) -> void:
    if not entities.has(entity_id):
        return
    var e: Dictionary = entities[entity_id]
    e["hp"] = int(e["hp"]) - points
    if int(e["hp"]) > 0:
        return
    if str(e["kind"]) == "worker":
        lost_matter += int(e["cargo"])
    players[attacker]["kills"] = int(players[attacker]["kills"]) + 1
    events.append({"tick": tick, "owner": attacker, "action": "kill", "victim": entity_id})
    entities.erase(entity_id)

func _train_tick(e: Dictionary) -> void:
    if str(e["train_kind"]) == "":
        return
    e["train_left"] = int(e["train_left"]) - 1
    if int(e["train_left"]) > 0:
        return
    for d in DIRECTIONS:
        var candidate: Vector2i = e["pos"] + d
        if not _blocked(candidate):
            _spawn(str(e["train_kind"]), int(e["owner"]), candidate)
            e["train_kind"] = ""
            e["train_left"] = 0
            return
    # Training remains ready until an adjacent spawn tile is available.
    e["train_left"] = 1

func _bot_tick(side: int) -> void:
    var workers: Array[int] = units_for(side, "worker")
    var hqs: Array[int] = units_for(side, "hq")
    if workers.is_empty() or hqs.is_empty():
        return
    var barracks: Array[int] = units_for(side, "barracks")
    var building: bool = false
    for wid in workers:
        if str(entities[wid]["order"]) == "build":
            building = true
    if barracks.is_empty() and not building and int(players[side]["matter"]) >= COST_BARRACKS:
        var candidate: Vector2i = Vector2i(13, 36) if side == 0 else Vector2i(50, 27)
        issue_command(side, "build_barracks", workers[0], candidate)
    for wid in workers:
        var w: Dictionary = entities[wid]
        if str(w["order"]) == "idle":
            var sid: String = _nearest_source(w["pos"])
            if sid != "":
                issue_command(side, "gather", wid, sid)
    if not barracks.is_empty():
        var b: Dictionary = entities[barracks[0]]
        if str(b["train_kind"]) == "" and int(players[side]["matter"]) >= COST_RIFLEMAN and units_for(side, "rifleman").size() < 9:
            issue_command(side, "train_rifleman", barracks[0])
    var riflemen: Array[int] = units_for(side, "rifleman")
    for rid in riflemen:
        var soldier: Dictionary = entities[rid]
        if str(soldier["order"]) == "attack":
            continue
        var closest: int = -1
        var distance: int = 1000000
        for enemy_id in sorted_ids():
            var other: Dictionary = entities[enemy_id]
            if int(other["owner"]) != side and can_see(side, other["pos"]):
                var delta: int = _distance(soldier["pos"], other["pos"])
                if delta < distance:
                    distance = delta
                    closest = enemy_id
        if closest != -1:
            issue_command(side, "attack", rid, closest)
        elif riflemen.size() >= 3:
            # The opponent starting zone is common map knowledge, NOT enemy entity omniscience.
            issue_command(side, "move", rid, Vector2i(54, 32) if side == 0 else Vector2i(9, 32))

func _check_end() -> void:
    var alive: Array[bool] = [false, false]
    for id in sorted_ids():
        var e: Dictionary = entities[id]
        if str(e["kind"]) in ["hq", "barracks"]:
            alive[int(e["owner"])] = true
    if not alive[0] or not alive[1]:
        finished = true
        winner = 0 if alive[0] and not alive[1] else (1 if alive[1] and not alive[0] else -1)
        finish_reason = "buildings_eliminated" if winner != -1 else "mutual_elimination"
    elif tick >= MAX_TICKS:
        finished = true
        winner = -1
        finish_reason = "time_limit_draw"

func advance() -> void:
    if finished:
        return
    tick += 1
    if tick % 12 == 1:
        for side in range(2):
            if controllers[side] == "bot":
                _bot_tick(side)
    for id in sorted_ids():
        if not entities.has(id):
            continue
        var e: Dictionary = entities[id]
        match str(e["kind"]):
            "worker":
                _worker_tick(e)
            "rifleman":
                _rifleman_tick(e)
            "hq", "barracks":
                _train_tick(e)
    _check_end()

func matter_is_conserved() -> bool:
    var carried: int = 0
    for id in sorted_ids():
        carried += int(entities[id]["cargo"])
    var stored: int = int(players[0]["matter"]) + int(players[1]["matter"])
    return mined_matter == carried + stored + spent_matter + lost_matter

func replay_hash() -> String:
    var material: String = "%d|%d|%d|%d|%d|" % [seed, tick, winner, mined_matter, spent_matter]
    for side in range(2):
        material += "%d,%d;" % [int(players[side]["matter"]), int(players[side]["kills"])]
    for id in sorted_ids():
        var e: Dictionary = entities[id]
        var p: Vector2i = e["pos"]
        material += "%d,%s,%d,%d,%d,%d,%d,%s;" % [id, str(e["kind"]), int(e["owner"]), p.x, p.y, int(e["hp"]), int(e["cargo"]), str(e["order"])]
    var source_ids: Array = sources.keys()
    source_ids.sort()
    for sid in source_ids:
        material += "%s:%d;" % [str(sid), int(sources[sid]["stock"])]
    return material.sha256_text()

func result() -> Dictionary:
    return {
        "rules": "mvp0-man-mirror-v1",
        "seed": seed, "ticks": tick, "winner": winner, "reason": finish_reason,
        "finished": finished, "controllers": controllers.duplicate(),
        "resources_mined": mined_matter, "resources_spent": spent_matter,
        "lost_cargo": lost_matter, "rejected_commands": rejected_commands,
        "matter_conserved": matter_is_conserved(), "hash": replay_hash()
    }
