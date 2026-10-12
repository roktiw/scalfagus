# Scalfagus development stack — current scope

One Godot 4.7.2 Standard project with GDScript, native Control UI, engine physics/navigation and pinned addons. See [development setup](../docs/GODOT-DEVELOPMENT.md), [reuse boundaries](adr-0004-godot-reuse-first-wrappers.md) and DEC-033/034.

Offline Node scripts validate sprite atlases; Python/PyYAML compiles the canonical Verdant source into checked-in JSON. Neither is a game runtime. The old TypeScript-first Studio/Tauri architecture in this file is retired and available in Git history for historical research only.

Daily tools: Godot scene editor, debugger, profiler, GUT panel and repository shell commands. Optional VS Code tasks invoke the same commands. Authoritative match state stays in Godot; no duplicate simulation, HTML menu or WebView bridge is supported.
