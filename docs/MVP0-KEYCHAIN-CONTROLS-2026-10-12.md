# Scalfagus MVP0 — Keychain-integrated RTS controls

Status: **code implemented; Godot 4.7.2 runtime checks NOT RUN in this environment**.
Scope: DEC-033 (MAN mirror RTS), DEC-034 (Reuse First).
GitHub Actions are broken before allocation of a runner; rely on real local
Godot tests and manual play instead of CI badges.

## Reused instead of rebuilt

- Godot `InputMap`, `InputEventKey`, `Input.get_axis` and
  `InputEvent.is_action_pressed` are the sole runtime input dispatch mechanism.
- Existing vendored **Orama Interactive Keychain 2.1**, MIT.
  Reuse its `ShortcutEdit.tscn` directly in the main menu Options, including
  its profile selection, remapping UI, conflict feedback and persistence to
  `user://shortcut_profiles`. No substitute keybinding editor or profile
  persistence system was written.
- Keychain's upstream editor plugin only registers the `Keychain` autoload.
  Scalfagus now declares this autoload directly in `project.godot`, enabling
  profiles on the **first native game launch**, even without opening the Godot
  editor first. The duplicate editor registration for Keychain is disabled.
  RTS Framework, State Charts and GUT editor plugins remain enabled.

## Default RTS controls

| Action | Default physical key |
|---|---|
| Camera pan up/down/left/right | W / S / A / D |
| Barracks construction placement | B |
| Train MAN Worker at HQ | **T** (changed from conflicting W) |
| Train MAN Rifleman at Barracks | R |
| Pause/resume C-C spectator | P |
| Simulation faster/slower | = / - |
| Escape / back / cancel construction | Esc (reserved, not rebindable in this slice) |
| Select and issue context orders | Mouse buttons (unchanged, fixed this slice) |
| Camera zoom | Mouse wheel (unchanged, fixed this slice) |

Keychain owns action profile persistence; `mirror_view.gd` knows only the
**logical action IDs**. Human commands still call
`MirrorMatchState.issue_command` so hotkeys never bypass authoritative
ownership, cost or fog validation.

## Integration and acceptance checks

New `apps/game/tests/keychain_rts_smoke.gd` is invoked by local
`scripts/check.sh`. It verifies:

1. Keychain's real runtime autoload and selected profile exist;
2. all ten RTS actions and default physical-key codes are registered;
3. Options embeds the vendored `ShortcutEdit.tscn` scene;
4. `W` doesn't accidentally train Workers, but `T` calls the legal train API;
5. an in-memory remap `T → Y` changes the accepted Worker command without
   modifying code or vendor files;
6. panning uses the action axis and is not hardcoded to `KEY_W`.

It does **not** overwrite saved user profiles or write test shortcuts to user://.
Actual editor interaction, persistence across separate app launches, gamepad
support, group keybind contexts, accessibility and exported builds require
manual validation before release. The legacy prototype camera is preserved.

## Run without GitHub Actions

```sh
cd ~/GitHub/scalfagus
git pull
bash scripts/check.sh
bash scripts/dev.sh --editor
```

Menu → Options → Keychain shortcut editor; select a customizable profile and
change a binding. Start MAN vs BOT and verify the same binding controls the
in-game action.

Upstream: https://github.com/Orama-Interactive/Keychain (MIT).
Godot APIs: https://docs.godotengine.org/en/stable/classes/class_inputmap.html
and https://docs.godotengine.org/en/stable/classes/class_inputeventkey.html
