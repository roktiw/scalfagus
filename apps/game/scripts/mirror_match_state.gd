extends RefCounted
class_name MirrorMatchState

const NAV_SCRIPT = preload("res://scripts/mirror_navigation_port.gd")
const MAP_SCRIPT = preload("res://scripts/mirror_map_port.gd")
const TIMING = preload("res://scripts/mirror_timing.gd")
const GEOM = preload("res://scripts/mirror_geometry.gd")

# MVP 0.1: authoritative rules for a two-slot MAN mirror match.
# Pure state: no cameras, rendering, input nodes, or wall-clock delays.
const BOARD: int = 64
const MAX_TICKS: int = TIMING.MATCH_LIMIT_TICKS
const DIRECTIONS: Array[Vector2i] = [
    Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)
]
const COST_WORKER: int = 35
const COST_BARRACKS: int = 100
const COST_RIFLEMAN: int = 50
const HP: Dictionary = {"hq": 1200, "worker": 50, "barracks": 650, "rifleman": 100}

var map_id: String = "verdant_divide"
var map_hash: String = ""
var map_source_sha: String = ""
var tile_meters: float = 2.0

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
# All human attempts (including rejected commands) are captured for exact
# replay, without exposing this diagnostic history in the match-state hash.
var human_command_history: Array[Dictionary] = []
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
    human_command_history.clear()
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
    # The compiled JSON is a checked-in build artifact of the canonical
    # owner-authored YAML. Godot's JSON parser is native; no runtime YAML lib.
    var authored: Dictionary = MAP_SCRIPT.load_verdant()
    if authored.is_empty():
        finished = true
        finish_reason = "invalid_authored_map"
        push_error("SCALFAGUS_MAP_ERROR: refused to start an incomplete map")
        return
    map_id = str(authored["map_id"])
    map_hash = str(authored["map_hash"])
    map_source_sha = str(authored["source_git_blob_sha"])
    tile_meters = float(authored["tile_meters"])
    terrain = authored["terrain"]
    sources = authored["sources"]
    navigation = NAV_SCRIPT.new()
    navigation.configure(BOARD, terrain)
    var starts: Array[Dictionary] = authored["starts"]
    for side in range(2):
        var start: Dictionary = starts[side]
        _spawn("hq", side, start["hq"])
        for cell in start["workers"]:
            _spawn("worker", side, cell)

func _spawn(kind: String, owner: int, pos: Vector2i) -> int:
    var id: int = next_id
    next_id += 1
    entities[id] = {
        "id": id, "kind": kind, "owner": owner, "pos": pos, "hp": int(HP[kind]),
        "order": "idle", "target_id": -1, "target_pos": pos, "source_id": "",
        "cargo": 0, "work_ticks": 0, "cooldown": 0,
        "gather_phase": "mine", "move_progress": 0,
        "train_kind": "", "train_left": 0, "build_pos": Vector2i(-1, -1),
        "route": [], "route_target": Vector2i(-1, -1), "route_adjacent": false,
        "route_revision": -1
    }
    if GEOM.is_building(kind):
        for cell in GEOM.occupied_cells(pos):
            assert(_in_bounds(cell) and not terrain.has(cell) and not building_cells.has(cell))
            building_cells[cell] = id
            navigation.set_blocked(cell, true)
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

func _footprint_distance(pos: Vector2i, center: Vector2i) -> int:
    return GEOM.distance_to_building(pos, center)

func _distance_to_entity(pos: Vector2i, entity: Dictionary) -> int:
    if GEOM.is_building(str(entity["kind"])):
        return _footprint_distance(pos, entity["pos"])
    return _distance(pos, entity["pos"])

func _reserved_site_at(cell: Vector2i, excluding: int = -1) -> bool:
    for id in sorted_ids():
        if id == excluding:
            continue
        var e: Dictionary = entities[id]
        if str(e["order"]) == "build" and GEOM.occupied_cells(e["build_pos"]).has(cell):
            return true
    return false

