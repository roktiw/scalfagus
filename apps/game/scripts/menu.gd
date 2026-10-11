extends Control

# All main menu UI is created with native Godot Controls — no browser window.
var options_panel: VBoxContainer
var menu_panel: VBoxContainer
var resolution_button: OptionButton
var fullscreen_toggle: CheckButton
var menu_stack: VBoxContainer
var shortcut_editor: Control
var shortcut_status: Label
var footer: Label

func _ready() -> void:
    var bg := ColorRect.new()
    bg.color = Color("#091725")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)
    var center := CenterContainer.new()
    center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(center)
    menu_stack = VBoxContainer.new()
    var stack: VBoxContainer = menu_stack
    stack.custom_minimum_size = Vector2(330, 280)
    stack.add_theme_constant_override("separation", 16)
    center.add_child(stack)
    var title := Label.new()
    title.text = "SCALFAGUS"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 38)
    stack.add_child(title)
    var subtitle := Label.new()
    subtitle.text = "MAN vs MAN  |  RTS MVP 0.1 (local test)"
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stack.add_child(subtitle)
    menu_panel = VBoxContainer.new()
    menu_panel.add_theme_constant_override("separation", 12)
    stack.add_child(menu_panel)
    _add_button(menu_panel, "PLAY MAN vs BOT", _start_mirror_vs_bot)
    _add_button(menu_panel, "WATCH BOT vs BOT", _start_mirror_bots)
    _add_button(menu_panel, "LEGACY CAMERA SPIKE", _start_game)
    _add_button(menu_panel, "OPTIONS", _open_options)
    _add_button(menu_panel, "QUIT", _quit)
    options_panel = VBoxContainer.new()
    options_panel.visible = false
    stack.add_child(options_panel)
    resolution_button = OptionButton.new()
    for s in ["1280 × 720", "1440 × 810 (recommended)", "1600 × 900"]:
        resolution_button.add_item(s)
    resolution_button.item_selected.connect(_set_resolution)
    resolution_button.select(1)
    options_panel.add_child(resolution_button)
    fullscreen_toggle = CheckButton.new()
    fullscreen_toggle.text = "Fullscreen"
    fullscreen_toggle.toggled.connect(_set_fullscreen)
    fullscreen_toggle.button_pressed = get_window().mode == Window.MODE_FULLSCREEN
    options_panel.add_child(fullscreen_toggle)

    var controls_title := Label.new()
    controls_title.text = "CONTROLS — Keychain profiles (WASD pan / T Worker / R Rifleman / B Barracks)"
    options_panel.add_child(controls_title)
    shortcut_status = Label.new()
    shortcut_status.text = ""
    shortcut_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    options_panel.add_child(shortcut_status)

    _add_button(options_panel, "BACK", _close_options)
    footer = Label.new()
    footer.text = "LAN Human vs Human: not yet implemented"
    footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stack.add_child(footer)

func _add_button(parent: VBoxContainer, caption: String, callback: Callable) -> void:
    var b := Button.new()
    b.text = caption
    b.custom_minimum_size.y = 43
    b.pressed.connect(callback)
    parent.add_child(b)

func _start_mirror_vs_bot() -> void:
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    get_tree().change_scene_to_file("res://scenes/mirror_match.tscn")

func _start_mirror_bots() -> void:
    ProjectSettings.set_setting("scalfagus/mirror_mode", "bot_bot")
    get_tree().change_scene_to_file("res://scenes/mirror_match.tscn")

func _start_game() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func _open_options() -> void:
    menu_panel.visible = false
    options_panel.visible = true
    footer.visible = false
    menu_stack.custom_minimum_size = Vector2(990, 660)
    # Reuse Keychain's shipped editor and persistence instead of building
    # another key-capture, conflict detector or profile manager.
    if shortcut_editor == null:
        var keychain: Node = get_node_or_null("/root/Keychain")
        if keychain == null:
            shortcut_status.text = "Keychain runtime singleton unavailable. Verify addons locally with: bash scripts/check.sh"
        else:
            var editor_scene := load("res://addons/keychain/ShortcutEdit.tscn") as PackedScene
            if editor_scene == null:
                shortcut_status.text = "Keychain ShortcutEdit scene missing."
            else:
                shortcut_editor = editor_scene.instantiate() as Control
                shortcut_editor.name = "KeychainControls"
                shortcut_editor.custom_minimum_size = Vector2(920, 470)
                shortcut_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
                shortcut_editor.size_flags_vertical = Control.SIZE_EXPAND_FILL
                # Insert before the BACK button.
                options_panel.add_child(shortcut_editor)
                options_panel.move_child(shortcut_editor, options_panel.get_child_count() - 2)
                shortcut_status.text = "Edit bindings here; Keychain saves your profile under user://shortcut_profiles."

func _close_options() -> void:
    options_panel.visible = false
    menu_panel.visible = true
    footer.visible = true
    menu_stack.custom_minimum_size = Vector2(330, 280)

func _set_resolution(index: int) -> void:
    get_window().size = [Vector2i(1280,720), Vector2i(1440,810), Vector2i(1600,900)][index]

func _set_fullscreen(enabled: bool) -> void:
    get_window().mode = Window.MODE_FULLSCREEN if enabled else Window.MODE_WINDOWED

func _quit() -> void:
    get_tree().quit()
