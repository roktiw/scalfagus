extends SceneTree

# Local Godot import smoke: validates enabled editor plugin manifests,
# script entrypoints and retained upstream notices. Does not claim the
# plugins have passed GUI-level interaction tests.
const EXPECTED: Array[String] = [
    "res://addons/rts_framework/plugin.cfg",
    "res://addons/godot_state_charts/plugin.cfg",
    "res://addons/gut/plugin.cfg",
]

func _initialize() -> void:
    call_deferred("_verify")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_ADDONS_FAIL " + message)
    quit(1)

func _verify() -> void:
    var active: PackedStringArray = ProjectSettings.get_setting(
        "editor_plugins/enabled", PackedStringArray()
    )
    for path in EXPECTED:
        if not active.has(path):
            _fail("Not enabled: " + path)
            return
        if not FileAccess.file_exists(path):
            _fail("Plugin not installed: " + path)
            return
        var manifest := ConfigFile.new()
        if manifest.load(path) != OK:
            _fail("Invalid plugin manifest: " + path)
            return
        var entry: String = str(manifest.get_value("plugin", "script", ""))
        if entry.is_empty():
            _fail("Missing plugin entrypoint: " + path)
            return
        var script_path: String = path.get_base_dir().path_join(entry)
        if not FileAccess.file_exists(script_path):
            _fail("Missing plugin GDScript: " + script_path)
            return

    # Keychain is an explicit runtime singleton instead of an editor-managed
    # autoload. Its upstream editor plugin only registers/removes that singleton.
    if not ProjectSettings.has_setting("autoload/Keychain"):
        _fail("Keychain runtime autoload is missing")
        return
    var runtime_path: String = str(ProjectSettings.get_setting("autoload/Keychain"))
    if not runtime_path.ends_with("res://addons/keychain/Keychain.gd"):
        _fail("Keychain autoload points to unexpected source")
        return
    if get_node_or_null("/root/Keychain") == null:
        _fail("Keychain runtime singleton not constructed")
        return
    if not FileAccess.file_exists("res://addons/keychain/plugin.cfg"):
        _fail("Keychain vendor manifest missing")
        return

    for license_file in [
        "res://addons/keychain/LICENSE",
        "res://addons/rts_framework/LICENSE",
        "res://addons/godot_state_charts/LICENSE",
        "res://addons/gut/LICENSE.md"
    ]:
        if not FileAccess.file_exists(license_file):
            _fail("Missing legal notice: " + license_file)
            return

    print("SCALFAGUS_ADDONS_SMOKE_PASS")
    quit(0)
