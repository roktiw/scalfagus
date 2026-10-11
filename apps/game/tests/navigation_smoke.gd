extends SceneTree

# Run with: godot --headless --path apps/game --script res://tests/navigation_smoke.gd
const NAV_SCRIPT = preload("res://scripts/grid_navigator.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(message: String, exit_code: int) -> void:
    push_error("NAV_SMOKE: " + message)
    quit(exit_code)

func _verify() -> void:
    var nav: ScalfagusGridNavigator = NAV_SCRIPT.new()
    nav.block_rectangle(Vector2(0.0, 0.0), Vector2(6.0, 6.0))
    nav.block_circle(Vector2(14.0, 0.0), 3.0)
    if not nav.is_blocked_at(Vector2.ZERO):
        _fail("center building must block", 2)
        return
    if not nav.is_blocked_at(Vector2(14.0, 0.0)):
        _fail("pond must block", 3)
        return
    if not nav.is_blocked_at(Vector2(70.0, 0.0)):
        _fail("edge must block", 4)
        return
    var path: Array[Vector3] = nav.route(Vector2(-10.0, 0.0), Vector2(22.0, 0.0))
    if path.size() < 10:
        _fail("expected a substantial detour around two obstacles", 5)
        return
    for point in path:
        if nav.is_blocked_at(Vector2(point.x, point.z)):
            _fail("route contains blocked cell", 6)
            return
    var target: Vector3 = path.back()
    if Vector2(target.x, target.z).distance_to(Vector2(22.0, 0.0)) > 3.0:
        _fail("route destination is not reached", 7)
        return
    var snapped: Array[Vector3] = nav.route(Vector2(-10.0, 0.0), Vector2(0.0, 0.0))
    if snapped.is_empty() or nav.is_blocked_at(Vector2(snapped.back().x, snapped.back().z)):
        _fail("blocked destination should snap to a valid walkable cell", 8)
        return
    var outside: Array[Vector3] = nav.route(Vector2(100.0, 100.0), Vector2.ZERO)
    if not outside.is_empty():
        _fail("out-of-bounds unit must not be teleported", 9)
        return
    var scene: PackedScene = load("res://scenes/main.tscn")
    if scene == null:
        _fail("main scene missing", 10)
        return
    var game: Node3D = scene.instantiate()
    root.add_child(game)
    await process_frame
    await process_frame
    var real_navigation: ScalfagusGridNavigator = game.get("navigator")
    if real_navigation == null or real_navigation.blocked_count < 80:
        _fail("Verdant Divide obstacles were not registered", 11)
        return
    var hero: PrototypeHero = game.get_node("Hero")
    var route: Array[Vector3] = real_navigation.route(
        Vector2(hero.global_position.x, hero.global_position.z), Vector2(45.0, 45.0))
    if route.is_empty():
        _fail("MAN should be able to route across the prototype jungle", 12)
        return
    hero.issue_route(route)
    if not hero.has_command or hero.navigation_waypoints.size() != route.size():
        _fail("Hero path command was not stored", 13)
        return
    hero.cancel_order()
    if hero.has_command or not hero.navigation_waypoints.is_empty():
        _fail("Hero path cancellation failed", 14)
        return
    if game.get_node_or_null("HUD/RTSMinimap") == null:
        _fail("RTS minimap not present", 15)
        return
    # Preserve one actor and one world across camera handoffs.
    var entity_id: String = hero.entity_id
    game._apply_mode(1)
    game._apply_mode(2)
    game._apply_mode(0)
    if hero.entity_id != entity_id or game.get_node("Hero") != hero:
        _fail("Camera mode recreated hero", 16)
        return
    game.queue_free()
    await process_frame
    print("SCALFAGUS_NAV_SMOKE_PASS: A*, 3D obstacles, waypoints, minimap, actor identity")
    quit(0)
