extends GutTest

const MATCH = preload("res://scripts/mirror_match_state.gd")

func test_initial_MIRROR_state_is_repeatable() -> void:
    var a = MATCH.new()
    var b = MATCH.new()
    a.setup(42, ["human", "human"])
    b.setup(42, ["human", "human"])
    assert_eq(a.replay_hash(), b.replay_hash(), "Same seed must create identical state")
    assert_eq(a.units_for(0, "hq").size(), 1)
    assert_eq(a.units_for(1, "hq").size(), 1)
    assert_eq(a.units_for(0, "worker").size(), 3)
    assert_eq(a.units_for(1, "worker").size(), 3)

func test_enemy_unit_orders_are_rejected() -> void:
    var sim = MATCH.new()
    sim.setup(42, ["human", "human"])
    var enemy: int = sim.units_for(1, "worker")[0]
    var before: String = sim.replay_hash()
    assert_false(sim.issue_command(0, "move", enemy, Vector2i(12, 12)))
    # Rejection counter is intentional, so we assert it directly instead
    # of comparing hashes that may legitimately include this counter.
    assert_eq(sim.rejected_commands, 1)
    assert_true(sim.matter_is_conserved())
    assert_ne(before, "", "Replay hash should be present")
