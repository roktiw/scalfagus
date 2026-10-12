extends Control
const REPLAY_ARCHIVE = preload("res://scripts/mirror_replay_archive.gd")

signal settings_closed

# All main menu UI is created with native Godot Controls — no browser window.
var options_panel: VBoxContainer
var menu_panel: VBoxContainer
var resolution_button: OptionButton
var fullscreen_toggle: CheckButton
var menu_stack: VBoxContainer
var shortcut_editor: Control
var shortcut_status: Label
var footer: Label

const UI = preload("res://scripts/command_ui_theme.gd")
var back_button: Button
var settings_scroll: ScrollContainer
var first_button: Button
var play_button: Button
var options_button: Button
var watch_button: Button
var replay_button: Button
var replay_error: Label

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_PASS
    theme = UI.create()
    var bg := ColorRect.new()
    bg.color = Color("#080f19")
    bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)
    var frame := MarginContainer.new()
    frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    for side in ["left", "right", "top", "bottom"]:
        frame.add_theme_constant_override("margin_" + side, 28)
    add_child(frame)
    menu_stack = VBoxContainer.new()
    menu_stack.add_theme_constant_override("separation", 16)
    frame.add_child(menu_stack)
    var masthead := HBoxContainer.new()
    menu_stack.add_child(masthead)
    var brand := UI.label("SCALFAGUS", 30)
    brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    masthead.add_child(brand)
    masthead.add_child(UI.label("MANUS  /  COMMAND INTERFACE", 14))
    menu_panel = VBoxContainer.new()
    menu_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
    menu_stack.add_child(menu_panel)
    var center := CenterContainer.new()
    center.size_flags_vertical = Control.SIZE_EXPAND_FILL
    menu_panel.add_child(center)
    var card := PanelContainer.new()
    card.custom_minimum_size.x = 480
    center.add_child(card)
    var choices := VBoxContainer.new()
    choices.add_theme_constant_override("separation", 12)
    card.add_child(choices)
    choices.add_child(UI.label("TAKE COMMAND", 27))
    var description := UI.label("Verdant Divide · Manus vs Manus", 16)
    choices.add_child(description)
    first_button = _add_button(choices, "Play against computer", _start_mirror_vs_bot)
    play_button = first_button
    watch_button = _add_button(choices, "Watch computer vs computer", _start_mirror_bots)
    replay_button = _add_button(choices, "Watch last saved replay", _start_last_replay)
    replay_button.disabled = not FileAccess.file_exists("user://replays/" + REPLAY_ARCHIVE.last_basename() + ".json")
    replay_button.tooltip_text = "Save a Human vs Bot match from the in-game pause menu to enable this."
    replay_error = UI.label("", 14)
    replay_error.visible = false
    replay_error.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    choices.add_child(replay_error)
    options_button = _add_button(choices, "Settings", _open_options)
    _add_button(choices, "Quit game", _quit)
    var debug := _add_button(menu_panel, "Development: camera prototype", _start_game)
    debug.size_flags_horizontal = Control.SIZE_SHRINK_END
    debug.custom_minimum_size.y = 36
    debug.tooltip_text = "Development scene: experimental RTS / TPP / FPP cameras"
    footer = UI.label("LOCAL PLAY  ·  LAN multiplayer is in development", 14)
    menu_stack.add_child(footer)
    options_panel = VBoxContainer.new()
    options_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
    options_panel.visible = false
    menu_stack.add_child(options_panel)
    var heading := HBoxContainer.new()
    options_panel.add_child(heading)
    back_button = Button.new()
    back_button.name = "SettingsBack"
    back_button.text = "‹  Back"
    back_button.custom_minimum_size = Vector2(130, 48)
    back_button.pressed.connect(_close_options)
    heading.add_child(back_button)
    var settings_title := UI.label("SETTINGS", 24)
    settings_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    heading.add_child(settings_title)
    settings_scroll = ScrollContainer.new()
    settings_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    settings_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    options_panel.add_child(settings_scroll)
    var content := VBoxContainer.new()
    content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    content.add_theme_constant_override("separation", 14)
    settings_scroll.add_child(content)
    content.add_child(UI.label("DISPLAY", 18))
    resolution_button = OptionButton.new()
    resolution_button.custom_minimum_size.y = 48
    for item in ["1280 × 720", "1440 × 810", "1600 × 900"]:
        resolution_button.add_item(item)
    resolution_button.item_selected.connect(_set_resolution)
    resolution_button.select(1)
    content.add_child(resolution_button)
    fullscreen_toggle = CheckButton.new()
    fullscreen_toggle.text = "Fullscreen"
    fullscreen_toggle.custom_minimum_size.y = 44
    fullscreen_toggle.button_pressed = get_window().mode == Window.MODE_FULLSCREEN
    fullscreen_toggle.toggled.connect(_set_fullscreen)
    content.add_child(fullscreen_toggle)
    content.add_child(UI.label("CONTROLS & PROFILES", 18))
    shortcut_status = UI.label("Changes to controls are saved in your local profile.")
    shortcut_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    content.add_child(shortcut_status)
    var editor_scene := load("res://addons/keychain/ShortcutEdit.tscn") as PackedScene
    if editor_scene != null:
        shortcut_editor = editor_scene.instantiate() as Control
        shortcut_editor.name = "KeychainControls"
        shortcut_editor.custom_minimum_size = Vector2(0, 460)
        shortcut_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        content.add_child(shortcut_editor)
    else:
        shortcut_status.text = "Controls could not be loaded. Verify the Keychain addon."
    _load_display_settings()
    if get_parent() == get_tree().root and not Engine.is_embedded_in_editor() and DisplayServer.get_name() != "headless" and not FileAccess.file_exists("user://display_settings.cfg"):
        get_window().mode = Window.MODE_MAXIMIZED
    first_button.grab_focus()