func _route_to_building_ring(start: Vector2i, center: Vector2i) -> Array[Vector2i]:
    # Candidate endpoints only. Every actual route is searched by Godot A*.
    var best: Array[Vector2i] = []
    var perimeter: Array[Vector2i] = GEOM.perimeter_cells(center)
    if perimeter.has(start):
        return best
    for cell in perimeter:
        if _blocked(cell):
            continue
        var path: Array[Vector2i] = navigation.route(start, cell, false)
        if start != cell and path.is_empty():
            continue
        if best.is_empty() or path.size() < best.size():
            best = path
    return best

func _can_hit(shooter: Vector2i, target: Dictionary) -> bool:
    var cells: Array[Vector2i] = []
    if GEOM.is_building(str(target["kind"])):
        cells = GEOM.occupied_cells(target["pos"])
    else:
        cells.append(target["pos"])
    var range_sq: float = GEOM.RIFLEMAN_RANGE_METERS * GEOM.RIFLEMAN_RANGE_METERS
    for cell in cells:
        if float(GEOM.distance_sq_cells(shooter, cell)) * tile_meters * tile_meters <= range_sq:
            if _line_clear(shooter, cell):
                return true
    return false

func _footprint_has_mobile(center: Vector2i, ignored_id: int = -1) -> bool:
    for cell in GEOM.occupied_cells(center):
        if _mobile_at(cell, ignored_id):
            return true
    return false

func _source_at(p: Vector2i) -> bool:
    for sid in sources.keys():
        if sources[sid]["pos"] == p:
            return true
    return false

func _can_build(p: Vector2i, owner: int, ignore_builder_id: int = -1) -> bool:
    for cell in GEOM.occupied_cells(p):
        if _blocked(cell) or _mobile_at(cell, ignore_builder_id) or _source_at(cell):
            return false
        if _reserved_site_at(cell, ignore_builder_id):
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
            # A building may see *outward* through its own footprint; a
            # different completed building blocks the beam.
            if not building_cells.has(from_pos) or building_cells[ray_cell] != building_cells[from_pos]:
                return false
    return true

func can_see(side: int, target: Vector2i) -> bool:
    var candidate_cells: Array[Vector2i] = [target]
    if building_cells.has(target):
        var building_id: int = int(building_cells[target])
        if entities.has(building_id):
            candidate_cells = GEOM.occupied_cells(entities[building_id]["pos"])
    for id in sorted_ids():
        var e: Dictionary = entities[id]
        if int(e["owner"]) != side:
            continue
        var vision: int = 9 if str(e["kind"]) == "hq" else 8
        for cell in candidate_cells:
            if _distance(e["pos"], cell) <= vision and _line_clear(e["pos"], cell):
                return true
    return false

func _reject() -> bool:
    rejected_commands += 1
    return false

static func _replay_argument(arg: Variant) -> Dictionary:
    # Only JSON-safe primitive command arguments can go into an archive.
    # Explicit tags retain int-vs-float and distinguish no target from
    # coordinates; arbitrary Objects are never serialized as live objects.
    if arg == null:
        return {"type": "nil", "value": null}
    if arg is Vector2i:
        return {"type": "cell", "value": [arg.x, arg.y]}
    if arg is bool:
        return {"type": "bool", "value": arg}
    if arg is int:
        return {"type": "int", "value": arg}
    if arg is float:
        return {"type": "float", "value": arg}
    if arg is String:
        return {"type": "string", "value": arg}
    return {"type": "unsupported", "value": null}

func _clear_build_fields(e: Dictionary) -> void:
    e["build_pos"] = Vector2i(-1, -1)
    e["work_ticks"] = 0
    e["route"] = []
    e["route_target"] = Vector2i(-1, -1)
    e["route_adjacent"] = false
    e["route_revision"] = -1

func _abandon_build(e: Dictionary, reason: String) -> void:
    if str(e["kind"]) != "worker" or str(e["order"]) != "build":
        return
    var old_site: Vector2i = e["build_pos"]
    var ticks_left: int = maxi(0, int(e["work_ticks"]))
    var side: int = int(e["owner"])
    var actor: int = int(e["id"])
    # MVP0 spends construction Matter at order acceptance. Never refund or
    # debit it twice on cancellation: the future MAN salvage rules are
    # explicitly outside this simplified MAN mirror slice.
    _clear_build_fields(e)
    e["order"] = "idle"
    events.append({
        "tick": tick, "owner": side, "actor": actor,
        "action": "build_abandoned", "reason": reason,
        "site": _replay_argument(old_site), "remaining_ticks": ticks_left
    })

