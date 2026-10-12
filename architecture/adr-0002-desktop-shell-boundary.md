# ADR-0002 — Retired desktop shell

Status: superseded by DEC-034 and the Godot-only architecture.

Scalfagus has one native Godot runtime and built-in Control UI. There is no Tauri/Electron wrapper, browser UI client, IPC bridge or Studio launcher to implement. The earlier shell proposal is retained in Git history, not as active setup instructions.

Use [native development setup](../docs/GODOT-DEVELOPMENT.md) and [ADR-0004](adr-0004-godot-reuse-first-wrappers.md). Godot Web export remains a supported native engine target; offline Node asset and Python map tooling do not run the game.
