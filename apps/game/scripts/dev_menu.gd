extends Panel

## In-game development overlay. It is intentionally opt-in and hidden by default.
## The game remains fully usable without this panel.
var world: Node
var status: Label

func configure(owner: Node) -> void:
    world = owner
    visible = false
    position = Vector2(18, 18)
    size = Vector2(310, 360)
    self_modulate = Color(0.72, 0.9, 0.9, 0.94)
    mouse_filter = Control.MOUSE_FILTER_STOP
    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 14)
    margin.add_theme_constant_override("margin_top", 12)
    margin.add_theme_constant_override("margin_right", 14)
    margin.add_theme_constant_override("margin_bottom", 12)
    add_child(margin)
    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 8)
    margin.add_child(column)
    var title := Label.new()
    title.text = "DEV MENU  ·  F12 to close"
    title.add_theme_font_size_override("font_size", 18)
    column.add_child(title)
    _button(column, "RTS / Overlord (F1)", func(): world._apply_mode(world.OVERLORD))
    _button(column, "Direct / TPP (F2)", func(): world._apply_mode(world.DIRECT))
    _button(column, "Possession / FPS (F3)", func(): world._apply_mode(world.FPS))
    _button(column, "Reset current scene", func(): get_tree().reload_current_scene())
    _button(column, "Focus selected hero", func(): world.dev_focus_hero())
    _button(column, "Toggle minimap", func(): world.minimap.visible = not world.minimap.visible)
    _button(column, "Toggle selection debug", func(): world.dev_selection_debug = not world.dev_selection_debug)
    status = Label.new()
    status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    status.add_theme_color_override("font_color", Color("#9fc5c5"))
    column.add_child(status)

func _button(parent: VBoxContainer, text: String, callback: Callable) -> void:
    var button := Button.new()
    button.text = text
    button.custom_minimum_size.y = 32
    button.pressed.connect(callback)
    parent.add_child(button)

func refresh() -> void:
    if status == null or world == null:
        return
    var mode: String = ["RTS", "TPP", "FPS"][world.view_mode]
    status.text = "Mode: %s\nHero: %s\nPosition: %s\nSelected: %d\nNav cells: %d" % [
        mode, world.hero.entity_id, str(world.hero.global_position.round()),
        world.selected_units.size(), world.navigator.blocked_count]
