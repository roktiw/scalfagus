extends RefCounted
class_name MirrorFogOfWar

# Presentation-only vision memory for MVP0 MAN mirror RTS. There is no
# second gameplay or combat authority here: MatchState still enforces LOS,
# ownership, target legality, navigation and the fixed 20Hz simulation.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const BOARD: int = MATCH.BOARD

var currently_visible: Dictionary = {0: {}, 1: {}}
var discovered: Dictionary = {0: {}, 1: {}}
var signatures: Dictionary = {0: "", 1: ""}

func reset() -> void:
    currently_visible = {0: {}, 1: {}}
    discovered = {0: {}, 1: {}}
    signatures = {0: "", 1: ""}

func _signature(sim: MirrorMatchState, slot: int) -> String:
    # Cached line of sight depends only on own units/positions and obstacles,
    # not elapsed ticks, resources, changing HP or rendering frames.
    var material: String = "%d|%s|%d|%d|" % [
        sim.get_instance_id(), sim.map_hash, slot, sim.navigation.revision
    ]
    for id in sim.sorted_ids():
        var unit: Dictionary = sim.entities[id]
        if int(unit["owner"]) != slot:
            continue
        var p: Vector2i = unit["pos"]
        material += "%d:%s:%d:%d|" % [id, str(unit["kind"]), p.x, p.y]
    return material

func _line_reaches_tree(sim: MirrorMatchState, origin: Vector2i,
        target: Vector2i) -> bool:
    # MatchState._line_clear rejects a tree cell even when it is the final
    # target. The trunk itself must nevertheless become discoverable.
    # Follow the same Bresenham steps and stop ONE cell before that trunk;
    # all intervening blockers still use the canonical MatchState LOS.
    var x: int = origin.x
    var y: int = origin.y
    var dx: int = absi(target.x - x)
    var dy: int = absi(target.y - y)
    var sx: int = 1 if x < target.x else -1
    var sy: int = 1 if y < target.y else -1
    var error: int = dx - dy
    var before: Vector2i = origin
    while x != target.x or y != target.y:
        before = Vector2i(x, y)
        var twice: int = 2 * error
        if twice > -dy:
            error -= dy
            x += sx
        if twice < dx:
            error += dx
            y += sy
    return sim._line_clear(origin, before)

func _can_observe(sim: MirrorMatchState, origin: Vector2i,
        cell: Vector2i) -> bool:
    if sim.terrain.get(cell, "") == "tree":
        return _line_reaches_tree(sim, origin, cell)
    return sim._line_clear(origin, cell)

func refresh(sim: MirrorMatchState, slot: int = 0) -> bool:
    # Returns true only if the physical visibility/obstacle signature changed.
    # No mutation of MirrorMatchState, Matter ledger or replay hash.
    if sim == null or slot not in [0, 1] or sim.navigation == null:
        return false
    var stamp: String = _signature(sim, slot)
    if signatures[slot] == stamp:
        return false
    var visible: Dictionary = {}
    for id in sim.sorted_ids():
        var e: Dictionary = sim.entities[id]
        if int(e["owner"]) != slot:
            continue
        var origin: Vector2i = e["pos"]
        var vision: int = 9 if str(e["kind"]) == "hq" else 8
        for dy in range(-vision, vision + 1):
            var remaining: int = vision - absi(dy)
            for dx in range(-remaining, remaining + 1):
                var cell: Vector2i = origin + Vector2i(dx, dy)
                if cell.x < 0 or cell.y < 0 or cell.x >= BOARD or cell.y >= BOARD:
                    continue
                if visible.has(cell):
                    continue
                if _can_observe(sim, origin, cell):
                    visible[cell] = true
    currently_visible[slot] = visible
    var remembered: Dictionary = discovered[slot]
    for cell in visible.keys():
        remembered[cell] = true
    signatures[slot] = stamp
    return true

func is_visible(cell: Vector2i, slot: int = 0) -> bool:
    return currently_visible.has(slot) and currently_visible[slot].has(cell)

func is_discovered(cell: Vector2i, slot: int = 0) -> bool:
    return discovered.has(slot) and discovered[slot].has(cell)

func visible_count(slot: int = 0) -> int:
    return currently_visible[slot].size() if currently_visible.has(slot) else 0

func discovered_count(slot: int = 0) -> int:
    return discovered[slot].size() if discovered.has(slot) else 0
