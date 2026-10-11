extends RefCounted
class_name MirrorMatchState

const NAV_SCRIPT = preload("res://scripts/mirror_navigation_port.gd")

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
var bot_attack_thresholds: Array[int] = []
var entities: Dictionary = {}
var sources: Dictionary = {}
var terrain: Dictionary = {}
var navigation: MirrorNavigationPort
var building_cells: Dictionary = {}
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
    building_cells.clear()
    events.clear()
    controllers.clear()
    players.clear()
    bot_attack_thresholds.clear()
    mined_matter = 0
    lost_matter = 0
    spent_matter = 0
    rejected_commands = 0
    for slot in range(2):
        controllers.append(str(slot_controllers[slot]) if slot < slot_controllers.size() else "bot")
        players.append({"matter": 0, "kills": 0})
        # Reproducible strategy variation for headless seed sweeps.
        bot_attack_thresholds.append(2 + posmod(match_seed / (1 if slot == 0 else 3) + slot * 17, 3))
    _build_terrain()
    navigation = NAV_SCRIPT.new()
    navigation.configure(BOARD, terrain)
    sources["west"] = {"pos": Vector2i(17, 31), "stock": 900}
    sources["east"] = {"pos": Vector2i(46, 32), "stock": 900}
    sources["center_n"] = {"pos": Vector2i(31, 13), "stock": 350}
    sources["center_s"] = {"pos": Vector2i(32, 50), "stock": 350}
    for side in range(2):
        var hx: int = 8 if side == 0 else 55
        _spawn("hq", side, Vector2i(hx, 32 if side == 0 else 31))
        for offset in range(3):
            var wy: int = 30 + offset * 2
            _spawn("worker", side, Vector2i(hx + (2 if side == 0 else -2), wy if side == 0 else 63 - wy))

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
        "train_kind": "", "train_left": 0, "build_pos": Vector2i(-1, -1),
        "route": [], "route_target": Vector2i(-1, -1), "route_adjacent": false,
        "route_revision": -1
    }
    if kind in ["hq", "barracks"]:
        building_cells[pos] = id
        navigation.set_blocked(pos, true)
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
    return not _in_bounds(p) or navigation.is_blocked(p)

# Keep map mutation atomic: never edit terrain without updating the Godot A*.
# Authored maps are intended to be immutable in a match; tests can model changes.
func set_terrain_cell(p: Vector2i, kind: String) -> void:
    if not _in_bounds(p) or building_cells.has(p):
        return
    if kind == "":
        terrain.erase(p)
    else:
        terrain[p] = kind
    navigation.set_blocked(p, kind != "")

func _mobile_at(p: Vector2i, except_id: int = -1) -> bool:
    for id in sorted_ids():
        if id == except_id:
            continue
        var e: Dictionary = entities[id]
        if str(e["kind"]) in ["worker", "rifleman"] and e["pos"] == p:
            return true
    return false

func _source_at(p: Vector2i) -> bool:
    for sid in sources.keys():
        if sources[sid]["pos"] == p:
            return true
    return false

func _can_build(p: Vector2i, owner: int, ignore_builder_id: int = -1) -> bool:
    if _blocked(p) or _mobile_at(p, ignore_builder_id) or _source_at(p):
        return false
    for id in sorted_ids():
        var e: Dictionary = entities[id]
        if id != ignore_builder_id and str(e["order"]) == "build" and e["build_pos"] == p:
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
        var ray_cell := Vector2i(x, y)
        if terrain.get(ray_cell, "") == "tree":
            return false
        # The target itself can be a building; buildings between actors block LOS.
        if ray_cell != to_pos and building_cells.has(ray_cell):
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
            if kind not in ["worker", "rifleman"] or not (arg is Vector2i) or _blocked(arg):
                return _reject()
            if e["pos"] != arg and _find_route(e["pos"], arg, false).is_empty():
                return _reject()
            e["order"] = "move"
            e["target_pos"] = arg
            e["target_id"] = -1
        "gather":
            if kind != "worker" or not (arg is String) or not sources.has(arg):
                return _reject()
            if int(sources[arg]["stock"]) <= 0:
                return _reject()
            if _distance(e["pos"], sources[arg]["pos"]) > 1 and _find_route(e["pos"], sources[arg]["pos"], true).is_empty():
                return _reject()
            e["order"] = "gather"
            e["source_id"] = arg
            e["work_ticks"] = 0
        "build_barracks":
            if kind != "worker" or not (arg is Vector2i):
                return _reject()
            if int(players[side]["matter"]) < COST_BARRACKS or not _can_build(arg, side):
                return _reject()
            if _distance(e["pos"], arg) > 1 and _find_route(e["pos"], arg, true).is_empty():
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

func _find_route(start: Vector2i, goal: Vector2i, adjacent_ok: bool) -> Array[Vector2i]:
    return navigation.route(start, goal, adjacent_ok)

