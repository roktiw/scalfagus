#!/usr/bin/env python3
"""Compile the owner-authored YAML map to native Godot JSON, never at game runtime.

Dependency: PyYAML==6.0.3 (MIT). The GDScript runtime consumes only committed JSON.
Fail hard on unknown/invalid map geometry rather than fabricating gameplay terrain.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path
import sys

import yaml

ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / "design/mvp-verdant-divide-map.yaml"
OUTPUT = ROOT / "apps/game/maps/verdant_divide.compiled.json"


def source_git_blob_sha(raw: bytes) -> str:
    return hashlib.sha1(b"blob " + str(len(raw)).encode() + b"\0" + raw).hexdigest()


def coords(pair: list[int]) -> tuple[int, int]:
    if not isinstance(pair, list) or len(pair) != 2:
        raise ValueError(f"Expected a 2D integer coordinate, got {pair!r}")
    x, y = pair
    if type(x) is not int or type(y) is not int:
        raise ValueError(f"Noninteger coordinate: {pair!r}")
    return x, y


def on_segment(px: int, py: int, a: tuple[int, int], b: tuple[int, int]) -> bool:
    ax, ay = a
    bx, by = b
    return (px - ax) * (by - ay) == (py - ay) * (bx - ax) and (
        min(ax, bx) <= px <= max(ax, bx) and min(ay, by) <= py <= max(ay, by)
    )


def inside_polygon(px: int, py: int, polygon: list[tuple[int, int]]) -> bool:
    # Deterministic even/odd rule, with polygon border cells always blocked.
    inside = False
    for index, (ax, ay) in enumerate(polygon):
        bx, by = polygon[(index + 1) % len(polygon)]
        if on_segment(px, py, (ax, ay), (bx, by)):
            return True
        if (ay > py) != (by > py):
            cross_x = ax + (py - ay) * (bx - ax) / (by - ay)
            if px < cross_x:
                inside = not inside
    return inside


def build(source: bytes) -> dict:
    manifest = yaml.safe_load(source)
    if manifest.get("schema_version") != 1 or manifest.get("map_id") != "verdant_divide":
        raise ValueError("This compiler accepts only Verdant Divide schema v1")
    if manifest["battlefield_frame"]["variant"] != "floating_space_platform":
        raise ValueError("Only mandatory floating space platform frame is allowed")
    grid = manifest["grid"]
    width, height = int(grid["width"]), int(grid["height"])
    if (width, height) != (64, 64):
        raise ValueError("MVP0 Godot navigation currently supports exactly 64x64")
    if float(grid["tile_meters"]) != 2.0 or int(grid["border_cells_blocked"]) != 1:
        raise ValueError("Unapproved world scale or impassable-rim thickness")

    solids: dict[tuple[int, int], str] = {}

    def block(x: int, y: int, kind: str) -> None:
        if not (1 <= x < width - 1 and 1 <= y < height - 1):
            return
        old = solids.get((x, y), "")
        if old and old != kind:
            raise ValueError(f"Overlapping water and tree at {(x, y)}")
        solids[(x, y)] = kind

    for water in manifest["liquid_bodies"]:
        if water["ground_passable"] or water["harvestable_resource_source"]:
            raise ValueError("Water may neither be walkable nor a resource")
        shape = water["shape"]
        if shape["type"] == "circle":
            cx, cy, radius = int(shape["cx"]), int(shape["cy"]), int(shape["radius"])
            for y in range(max(1, cy - radius), min(height - 1, cy + radius + 1)):
                for x in range(max(1, cx - radius), min(width - 1, cx + radius + 1)):
                    if (x - cx) ** 2 + (y - cy) ** 2 <= radius ** 2:
                        block(x, y, "water")
        elif shape["type"] == "polygon":
            points = [coords(p) for p in shape["points"]]
            if len(points) < 3:
                raise ValueError("Water polygon must have at least 3 points")
            for y in range(1, height - 1):
                for x in range(1, width - 1):
                    if inside_polygon(x, y, points):
                        block(x, y, "water")
        else:
            raise ValueError(f"Unsupported liquid shape: {shape['type']}")

    for tree in manifest["fixed_cover"]:
        if tree["type"] != "giant_living_tree":
            raise ValueError(f"Unknown fixed cover: {tree['type']}")
        tx, ty = coords(tree["tile"])
        radius = float(tree["blocking_trunk_radius_tiles"])
        if radius <= 0 or radius >= 8:
            raise ValueError("Unsupported cover radius")
        for y in range(max(1, math.floor(ty - radius)), min(height - 1, math.ceil(ty + radius) + 1)):
            for x in range(max(1, math.floor(tx - radius)), min(width - 1, math.ceil(tx + radius) + 1)):
                if (x - tx) ** 2 + (y - ty) ** 2 <= radius ** 2:
                    block(x, y, "tree")

    sources = []
    source_ids: set[str] = set()
    source_positions: set[tuple[int, int]] = set()
    for node in manifest["resource_nodes"]:
        sid = node["id"]
        pos = coords(node["tile"])
        stock = int(node["stored_source_units"])
        if sid in source_ids or pos in source_positions or stock <= 0:
            raise ValueError(f"Duplicate or empty Matter source {sid}")
        if pos in solids or not (1 <= pos[0] < width - 1 and 1 <= pos[1] < height - 1):
            raise ValueError(f"Matter source {sid} occupies impassable terrain")
        source_ids.add(sid)
        source_positions.add(pos)
        sources.append({"id": sid, "pos": list(pos), "stock": stock, "kind": node["kind"]})
    if sum(s["stock"] for s in sources) != int(manifest["resource_policy"]["initial_total_world_solid_source_units"]):
        raise ValueError("World Matter checksum disagrees with source nodes")

    slots = []
    for slot in manifest["start_slots"]:
        pos = (int(slot["location"]["x"]), int(slot["location"]["y"]))
        workers = [coords(p) for p in slot["min_worker_locations"]]
        if len(workers) != 3 or len(set(workers)) != 3 or pos in solids or pos in source_positions:
            raise ValueError(f"Illegal HQ/workers at start {slot['id']}")
        for worker in workers:
            if worker in solids or worker in source_positions or worker == pos:
                raise ValueError(f"Start worker overlaps cover or resources: {worker}")
        start_stock = sum(s["stock"] for s in sources if s["id"] in slot["starter_solid_nodes"])
        if start_stock != 400:
            raise ValueError(f"Unbalanced near-HQ resources at {slot['id']}: {start_stock}")
        slots.append({"id": slot["id"], "hq": list(pos), "workers": [list(p) for p in workers],
                      "starter_source_ids": slot["starter_solid_nodes"]})
    if len(slots) != 2 or slots[0]["id"] != "northwest" or slots[1]["id"] != "southeast":
        raise ValueError("Only two canonical MAN mirror slots are allowed")
    if len(sources) != 10:
        raise ValueError("Verdant fixture requires exactly 10 fixed SOLID sources")

    return {
        "schema_version": 1,
        "map_id": manifest["map_id"],
        "map_version": manifest["map_version"],
        "source_manifest": "design/mvp-verdant-divide-map.yaml",
        "source_git_blob_sha": source_git_blob_sha(source),
        "frame": "floating_space_platform",
        "width": width, "height": height,
        "tile_meters": float(grid["tile_meters"]),
        "starts": slots, "sources": sources,
        "terrain": [{"x": x, "y": y, "kind": kind}
                    for (x, y), kind in sorted(solids.items(), key=lambda entry: (entry[0][1], entry[0][0]))],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Compile canonical Verdant YAML to Godot JSON")
    parser.add_argument("--check", action="store_true", help="Fail if checked-in generated JSON differs")
    args = parser.parse_args()
    compiled = json.dumps(build(INPUT.read_bytes()), indent=2, sort_keys=True, ensure_ascii=False) + "\n"
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_text(encoding="utf8") != compiled:
            print("VERDANT_MAP_STALE: rerun python3 scripts/compile-verdant-map.py", file=sys.stderr)
            return 1
        print("VERDANT_MAP_COMPILED_PASS (source YAML matches committed JSON)")
        return 0
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(compiled, encoding="utf8")
    print(f"VERDANT_MAP_COMPILED_PASS {OUTPUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