func issue_command(side: int, action: String, actor_id: int, arg: Variant = null) -> bool:
    var applied: bool = _execute_command(side, action, actor_id, arg)
    # Bots are replayed from their deterministic policy using the same
    # seed/controllers, not double-applied from recorded bot commands.
    if side >= 0 and side < controllers.size() and controllers[side] == "human":
        human_command_history.append({
            "tick": tick, "slot": side, "action": action,
            "actor_id": actor_id, "argument": _replay_argument(arg),
            "accepted": applied
        })
    return applied

func _execute_command(side: int, action: String, actor_id: int, arg: Variant = null) -> bool:
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
            _abandon_build(e, "stop")
            e["order"] = "idle"
            e["target_id"] = -1
        "move":
            if kind not in ["worker", "rifleman"] or not (arg is Vector2i) or _blocked(arg):
                return _reject()
            if e["pos"] != arg and _find_route(e["pos"], arg, false).is_empty():
                return _reject()
            _abandon_build(e, "move")
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
            _abandon_build(e, "gather")
            e["order"] = "gather"
            e["source_id"] = arg
            e["gather_phase"] = "return" if int(e["cargo"]) > 0 else "mine"
            e["work_ticks"] = 0
        "build_barracks":
            if kind != "worker" or not (arg is Vector2i):
                return _reject()
            if int(players[side]["matter"]) < COST_BARRACKS or not _can_build(arg, side):
                return _reject()
            if _footprint_distance(e["pos"], arg) > 1 and _route_to_building_ring(e["pos"], arg).is_empty():
                return _reject()
            _abandon_build(e, "new_build_order")
            players[side]["matter"] = int(players[side]["matter"]) - COST_BARRACKS
            spent_matter += COST_BARRACKS
            e["order"] = "build"
            e["build_pos"] = arg
            e["work_ticks"] = TIMING.BARRACKS_BUILD_TICKS
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
            e["train_left"] = TIMING.WORKER_TRAIN_TICKS if training_worker else TIMING.RIFLEMAN_TRAIN_TICKS
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
    # Legacy events retain their keys; now also carry a serializable
    # argument so accepted move/gather/attack orders are reconstructible.
    events.append({
        "tick": tick, "owner": side, "actor": actor_id,
        "action": action, "argument": _replay_argument(arg)
    })
    return true

func _find_route(start: Vector2i, goal: Vector2i, adjacent_ok: bool) -> Array[Vector2i]:
    if adjacent_ok and (building_cells.has(goal) or _reserved_site_at(goal)):
        return _route_to_building_ring(start, goal)
    return navigation.route(start, goal, adjacent_ok)

func _walk(e: Dictionary, dest: Vector2i, adjacent_ok: bool = true) -> void:
    # Integer fractional-tile accumulator: 115 milli-tiles/tick = 2.3
    # tiles/s for workers; 130 milli-tiles/tick = 2.6 for Riflemen.
    # Headless and GUI execute identical movement for identical tick input.
    var gain: int = TIMING.RIFLEMAN_MILLI_PER_TICK if str(e["kind"]) == "rifleman" else TIMING.WORKER_MILLI_PER_TICK
    # Preserve fractional remainder after each step (otherwise 2.3 becomes 2.22).
    e["move_progress"] = mini(TIMING.MILLI_TILES_PER_CELL + gain - 1, int(e["move_progress"]) + gain)
    if int(e["move_progress"]) < TIMING.MILLI_TILES_PER_CELL:
        return
    var route: Array = e["route"]
    if (
            e["route_target"] != dest
            or bool(e["route_adjacent"]) != adjacent_ok
            or int(e["route_revision"]) != navigation.revision
            or route.is_empty()
    ):
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
        e["route_revision"] = navigation.revision
        if route.is_empty():
            return
        step = route[0]
    e["pos"] = step
    route.remove_at(0)
    e["move_progress"] = int(e["move_progress"]) - TIMING.MILLI_TILES_PER_CELL

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

