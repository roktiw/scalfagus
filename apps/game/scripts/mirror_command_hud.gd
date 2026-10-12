extends Control

signal command_requested(action: String)
signal menu_requested
const UI = preload("res://scripts/command_ui_theme.gd")
const MAP = preload("res://scripts/mirror_minimap.gd")
const MATCH = preload("res://scripts/mirror_match_state.gd")
const TIMING = preload("res://scripts/mirror_timing.gd")
var world: Node3D
var top: Label
var status: Label
var portrait: TextureRect
var unit_name: Label
var stats: Label
var health: ProgressBar
var progress: ProgressBar
var replay_progress: ProgressBar
var buttons: Dictionary = {}
var minimap: Control
var dock: PanelContainer

func configure(owner_world: Node3D) -> void:
    world = owner_world
    theme = UI.create()
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    var banner := PanelContainer.new()
    banner.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
    banner.offset_bottom = 48
    add_child(banner)
    var row := HBoxContainer.new()
    banner.add_child(row)
    top = UI.label("", 16)
    top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    row.add_child(top)
    replay_progress = ProgressBar.new()
    replay_progress.custom_minimum_size.x = 160
    replay_progress.custom_minimum_size.y = 12
    replay_progress.show_percentage = false
    replay_progress.visible = false
    row.add_child(replay_progress)
    var menu := Button.new()
    menu.text = "Menu  ·  Esc"
    menu.pressed.connect(func(): menu_requested.emit())
    row.add_child(menu)
    dock = PanelContainer.new()
    dock.name = "CommandDeck"
    dock.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
    dock.offset_top = -212
    add_child(dock)
    var column := VBoxContainer.new()
    dock.add_child(column)
    status = UI.label("Select an owned unit to give orders.", 14)
    column.add_child(status)
    var stations := HBoxContainer.new()
    stations.add_theme_constant_override("separation", 24)
    column.add_child(stations)
    minimap = MAP.new()
    minimap.world = world
    minimap.clip_contents = true
    stations.add_child(minimap)
    minimap.focus_requested.connect(func(cell: Vector2i):
        world.camera_center = Vector3(cell.x * 2.0, 0, cell.y * 2.0)
        world._position_camera())
    var spacer := Control.new()
    spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    stations.add_child(spacer)
    var identity := VBoxContainer.new()
    identity.custom_minimum_size.x = 210
    stations.add_child(identity)
    unit_name = UI.label("NO SELECTION", 18)
    unit_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    identity.add_child(unit_name)
    portrait = TextureRect.new()
    portrait.custom_minimum_size = Vector2(140, 94)
    portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    identity.add_child(portrait)
    health = ProgressBar.new()
    health.custom_minimum_size.y = 18
    health.show_percentage = false
    health.add_theme_stylebox_override("background", UI.panel(Color("#243340")))
    health.add_theme_stylebox_override("fill", UI.panel(Color("#67cbb2")))
    identity.add_child(health)
    stats = UI.label("Click / drag to select\nShift adds units\nRight-click to order", 15)
    stats.custom_minimum_size.x = 210
    stations.add_child(stats)
    var orders := VBoxContainer.new()
    orders.custom_minimum_size.x = 260
    stations.add_child(orders)
    orders.add_child(UI.label("COMMANDS", 14))
    var grid := GridContainer.new()
    grid.columns = 2
    orders.add_child(grid)
    for entry in [["build_barracks", "Barracks", "rts_build_barracks"], ["train_worker", "Worker", "rts_train_worker"], ["train_rifleman", "Rifleman", "rts_train_rifleman"], ["stop", "Stop", ""]]:
        var button := Button.new()
        button.text = entry[1]
        button.custom_minimum_size = Vector2(128, 44)
        button.pressed.connect(func(): command_requested.emit(entry[0]))
        button.set_meta("action", entry[2])
        buttons[entry[0]] = button
        grid.add_child(button)
    progress = ProgressBar.new()
    progress.show_percentage = false
    progress.custom_minimum_size.y = 16
    progress.add_theme_stylebox_override("background", UI.panel(Color("#243340")))
    progress.add_theme_stylebox_override("fill", UI.panel(Color("#ddb06b")))
    orders.add_child(progress)

