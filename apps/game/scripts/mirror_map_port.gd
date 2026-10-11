extends RefCounted
class_name MirrorMapPort

# DEC-034 Reuse First: YAML is authored offline, Godot reads native JSON.
# Source: design/mvp-verdant-divide-map.yaml
# Compiled: apps/game/maps/verdant_divide.compiled.json
const COMPILED_PATH: String = "res://maps/verdant_divide.compiled.json"

static func load_verdant() -> Dictionary:
    var file := FileAccess.open(COMPILED_PATH, FileAccess.READ)
    if file == null:
        push_error("SCALFAGUS_MAP_ERROR: missing compiled Verdant fixture")
        return {}
    var raw: String = file.get_as_text()
    var data: Variant = JSON.parse_string(raw)
    if not (data is Dictionary):
        push_error("SCALFAGUS_MAP_ERROR: compiled JSON must be an object")
        return {}
    var document: Dictionary = data
    if (
            int(document.get("schema_version", -1)) != 1
            or str(document.get("map_id", "")) != "verdant_divide"
            or str(document.get("frame", "")) != "floating_space_platform"
            or int(document.get("width", 0)) != 64
            or int(document.get("height", 0)) != 64
            or float(document.get("tile_meters", 0)) != 2.0
    ):
        push_error("SCALFAGUS_MAP_ERROR: unapproved compiled map contract")
        return {}
    var blocked: Dictionary = {}
    for tile in document.get("terrain", []):
        if not (tile is Dictionary):
            return {}
        var p := Vector2i(int(tile["x"]), int(tile["y"]))
        var kind: String = str(tile["kind"])
        if not _on_deck(p) or kind not in ["tree", "water"] or blocked.has(p):
            push_error("SCALFAGUS_MAP_ERROR: duplicate or illegal terrain " + str(p))
            return {}
        blocked[p] = kind

    var sources: Dictionary = {}
    var stock_total: int = 0
    for node in document.get("sources", []):
        if not (node is Dictionary):
            return {}
        var sid: String = str(node["id"])
        var pos := _cell(node["pos"])
        var stock: int = int(node["stock"])
        if sid.is_empty() or sources.has(sid) or not _on_deck(pos) or blocked.has(pos) or stock <= 0:
            push_error("SCALFAGUS_MAP_ERROR: illegal SOLID source " + sid)
            return {}
        sources[sid] = {"pos": pos, "stock": stock, "kind": str(node["kind"])}
        stock_total += stock
    if sources.size() != 10 or stock_total != 1660:
        push_error("SCALFAGUS_MAP_ERROR: world Matter checksum != 1660")
        return {}

    var starts: Array[Dictionary] = []
    for slot in document.get("starts", []):
        var hq := _cell(slot["hq"])
        if not _on_deck(hq) or blocked.has(hq):
            return {}
        var workers: Array[Vector2i] = []
        for coords in slot["workers"]:
            var cell := _cell(coords)
            if not _on_deck(cell) or blocked.has(cell) or workers.has(cell):
                return {}
            workers.append(cell)
        if workers.size() != 3:
            return {}
        starts.append({"id": str(slot["id"]), "hq": hq, "workers": workers})
    if starts.size() != 2 or starts[0]["id"] != "northwest" or starts[1]["id"] != "southeast":
        return {}
    return {
        "map_id": str(document["map_id"]),
        "source_git_blob_sha": str(document["source_git_blob_sha"]),
        "map_hash": raw.sha256_text(),
        "tile_meters": 2.0,
        "terrain": blocked,
        "sources": sources,
        "starts": starts
    }

static func _cell(items: Array) -> Vector2i:
    return Vector2i(int(items[0]), int(items[1]))

static func _on_deck(p: Vector2i) -> bool:
    return p.x >= 1 and p.y >= 1 and p.x < 63 and p.y < 63