# Stable ID order is the tie-breaker for contested source mining slots.
# No third worker can extract Matter during the same authoritative tick.
func _can_mine_now(worker: Dictionary, source_id: String) -> bool:
    var admitted: int = 0
    for wid in sorted_ids():
        var other: Dictionary = entities[wid]
        if str(other["kind"]) != "worker" or str(other["order"]) != "gather":
            continue
        if str(other["source_id"]) != source_id or str(other["gather_phase"]) != "mine":
            continue
        if int(other["cargo"]) >= TIMING.WORKER_CAPACITY_MATTER:
            continue
        if _distance(other["pos"], sources[source_id]["pos"]) > 1:
            continue
        admitted += 1
        if int(other["id"]) == int(worker["id"]):
            return admitted <= TIMING.SOURCE_MINERS_MAX
        if admitted >= TIMING.SOURCE_MINERS_MAX:
            return false
    return false

func _worker_tick(e: Dictionary) -> void:
    var order: String = str(e["order"])
    var side: int = int(e["owner"])
    if order == "move":
        _walk(e, e["target_pos"], false)
        if e["pos"] == e["target_pos"]:
            e["order"] = "idle"
    elif order == "gather":
        var phase: String = str(e["gather_phase"])
        if phase == "pickup":
            e["work_ticks"] = int(e["work_ticks"]) + 1
            if int(e["work_ticks"]) >= TIMING.PICKUP_TICKS:
                e["gather_phase"] = "return"
                e["work_ticks"] = 0
            return
        if phase in ["return", "unload"]:
            var hqs: Array[int] = units_for(side, "hq")
            if hqs.is_empty():
                e["order"] = "idle"
                return
            var hq: Dictionary = entities[hqs[0]]
            if _distance_to_entity(e["pos"], hq) > 1:
                e["gather_phase"] = "return"
                _walk(e, hq["pos"])
                return
            e["gather_phase"] = "unload"
            e["work_ticks"] = int(e["work_ticks"]) + 1
            if int(e["work_ticks"]) >= TIMING.UNLOAD_TICKS:
                players[side]["matter"] = int(players[side]["matter"]) + int(e["cargo"])
                e["cargo"] = 0
                e["work_ticks"] = 0
                e["gather_phase"] = "mine"
            return
        if int(e["cargo"]) >= TIMING.WORKER_CAPACITY_MATTER:
            e["gather_phase"] = "pickup"
            e["work_ticks"] = 0
            return
        var sid: String = str(e["source_id"])
        if not sources.has(sid) or int(sources[sid]["stock"]) <= 0:
            if int(e["cargo"]) > 0:
                e["gather_phase"] = "pickup"
                e["work_ticks"] = 0
                return
            sid = _nearest_source(e["pos"])
            e["source_id"] = sid
            e["work_ticks"] = 0
        if sid == "":
            e["order"] = "idle"
            return
        var src: Dictionary = sources[sid]
        if _distance(e["pos"], src["pos"]) > 1:
            e["work_ticks"] = 0
            _walk(e, src["pos"])
            return
        if not _can_mine_now(e, sid):
            e["work_ticks"] = 0
            return
        # 2.0 seconds of continuous labor per ONE extracted Matter.
        e["work_ticks"] = int(e["work_ticks"]) + 1
        if int(e["work_ticks"]) >= TIMING.GATHER_TICKS_PER_MATTER:
            src["stock"] = int(src["stock"]) - 1
            e["cargo"] = int(e["cargo"]) + 1
            mined_matter += 1
            e["work_ticks"] = 0
            if (
                    int(e["cargo"]) >= TIMING.WORKER_CAPACITY_MATTER
                    or int(src["stock"]) <= 0
            ):
                e["gather_phase"] = "pickup"
    elif order == "build":
        var site: Vector2i = e["build_pos"]
        if _footprint_distance(e["pos"], site) > 1:
            _walk(e, site)
        else:
            e["work_ticks"] = int(e["work_ticks"]) - 1
            if int(e["work_ticks"]) <= 0:
                if _can_build(site, side, int(e["id"])):
                    _spawn("barracks", side, site)
                    _clear_build_fields(e)
                    e["order"] = "idle"
                elif _footprint_has_mobile(site, int(e["id"])):
                    # Temporary actor occupancy pauses, rather than losing paid progress.
                    e["work_ticks"] = 1
                else:
                    # Permanently invalid worksite; spent resources stay debited.
                    events.append({"tick": tick, "owner": side, "action": "build_site_lost"})
                    _abandon_build(e, "site_invalidated")

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
        if _can_hit(e["pos"], enemy):
            if int(e["cooldown"]) == 0:
                _damage(enemy_id, 8, int(e["owner"]))
                e["cooldown"] = TIMING.RIFLEMAN_ATTACK_COOLDOWN_TICKS
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
        _abandon_build(e, "builder_dead")
        lost_matter += int(e["cargo"])
    if str(e["kind"]) == "hq":
        # The sole MVP0 treasury belongs to a physical HQ, not an immortal wallet.
        lost_matter += int(players[int(e["owner"])]["matter"])
        players[int(e["owner"])]["matter"] = 0
    players[attacker]["kills"] = int(players[attacker]["kills"]) + 1
    events.append({"tick": tick, "owner": attacker, "action": "kill", "victim": entity_id})
    if GEOM.is_building(str(e["kind"])):
        for cell in GEOM.occupied_cells(e["pos"]):
            building_cells.erase(cell)
            navigation.set_blocked(cell, terrain.has(cell))
    entities.erase(entity_id)

