extends Control
class_name MirrorMatchResultOverlay

# Native Godot end-of-match menu. Pure presentation: never decides the winner,
# changes combat rules, or creates duplicate GameState and Matter records.
signal play_again_requested
signal main_menu_requested
signal save_replay_requested

const UI = preload("res://scripts/command_ui_theme.gd")

var headline: Label
var result_reason: Label
var economy: Label
var save_status: Label
var restart_button: Button
var menu_button: Button
var save_button: Button
var panel: PanelContainer

func _ready() -> void:
    name = "MatchResultOverlay"
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_STOP
    theme = UI.create()

    var shade := ColorRect.new()
    shade.name = "ResultShade"
    shade.color = Color(0.015, 0.035, 0.050, 0.91)
    shade.mouse_filter = Control.MOUSE_FILTER_STOP
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)

    var center := CenterContainer.new()
    center.name = "ResultCenter"
    center.mouse_filter = Control.MOUSE_FILTER_STOP
    center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(center)

    panel = PanelContainer.new()
    panel.name = "ResultPanel"
    panel.custom_minimum_size = Vector2(440, 300)
    panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    center.add_child(panel)

    var content := VBoxContainer.new()
    content.add_theme_constant_override("separation", 14)
    panel.add_child(content)
    content.add_child(UI.label("MANUS / VERDANT DIVIDE", 16))
    headline = UI.label("", 32)
    headline.name = "ResultHeadline"
    headline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    content.add_child(headline)
    result_reason = UI.label("", 16)
    result_reason.name = "ResultReason"
    result_reason.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    content.add_child(result_reason)
    economy = UI.label("", 15)
    economy.name = "ResultEconomy"
    economy.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    content.add_child(economy)
    var actions := VBoxContainer.new()
    actions.add_theme_constant_override("separation", 8)
    content.add_child(actions)
    restart_button = _action_button(actions, "Play again", "PlayAgain")
    restart_button.pressed.connect(func(): play_again_requested.emit())
    save_button = _action_button(actions, "Save finished replay", "SaveFinishedReplay")
    save_button.pressed.connect(func(): save_replay_requested.emit())
    menu_button = _action_button(actions, "Main menu", "ReturnToMenu")
    menu_button.pressed.connect(func(): main_menu_requested.emit())
    save_status = UI.label("", 14)
    save_status.name = "ResultSaveStatus"
    save_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    save_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    content.add_child(save_status)
    restart_button.call_deferred("grab_focus")

func _action_button(parent: VBoxContainer, title: String, identifier: String) -> Button:
    var button := Button.new()
    button.name = identifier
    button.text = title
    button.custom_minimum_size.y = 46
    button.focus_mode = Control.FOCUS_ALL
    button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    parent.add_child(button)
    return button

func configure(state: MirrorMatchState, spectator: bool) -> void:
    assert(state != null and state.finished)
    if state.winner == -1:
        headline.text = "DRAW"
    elif spectator:
        headline.text = "NORTHWEST WINS" if state.winner == 0 else "SOUTHEAST WINS"
    else:
        headline.text = "VICTORY" if state.winner == 0 else "DEFEAT"
    result_reason.text = str(state.finish_reason).replace("_", " ").capitalize()
    economy.text = "%02d:%02d  |  MATTER MINED %d  |  SPENT %d  |  LOST %d" % [
        state.tick / 1200, (state.tick / 20) % 60,
        state.mined_matter, state.spent_matter, state.lost_matter
    ]
    save_button.visible = not spectator
    save_status.text = ""

func set_feedback(message: String) -> void:
    save_status.text = message
