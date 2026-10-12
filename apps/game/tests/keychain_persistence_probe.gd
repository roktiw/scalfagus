extends SceneTree

# Only run in the isolated project created by check-keychain-persistence.sh.
func _initialize() -> void:
    call_deferred("_verify")

func _verify() -> void:
    if not OS.get_user_data_dir().get_file().begins_with("Scalfagus-KeychainQA-"):
        push_error("Refusing to modify the normal user's Keychain profile")
        quit(1)
        return
    var keychain: Node = root.get_node("Keychain")
    var phase: String = OS.get_environment("SCALFAGUS_KEYCHAIN_QA_PHASE")
    if phase == "write":
        var binding := InputEventKey.new()
        binding.physical_keycode = KEY_Y
        keychain.action_erase_events("rts_train_worker")
        keychain.action_add_event("rts_train_worker", binding)
        keychain.change_action("rts_train_worker")
    elif phase == "read":
        var bindings := InputMap.action_get_events("rts_train_worker")
        if bindings.size() != 1 or not (bindings[0] is InputEventKey) or bindings[0].physical_keycode != KEY_Y:
            push_error("Keychain T-to-Y remap did not survive a process restart")
            quit(1)
            return
        var defaults: Dictionary = ProjectSettings.get_setting("input/rts_train_worker")
        if defaults["events"][0].physical_keycode != KEY_T:
            push_error("Profile remap changed canonical project input defaults")
            quit(1)
            return
    else:
        push_error("Unknown persistence QA phase")
        quit(1)
        return
    print("SCALFAGUS_KEYCHAIN_PERSISTENCE_", phase.to_upper(), "_PASS")
    var output := FileAccess.open(OS.get_environment("SCALFAGUS_KEYCHAIN_QA_PATH_FILE"), FileAccess.WRITE)
    output.store_string(OS.get_user_data_dir())
    output.close()
    quit(0)