func _train_tick(e: Dictionary) -> void:
    if str(e["train_kind"]) == "":
        return
    e["train_left"] = int(e["train_left"]) - 1
    if int(e["train_left"]) > 0:
        return
    # Producer is a 3×3 footprint; spawn outside the completed collider.
    for candidate in GEOM.perimeter_cells(e["pos"]):
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
        # Use a site near this authored HQ rather than hardcoded positions
        # from the superseded horizontal prototype; maintain deterministic order.
        var home: Vector2i = entities[hqs[0]]["pos"]
        var candidate: Vector2i = home + (Vector2i(4, 3) if side == 0 else Vector2i(-4, -3))
        var ordered: bool = false
        if _can_build(candidate, side):
            ordered = issue_command(side, "build_barracks", workers[0], candidate)
        if not ordered:
            for dy in range(-6, 7):
                if ordered:
                    break
                for dx in range(-6, 7):
                    var test_cell: Vector2i = home + Vector2i(dx, dy)
                    if _can_build(test_cell, side):
                        ordered = issue_command(side, "build_barracks", workers[0], test_cell)
                        if ordered:
                            break
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
            # Scout a legal walkable tile near the opposing 3x3 HQ, not its center.
            var scouting_goal: Vector2i = Vector2i(50, 53) if side == 0 else Vector2i(13, 10)
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
    if tick % TIMING.BOT_THINK_TICKS == 1:
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
    var material: String = "mvp0-man-mirror-v6-construction-lifecycle|"
    material += map_id + "|" + map_hash + "|"
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
            e["work_ticks"], e["gather_phase"], e["move_progress"],
            e["cooldown"], e["train_kind"], e["train_left"],
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
        "rules": "mvp0-man-mirror-v5-3x3-world2m",
        "map_id": map_id, "map_hash": map_hash, "map_source_sha": map_source_sha,
        "tick_hz": TIMING.TICKS_PER_SECOND, "max_ticks": MAX_TICKS,
        "seed": seed, "ticks": tick, "winner": winner, "reason": finish_reason,
        "finished": finished, "controllers": controllers.duplicate(),
        "bot_attack_thresholds": bot_attack_thresholds.duplicate(),
        "resources_mined": mined_matter, "resources_spent": spent_matter,
        "lost_matter": lost_matter, "lost_cargo_legacy": lost_matter,
        "rejected_commands": rejected_commands,
        "matter_conserved": matter_is_conserved(), "hash": replay_hash()
    }