func refresh() -> void:
    var sim = world.sim
    var seconds: int = sim.tick / 20
    var mode: String = "REPLAY" if world.replay_mode else ("SPECTATING" if world.spectator else "HUMAN vs BOT")
    top.text = "MANUS  /  VERDANT DIVIDE     %02d:%02d     MATTER  %d     %s  ·  ×%d" % [seconds / 60, seconds % 60, sim.players[0]["matter"], mode, world.speed]
    status.text = world.info if world.info != "" else "Select units · Right-click terrain, Matter or an enemy to give orders"
    replay_progress.visible = world.replay_mode and world.replay_session != null and world.replay_session.sim != null
    if replay_progress.visible:
        replay_progress.max_value = maxi(1, world.replay_session.final_tick)
        replay_progress.value = mini(sim.tick, world.replay_session.final_tick)
        replay_progress.tooltip_text = "REPLAY  tick %d/%d  ·  %d/%d commands" % [
            sim.tick, world.replay_session.final_tick,
            world.replay_session.next_command, world.replay_session.commands.size()
        ]
    if sim.finished and not world.replay_mode:
        status.text = "MATCH COMPLETE  ·  %s  ·  %s" % ["DRAW" if sim.winner < 0 else "VICTORY" if sim.winner == 0 else "DEFEAT", sim.finish_reason.replace("_", " ")]
    elif world.replay_mode and world.replay_session != null and world.replay_session.finished:
        status.text = world.info if world.info != "" else "REPLAY COMPLETE"
    var selected: Dictionary = sim.entities.get(world.selected_id, {})
    var kind: String = str(selected.get("kind", ""))
    unit_name.text = {"hq": "COMMAND CORE", "worker": "MIN WORKER", "barracks": "BARRACKS", "rifleman": "RIFLEMAN"}.get(kind, "NO SELECTION")
    health.visible = not selected.is_empty()
    progress.visible = false
    portrait.texture = null
    if not selected.is_empty():
        health.max_value = MATCH.HP[kind]
        health.value = selected["hp"]
        var visual = world.unit_nodes[world.selected_id].get_node("Visual")
        var crop := AtlasTexture.new()
        crop.atlas = visual.sprite.texture
        crop.region = visual.sprite.region_rect
        portrait.texture = crop
        stats.text = "HP  %d / %d\n%s\n%s\n%d selected" % [selected["hp"], MATCH.HP[kind], str(selected["order"]).capitalize(), "Cargo  %d / %d" % [selected["cargo"], TIMING.WORKER_CAPACITY_MATTER] if kind == "worker" else "Manus · owned structure" if kind in ["hq", "barracks"] else "Manus · infantry", world.selected_ids.size()]
        var training: String = str(selected["train_kind"])
        if training != "" or str(selected["order"]) == "build":
            progress.visible = true
            progress.max_value = TIMING.BARRACKS_BUILD_TICKS if training == "" else TIMING.WORKER_TRAIN_TICKS if training == "worker" else TIMING.RIFLEMAN_TRAIN_TICKS
            progress.value = progress.max_value - int(selected["work_ticks"] if training == "" else selected["train_left"])
    else:
        stats.text = "Click / drag to select\nShift adds units\nRight-click to order"
    for action in buttons:
        var button: Button = buttons[action]
        var allowed: bool = not world.spectator and not world.replay_mode and not sim.finished and not selected.is_empty()
        var cost: int = 0
        match action:
            "build_barracks":
                allowed = allowed and kind == "worker"
                cost = MATCH.COST_BARRACKS
            "train_worker":
                allowed = allowed and kind == "hq" and str(selected.get("train_kind", "")) == ""
                cost = MATCH.COST_WORKER
            "train_rifleman":
                allowed = allowed and kind == "barracks" and str(selected.get("train_kind", "")) == ""
                cost = MATCH.COST_RIFLEMAN
            "stop":
                allowed = allowed and kind in ["worker", "rifleman"]
        button.disabled = not allowed or int(sim.players[0]["matter"]) < cost
        var action_name: String = button.get_meta("action")
        var hint: String = ""
        if action_name != "":
            var bindings := InputMap.action_get_events(action_name)
            if not bindings.is_empty():
                hint = bindings[0].as_text()
        button.tooltip_text = "%s%s" % ["Matter: %d. " % cost if cost > 0 else "", hint]
    minimap.queue_redraw()