func _add_button(parent: VBoxContainer, caption: String, callback: Callable) -> Button:
    var button := Button.new()
    button.text = caption
    button.custom_minimum_size.y = 48
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    button.pressed.connect(callback)
    parent.add_child(button)
    return button

func _unhandled_input(event: InputEvent) -> void:
    if options_panel.visible and event.is_action_pressed("ui_cancel"):
        _close_options()
        get_viewport().set_input_as_handled()

func _unhandled_key_input(event: InputEvent) -> void:
    var key := event as InputEventKey
    if key == null or not key.pressed or key.echo or options_panel.visible:
        return
    match key.keycode:
        KEY_1:
            _start_mirror_vs_bot()
        KEY_2:
            _start_mirror_bots()
        KEY_O:
            _open_options()
        _:
            return
    get_viewport().set_input_as_handled()

func _start_mirror_vs_bot() -> void:
    ProjectSettings.set_setting("scalfagus/mirror_mode", "human_bot")
    get_tree().change_scene_to_file("res://scenes/mirror_match.tscn")

func _start_mirror_bots() -> void:
    ProjectSettings.set_setting("scalfagus/mirror_mode", "bot_bot")
    get_tree().change_scene_to_file("res://scenes/mirror_match.tscn")

func _start_last_replay() -> void:
    if not FileAccess.file_exists("user://replays/" + REPLAY_ARCHIVE.last_basename() + ".json"):
        replay_error.text = "No replay has been saved yet."
        replay_error.visible = true
        return
    # Replay file is untrusted local data. Validate v2 metadata, typed commands
    # and the independent ordered-command hash *before* leaving the live menu.
    var candidate: Dictionary = REPLAY_ARCHIVE.load_user(REPLAY_ARCHIVE.last_basename())
    var prepared: Dictionary = REPLAY_ARCHIVE.prepare(candidate)
    if not bool(prepared.get("ok", false)):
        replay_error.text = "Cannot open replay: " + str(prepared.get("reason", "invalid_file"))
        replay_error.visible = true
        return
    replay_error.visible = false
    ProjectSettings.set_setting("scalfagus/mirror_mode", "replay")
    get_tree().change_scene_to_file("res://scenes/mirror_match.tscn")

func _start_game() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func _open_options() -> void:
    menu_panel.visible = false
    options_panel.visible = true
    footer.visible = false
    back_button.grab_focus()

func _close_options() -> void:
    options_panel.visible = false
    menu_panel.visible = true
    footer.visible = true
    first_button.grab_focus()
    settings_closed.emit()

func _set_resolution(index: int) -> void:
    if Engine.is_embedded_in_editor():
        shortcut_status.text = "Set embedded viewport size in Game → Stretch to Fit."
        return
    get_window().mode = Window.MODE_WINDOWED
    get_window().size = [Vector2i(1280,720), Vector2i(1440,810), Vector2i(1600,900)][index]
    _save_display_settings()

func _set_fullscreen(enabled: bool) -> void:
    if Engine.is_embedded_in_editor():
        shortcut_status.text = "Run in a separate window to change fullscreen mode."
        fullscreen_toggle.set_pressed_no_signal(false)
        return
    get_window().mode = Window.MODE_FULLSCREEN if enabled else Window.MODE_WINDOWED
    _save_display_settings()

func _load_display_settings() -> void:
    if Engine.is_embedded_in_editor():
        return
    var config := ConfigFile.new()
    if config.load("user://display_settings.cfg") != OK:
        return
    var index: int = clampi(int(config.get_value("display", "resolution", 1)), 0, 2)
    resolution_button.select(index)
    get_window().size = [Vector2i(1280,720), Vector2i(1440,810), Vector2i(1600,900)][index]
    var fullscreen: bool = bool(config.get_value("display", "fullscreen", false))
    fullscreen_toggle.set_pressed_no_signal(fullscreen)
    get_window().mode = Window.MODE_FULLSCREEN if fullscreen else Window.MODE_WINDOWED

func _save_display_settings() -> void:
    var config := ConfigFile.new()
    config.load("user://display_settings.cfg")
    config.set_value("display", "resolution", resolution_button.selected)
    config.set_value("display", "fullscreen", fullscreen_toggle.button_pressed)
    if config.save("user://display_settings.cfg") != OK:
        shortcut_status.text = "Display settings could not be saved."

func _quit() -> void:
    get_tree().quit()
