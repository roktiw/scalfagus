extends Control

# All main menu UI is created with native Godot Controls — no browser window.
var options_panel: VBoxContainer
var menu_panel: VBoxContainer
var resolution_button: OptionButton
var fullscreen_toggle: CheckButton

func _ready() -> void:
    var bg := ColorRect.new()
    bg.color = Color("#091725")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)
    var center := CenterContainer.new()
    center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(center)
    var stack := VBoxContainer.new()
    stack.custom_minimum_size = Vector2(330, 280)
    stack.add_theme_constant_override("separation", 16)
    center.add_child(stack)
    var title := Label.new()
    title.text = "SCALFAGUS"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 38)
    stack.add_child(title)
    var subtitle := Label.new()
    subtitle.text = "MAN  •  ETH  |  Godot-native prototype"
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stack.add_child(subtitle)
    menu_panel = VBoxContainer.new()
    menu_panel.add_theme_constant_override("separation", 12)
    stack.add_child(menu_panel)
    _add_button(menu_panel, "START GAME", _start_game)
    _add_button(menu_panel, "OPTIONS", _open_options)
    _add_button(menu_panel, "QUIT", _quit)
    options_panel = VBoxContainer.new()
    options_panel.visible = false
    stack.add_child(options_panel)
    resolution_button = OptionButton.new()
    for s in ["960 × 540", "640 × 360", "320 × 240"]:
        resolution_button.add_item(s)
    resolution_button.item_selected.connect(_set_resolution)
    options_panel.add_child(resolution_button)
    fullscreen_toggle = CheckButton.new()
    fullscreen_toggle.text = "Fullscreen"
    fullscreen_toggle.toggled.connect(_set_fullscreen)
    options_panel.add_child(fullscreen_toggle)
    _add_button(options_panel, "BACK", _close_options)
    var footer := Label.new()
    footer.text = "F1 RTS  |  F2 TPP  |  F3 FPP"
    footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stack.add_child(footer)

func _add_button(parent: VBoxContainer, caption: String, callback: Callable) -> void:
    var b := Button.new()
    b.text = caption
    b.custom_minimum_size.y = 43
    b.pressed.connect(callback)
    parent.add_child(b)

func _start_game() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func _open_options() -> void:
    menu_panel.visible = false
    options_panel.visible = true

func _close_options() -> void:
    options_panel.visible = false
    menu_panel.visible = true

func _set_resolution(index: int) -> void:
    get_window().size = [Vector2i(960,540), Vector2i(640,360), Vector2i(320,240)][index]

func _set_fullscreen(enabled: bool) -> void:
    get_window().mode = Window.MODE_FULLSCREEN if enabled else Window.MODE_WINDOWED

func _quit() -> void:
    get_tree().quit()
