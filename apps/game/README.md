# Scalfagus native Godot project

Open `project.godot` with Godot 4.7.2 Standard. [Development setup and commands](../../docs/GODOT-DEVELOPMENT.md) are the current entrypoint.

The default menu starts the DEC-033 MAN-vs-MAN RTS mirror: Human-Bot or Bot-Bot. The match uses the compiled Verdant Divide map, finite Matter mining/transport, construction, production, ownership, group orders and completed-building victory. LAN Human-Human remains a required unfinished release gate. The separate legacy camera scene is a debug prototype.

Pinned addons: RTS Framework, Keychain, State Charts and GUT. Setup installs/imports them and configures the GUT bottom panel. `bash scripts/dev-tools.sh test` runs the automated suite; GUI behavior and target runtime tests require separate evidence.

The native RTS uses W/A/S/D camera movement, T Worker training, R Rifleman training, B Barracks building and remappable Keychain actions. Inspect Options for current bindings. Three-camera controls belong to the legacy debug scene.

Atlases are provisional artwork; five-view mapping tests do not certify all rotation/mirroring art. Physics LOS is diagnostic while fixed-tick match state resolves combat. See current QA reports for known runtime and release gaps.
