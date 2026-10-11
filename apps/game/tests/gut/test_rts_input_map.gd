extends GutTest

# Exercising the installed MIT GUT framework, not a custom unit-test runner.
func test_all_RTS_actions_have_project_defaults() -> void:
    var names: Array[StringName] = [
        &"rts_pan_up", &"rts_pan_down", &"rts_pan_left", &"rts_pan_right",
        &"rts_build_barracks", &"rts_train_worker", &"rts_train_rifleman",
        &"rts_pause", &"rts_speed_up", &"rts_speed_down"
    ]
    for action in names:
        assert_true(InputMap.has_action(action), "Missing action: %s" % action)
        assert_true(ProjectSettings.has_setting("input/" + str(action)),
            "Action was not declared in project.godot: %s" % action)

func test_camera_and_training_do_not_share_default_physical_key() -> void:
    var pan: Dictionary = ProjectSettings.get_setting("input/rts_pan_up", {})
    var train: Dictionary = ProjectSettings.get_setting("input/rts_train_worker", {})
    var pan_key: int = -1
    var train_key: int = -1
    for event in pan.get("events", []):
        if event is InputEventKey:
            pan_key = event.physical_keycode
    for event in train.get("events", []):
        if event is InputEventKey:
            train_key = event.physical_keycode
    assert_eq(pan_key, KEY_W)
    assert_eq(train_key, KEY_T)
    assert_ne(pan_key, train_key, "Worker production must not conflict with camera pan")
