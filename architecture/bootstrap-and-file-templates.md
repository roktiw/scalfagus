# Godot-native bootstrap and file templates

The current development setup is documented in [Godot development](../docs/GODOT-DEVELOPMENT.md). Run `bash scripts/dev-tools.sh setup --templates`, then `doctor`, `editor` or `test`.

Create gameplay scripts and scenes in `apps/game`, regression tests in `apps/game/tests/gut`, smoke tests in `apps/game/tests`, and reports in `docs/qa/reports`. Use native Godot APIs and pinned adapters under DEC-034. Node/Python are offline asset/map tools only.

The former React/Vite Studio and Tauri boilerplate has been retired. Its historical text remains in Git history and does not define an implementation backlog. No separate browser client or shell is part of Scalfagus.
