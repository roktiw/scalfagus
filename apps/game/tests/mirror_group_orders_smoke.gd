extends SceneTree

# DEC-033 RTS GUI contract: reusable click/box/Shift logic and legal group orders.
const GAME = preload("res://scenes/mirror_match.tscn")

func _initialize() -> void:
    call_deferred("_run")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_MIRROR_GROUP_FAIL: " + message)
    quit(1)

func _run() -> void:
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    var game: Node3D = GAME.instantiate()
    root.add_child(game)
    await process_frame
    await process_frame
    var sim = game.get("sim")
    var workers: Array[int] = sim.units_for(0, "worker")
    var enemy_workers: Array[int] = sim.units_for(1, "worker")
    if workers.size() != 3 or enemy_workers.size() != 3:
        _fail("Missing MAN worker fixtures")
        return

    # Click and Shift-click reuse owner-filtered hit selection.
    var a: Vector2i = sim.entities[workers[0]]["pos"]
    var b: Vector2i = sim.entities[workers[1]]["pos"]
    game._select_click(a)
    if game.selected_ids.size() != 1 or game.selected_id != workers[0]:
        _fail("Initial worker selection failed")
        return
    game._select_click(b, true)
    if game.selected_ids.size() != 2 or not game.selected_ids.has(workers[1]):
        _fail("Shift did not extend selection")
        return
    game._select_click(b, true)
    if game.selected_ids.size() != 1 or game.selected_ids.has(workers[1]):
        _fail("Shift did not toggle selection off")
        return

    # Empty click clears selection; enemy click must not select enemy.
    var enemy: Vector2i = sim.entities[enemy_workers[0]]["pos"]
    game._select_click(enemy)
    if not game.selected_ids.is_empty():
        _fail("A human client selected opponent unit")
        return

    # Use actual Godot Camera3D projections for drag-select, not fake pixels.
    var camera: Camera3D = game.camera
    var s0: Vector2 = camera.unproject_position(Vector3(a.x, 0.8, a.y))
    var s1: Vector2 = camera.unproject_position(Vector3(b.x, 0.8, b.y))
    var top_left := Vector2(
        minf(s0.x, s1.x) - 12.0, minf(s0.y, s1.y) - 12.0)
    var bottom_right := Vector2(
        maxf(s0.x, s1.x) + 12.0, maxf(s0.y, s1.y) + 12.0)
    game._select_box(top_left, bottom_right)
    if not game.selected_ids.has(workers[0]) or not game.selected_ids.has(workers[1]):
        _fail("Marquee selection did not project owned units")
        return

    # Use exactly two workers to verify formation destinations.
    game.selected_ids.clear()
    game.selected_ids.append(workers[0])
    game.selected_ids.append(workers[1])
    game.selected_id = workers[1]
    var sent: int = game._issue_group_order(Vector2i(15, 38))
    if sent != 2:
        _fail("Expected two validated move orders")
        return
    var target0: Vector2i = sim.entities[workers[0]]["target_pos"]
    var target1: Vector2i = sim.entities[workers[1]]["target_pos"]
    if target0 == target1 or sim._blocked(target0) or sim._blocked(target1):
        _fail("Group movement stacked units or chose blocked destination")
        return
    if str(sim.entities[workers[0]]["order"]) != "move" or str(sim.entities[workers[1]]["order"]) != "move":
        _fail("Movement orders did not reach shared simulation")
        return

    # Both workers may gather from the same physical Matter source.
    sent = game._issue_group_order(Vector2i(17, 10))
    if sent != 2 or str(sim.entities[workers[0]]["order"]) != "gather":
        _fail("Group gathering did not reuse the legal command gateway")
        return

    # Renderer must remove selection markers and dead-unit pointers together.
    sim._damage(workers[1], 1000, 1)
    game._sync_visuals()
    if game.selected_ids.has(workers[1]):
        _fail("Dead worker remains selected")
        return

    print("SCALFAGUS_MIRROR_GROUP_PASS")
    quit(0)
