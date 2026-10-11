#!/usr/bin/env python3
"""Zero-dependency map source-pin verification (no YAML parsing needed)."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
source = (root / "design/mvp-verdant-divide-map.yaml").read_bytes()
compiled = json.loads((root / "apps/game/maps/verdant_divide.compiled.json").read_text(encoding="utf8"))
sha = hashlib.sha1(b"blob " + str(len(source)).encode() + b"\0" + source).hexdigest()
if compiled.get("source_git_blob_sha") != sha:
    print("VERDANT_SOURCE_SHA_FAIL: compiled JSON does not match canonical YAML bytes", file=sys.stderr)
    raise SystemExit(1)
if compiled.get("map_id") != "verdant_divide" or compiled.get("frame") != "floating_space_platform":
    print("VERDANT_SOURCE_SHA_FAIL: illegal map/frame", file=sys.stderr)
    raise SystemExit(1)
if sum(int(n["stock"]) for n in compiled["sources"]) != 1660:
    print("VERDANT_SOURCE_SHA_FAIL: Matter checksum", file=sys.stderr)
    raise SystemExit(1)
print("VERDANT_SOURCE_SHA_PASS")
