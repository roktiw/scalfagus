extends SceneTree

# Seed GUT's native bottom panel without modifying pinned plugin source or profiles.
func _initialize() -> void:
    var defaults: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://.gutconfig.json"))
    var globals = load("res://addons/gut/gui/editor_globals.gd")
    globals.create_temp_directory()
    var path: String = globals.editor_run_gut_config_path
    var settings: Dictionary = {}
    if FileAccess.file_exists(path):
        var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
        if not (parsed is Dictionary):
            push_error("Invalid existing GUT editor config; preserved without overwriting")
            quit(1)
            return
        settings = parsed
    var dirs: Array = settings.get("dirs", [])
    if not dirs.has("res://tests/gut"):
        dirs.append("res://tests/gut")
    settings["dirs"] = dirs
    settings["include_subdirs"] = true
    settings["failure_error_types"] = defaults["failure_error_types"]
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        push_error("Cannot save GUT editor config")
        quit(1)
        return
    file.store_string(JSON.stringify(settings, "  "))
    file.close()
    print("SCALFAGUS_LOCAL_EDITOR_CONFIG_PASS")
    quit(0)
