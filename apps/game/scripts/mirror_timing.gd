extends RefCounted
class_name MirrorTiming

# First MAN-only micro-MVP candidate profile:
# design/mvp0-agent-implementation-contract.yaml (DEC-033 / DEC-034).
# Integer ticks are authoritative; wall-clock/render frame duration never
# enters the match simulation, and headless/GUI share these constants.
const TICKS_PER_SECOND: int = 20
const TICK_SECONDS: float = 1.0 / float(TICKS_PER_SECOND)
const MATCH_LIMIT_TICKS: int = 20 * 60 * TICKS_PER_SECOND

const GATHER_TICKS_PER_MATTER: int = 2 * TICKS_PER_SECOND
const WORKER_CAPACITY_MATTER: int = 10
const SOURCE_MINERS_MAX: int = 2
const PICKUP_TICKS: int = 7 # 0.35 s
const UNLOAD_TICKS: int = 7 # 0.35 s

const BARRACKS_BUILD_TICKS: int = 18 * TICKS_PER_SECOND
const WORKER_TRAIN_TICKS: int = 7 * TICKS_PER_SECOND
const RIFLEMAN_TRAIN_TICKS: int = 9 * TICKS_PER_SECOND
const RIFLEMAN_ATTACK_COOLDOWN_TICKS: int = 1 * TICKS_PER_SECOND
const BOT_THINK_TICKS: int = 10

# Exact integer movement accumulator, 1000 milli-tiles = one grid step:
# 2.3 worker tiles/s and 2.6 Rifleman tiles/s / 20 ticks/s.
const MILLI_TILES_PER_CELL: int = 1000
const WORKER_MILLI_PER_TICK: int = 115
const RIFLEMAN_MILLI_PER_TICK: int = 130