func _walk(e: Dictionary, dest: Vector2i, adjacent_ok: bool = true) -> void:
    if tick % 3 != 0:
        return
    var route: Array = e["route"]
    if e["route_target"] != dest or bool(e["route_adjacent"]) != adjacent_ok \
            or int(e["route_revision"]) != navigation.revision or route.is_empty():
        route = _find_route(e["pos"], dest, adjacent_ok)
        e["route"] = route
        e["route_target"] = dest
        e["route_adjacent"] = adjacent_ok
        e["route_revision"] = navigation.revision
    if route.is_empty():
        return
    var step: Vector2i = route[0]
    if _blocked(step):
        route = _find_route(e["pos"], dest, adjacent_ok)
        e["route"] = route
        if route.is_empty():
            return
        step = route[0]
    e["pos"] = step
    route.remove_at(0)

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
                if _can_build(site, side, int(e["id"])):
                    _spawn("barracks", side, site)
                    e["order"] = "idle"
                elif _mobile_at(site, int(e["id"])):
                    # Temporary actor occupancy pauses, rather than losing paid progress.
                    e["work_ticks"] = 1
                else:
                    # Permanently invalid worksite; spent resources stay debited.
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
    if str(e["kind"]) == "hq":
        # The sole MVP0 treasury belongs to a physical HQ, not an immortal wallet.
        lost_matter += int(players[int(e["owner"])]["matter"])
        players[int(e["owner"])]["matter"] = 0
    players[attacker]["kills"] = int(players[attacker]["kills"]) + 1
    events.append({"tick": tick, "owner": attacker, "action": "kill", "victim": entity_id})
    if str(e["kind"]) in ["hq", "barracks"]:
        building_cells.erase(e["pos"])
        navigation.set_blocked(e["pos"], terrain.has(e["pos"]))
    entities.erase(entity_id)

func _train_tick(e: Dictionary) -> void:
    if str(e["train_kind"]) == "":
        return
    e["train_left"] = int(e["train_left"]) - 1
    if int(e["train_left"]) > 0:
        return
    for d in DIRECTIONS:
        var candidate: Vector2i = e["pos"] + d
        if not _blocked(candidate) and not _mobile_at(candidate) and not _source_at(candidate):
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
        elif riflemen.size() >= bot_attack_thresholds[side]:
            # Opponent spawn zone is common map knowledge, not live hidden-unit coordinates.
            var scouting_goal: Vector2i = Vector2i(54, 31) if side == 0 else Vector2i(9, 32)
            if str(soldier["order"]) != "move" or soldier["target_pos"] != scouting_goal:
                issue_command(side, "move", rid, scouting_goal)

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
    # Stable state hash includes orders, outstanding work, queues, and cooldowns.
    # It is a pinned-runtime regression tool, not a cross-platform lockstep promise.
    var material: String = "mvp0-man-mirror-v2|"
    for field in [
        seed, tick, winner, finished, finish_reason, next_id,
        mined_matter, spent_matter, lost_matter, rejected_commands
    ]:
        material += str(field) + "|"
    for side in range(2):
        for field in [
            side, controllers[side], bot_attack_thresholds[side],
            players[side]["matter"], players[side]["kills"]
        ]:
            material += str(field) + "|"
    for id in sorted_ids():
        var e: Dictionary = entities[id]
        var p: Vector2i = e["pos"]
        var target: Vector2i = e["target_pos"]
        var site: Vector2i = e["build_pos"]
        var route_target: Vector2i = e["route_target"]
        for field in [
            id, e["kind"], e["owner"], p.x, p.y, e["hp"], e["order"],
            e["target_id"], target.x, target.y, e["source_id"], e["cargo"],
            e["work_ticks"], e["cooldown"], e["train_kind"], e["train_left"],
            site.x, site.y, route_target.x, route_target.y, e["route_adjacent"]
        ]:
            material += str(field) + "|"
        for step in e["route"]:
            material += "%d,%d|" % [step.x, step.y]
        material += ";"
    var source_ids: Array = sources.keys()
    source_ids.sort()
    for sid in source_ids:
        var source: Dictionary = sources[sid]
        var p: Vector2i = source["pos"]
        material += "source=%s,%d,%d,%d;" % [str(sid), p.x, p.y, int(source["stock"])]
    # Map cells are hashed in a defined order, independent of Dictionary insertion.
    for y in range(BOARD):
        for x in range(BOARD):
            var p := Vector2i(x, y)
            if terrain.has(p):
                material += "tile=%d,%d,%s;" % [x, y, str(terrain[p])]
    return material.sha256_text()

func result() -> Dictionary:
    return {
        "rules": "mvp0-man-mirror-v1",
        "seed": seed, "ticks": tick, "winner": winner, "reason": finish_reason,
        "finished": finished, "controllers": controllers.duplicate(),
        "bot_attack_thresholds": bot_attack_thresholds.duplicate(),
        "resources_mined": mined_matter, "resources_spent": spent_matter,
        "lost_matter": lost_matter, "lost_cargo_legacy": lost_matter,
        "rejected_commands": rejected_commands,
        "matter_conserved": matter_is_conserved(), "hash": replay_hash()
    }
