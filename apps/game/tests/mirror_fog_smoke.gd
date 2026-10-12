extends SceneTree

# Actual headless Godot acceptance for human-only fog: current sight,
# persistent explored memory, shrouded Matter, and low-node-count GPU fog.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const FOG = preload("res://scripts/mirror_fog_of_war.gd")
const GAME = preload("res://scenes/mirror_match.tscn")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(reason: String) -> void:
    push_error("SCALFAGUS_MIRROR_FOG_FAIL: " + reason)
    quit(1)

func _verify() -> void:
    var sim: MirrorMatchState = MATCH.new()
    sim.setup(42, ["human", "bot"])
    var fog: MirrorFogOfWar = FOG.new()
    var hash_before: String = sim.replay_hash()
    if not fog.refresh(sim, 0):
        _fail("First update failed to discover visible cells")
        return
    if fog.visible_count(0) < 20 or fog.visible_count(0) >= MATCH.BOARD * MATCH.BOARD:
        _fail("Initial player sees zero cells or the entire map")
        return
    if not fog.is_visible(Vector2i(9, 9), 0):
        _fail("Friendly HQ starting tile is shrouded")
        return
    if fog.is_visible(Vector2i(54, 54), 0) or fog.is_discovered(Vector2i(54, 54), 0):
        _fail("Enemy HQ is revealed on match start")
        return
    if fog.refresh(sim, 0):
        _fail("Cached vision rebuilds with no position or obstacle changes")
        return
    if hash_before != sim.replay_hash() or not sim.matter_is_conserved():
        _fail("Fog altered simulation hash or Matter custody")
        return

    for sid in sim.sources.keys():
        var source: Dictionary = sim.sources[sid]
        # Source records are not 3x3 buildings. Must exactly match the
        # authoritative team's source-cell vision, not global map knowledge.
        if fog.is_visible(source["pos"], 0) != sim.can_see(0, source["pos"]):
            _fail("Matter node visibility diverged from source-cell LOS: " + str(sid))
            return
    var visible_at_start: int = fog.visible_count(0)
    var explored_at_start: int = fog.discovered_count(0)
    if visible_at_start != explored_at_start:
        _fail("Initial explored shroud does not match current vision")
        return

    # Move all four own actors well away from NW in this isolated *test
    # state*, without advancing game ticks; only observing must preserve
    # the old shroud memory and must not leak back into MatchState state.
    for id in sim.sorted_ids():
        if int(sim.entities[id]["owner"]) == 0:
            sim.entities[id]["pos"] = Vector2i(48, 48)
    var moved_hash: String = sim.replay_hash()
    if not fog.refresh(sim, 0):
        _fail("Visibility failed to update after an own unit changed position")
        return
    if not fog.is_discovered(Vector2i(9, 9), 0) or fog.is_visible(Vector2i(9, 9), 0):
        _fail("Previously seen NW HQ must stay remembered, but not visible")
        return
    if not fog.is_visible(Vector2i(48, 48), 0):
        _fail("New location not currently visible")
        return
    if fog.discovered_count(0) <= explored_at_start:
        _fail("Exploration did not extend into newly visited terrain")
        return
    if moved_hash != sim.replay_hash():
        _fail("Computing shroud memory altered the gameplay")
        return

    # A tree is discoverable at its *near face*, even though the tree
    # target itself is blocking in MatchState._line_clear.
    var checked_trunk: bool = false
    for tree_cell in sim.terrain.keys():
        if sim.terrain[tree_cell] != "tree":
            continue
        for offset in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
            var next_to: Vector2i = tree_cell + offset
            if not sim._in_bounds(next_to) or sim._blocked(next_to):
                continue
            var chosen: int = sim.units_for(0, "worker")[0]
            sim.entities[chosen]["pos"] = next_to
            fog.refresh(sim, 0)
            if not fog.is_visible(tree_cell, 0):
                _fail("Tree face invisible from adjacent passable cell")
                return
            checked_trunk = true
            break
        if checked_trunk:
            break
    if not checked_trunk:
        _fail("No accessible tree near-face test cell")
        return
    fog.reset()
    if fog.visible_count(0) != 0 or fog.discovered_count(0) != 0:
        _fail("Reset leaked previously explored terrain into another match")
        return

    # Scene visual gate: unlike the original presentation, unknown source
    # sprites must be hidden. Spectator behavior remains separately free.
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var game: Node3D = GAME.instantiate()
    root.add_child(game)
    await process_frame
    var local_sim: MirrorMatchState = game.get("sim")
    var local_fog: MirrorFogOfWar = game.get("fog")
    var overlay: MirrorFogOverlay = game.get("fog_overlay")
    if local_fog == null or overlay == null or overlay.get_child_count() != 2:
        _fail("Game lost native two-layer MultiMesh fog")
        return
    if overlay.unexplored_mesh.instance_count != 4096 or overlay.remembered_mesh.instance_count != 4096:
        _fail("Fog no longer shares canonical 64x64 Godot GPU tile instances")
        return
    if int(overlay.counts["unexplored"]) + int(overlay.counts["remembered"]) != 4096 - local_fog.visible_count(0):
        _fail("Rendered fog tile counts differ from authoritative visible-cell set")
        return
    var nodes: Dictionary = game.get("source_nodes")
    var hidden_sources: int = 0
    var visible_sources: int = 0
    for sid in nodes.keys():
        var ore: Node3D = nodes[sid]
        var source: Dictionary = local_sim.sources[sid]
        var expected: bool = int(source["stock"]) > 0 and local_fog.is_visible(source["pos"], 0)
        if ore.visible != expected:
            _fail("Source sprite leaked undiscovered Matter " + str(sid))
            return
        if expected:
            visible_sources += 1
        else:
            hidden_sources += 1
            if game._resource_near(source["pos"]) == str(sid):
                _fail("Right-click could gather resource IDs through shroud")
                return
    if hidden_sources == 0 or visible_sources == 0:
        _fail("Fog fixture needs both visible and hidden authored source nodes")
        return
    var visuals: Dictionary = game.get("terrain_visual_nodes")
    if visuals.size() != local_sim.terrain.size():
        _fail("Authored terrain visual nodes and fog source disagree")
        return
    for cell in visuals.keys():
        var node: Node3D = visuals[cell]
        if node.visible != local_fog.is_discovered(cell, 0):
            _fail("Unknown terrain prop visible through undiscovered shroud")
            return
    if not local_sim.matter_is_conserved():
        _fail("Fog presentation leaked into match ledger")
        return
    # Bot-vs-Bot spectator mode stays omniscient: this checks the same
    # presentation toggles without requiring a second renderer teardown.
    game.spectator = true
    overlay.set_spectator(true)
    game._sync_visuals()
    if overlay.visible:
        _fail("Spectator still sees the shroud overlay")
        return
    for sid in nodes.keys():
        if int(local_sim.sources[sid]["stock"]) > 0 and not (nodes[sid] as Node3D).visible:
            _fail("Bot observer lost visibility of active Matter")
            return
    game.queue_free()
    await process_frame
    print("SCALFAGUS_MIRROR_FOG_PASS")
    quit(0)
