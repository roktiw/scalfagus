# Scalfagus — full viewport and clickable single-player menu

**2026-10-12.** Focus: **one human vs bot**. Human–Human LAN work is parked
by owner request; PR #18 is not merged as part of this change.

## Problem and evidence

User reports that both Godot Editor Play and standalone launch show a small
centered game rectangle, and menu clicks do not activate any action.
Previous `menu_smoke.gd` **called menu functions directly**; it checked state
transitions but never delivered a mouse button event. Therefore previously
passing QA does *not* prove that a real mouse click works.

Two independent mechanisms must be checked:

1. **Godot embedded Game view.** Its Game bar uses **Fixed Size by default**,
   which centers an exact-size rectangle. This is an **editor setting**, not
   the game's scaling code. Open Godot editor → **Game** tab → top-right
   Game bar menu → embedded window size **Stretch to Fit** (or
   **Keep Aspect Ratio**). If you want a real OS window, disable
   **Embed Game on Next Play** and press F6/F5 again. Window-mode
   changes, including maximize and fullscreen, are not supported while
   the game is embedded.
2. **Standalone and menu UI.** Godot launch previously pinned a
   `1440×810` window override. Now both overrides are zero and
   `canvas_items` stretch uses `expand`. `menu.gd` detects
   `Engine.is_embedded_in_editor()`; for real non-headless standalone
   windows it starts in `Window.MODE_MAXIMIZED`.
   The entire menu background is anchored to the actual window,
   with `MOUSE_FILTER_IGNORE` so a fullscreen ColorRect cannot absorb
   pointer clicks; interactive buttons remain `MOUSE_FILTER_STOP`,
   focusable and show a pointing-hand cursor.
   Options are inside a responsive `ScrollContainer`, so the
   Keychain editor cannot force a large fixed-size canvas.

There is a keyboard fallback: **1** plays Human vs Bot; **2** watches
Bot vs Bot; **O** opens Options; **Escape** returns from Options.
The focused native `Button` should also activate with Enter/Space.

## Required real local validation

```sh
git fetch origin
git switch fix/mvp0-full-viewport-clickable-menu-20261012
bash scripts/check.sh
bash scripts/check-gut.sh
bash scripts/check-map.sh
bash scripts/dev.sh
```

`scripts/check.sh` includes **new**
`apps/game/tests/menu_pointer_smoke.gd`: Godot's native
`Viewport.push_input` delivers mouse motion / button down / button up
to the real onscreen OPTIONS, BACK and PLAY buttons; the test asserts
that Options opens and closes, then the actual `MirrorMatch` scene
starts with controllers **[`human`, `bot`]**. No direct menu
method calls substitute for this pointer acceptance.

**Manual macOS editor / standalone acceptance:**

- Editor embedded → change Game size to **Stretch to Fit**; resize editor
  and confirm menu background covers the entire Game viewport.
- Click PLAY MAN VS BOT. Must load map and game, not just give a
  hover/focus highlight; quit back with Esc.
- Click OPTIONS → edit a binding → BACK; verify mouse interaction,
  Escape handling and no overlay intercept.
- Turn embedding off, play in OS standalone window: it should open
  maximized, and background/render fill the client area.
- Manually change window resolution or toggle fullscreen in Options;
  confirm no fixed inset and correctly translated cursor coordinates.
- Try the keyboard fallback 1/2/O and the focused Button with Enter.
- Only after menu works attempt one-player gameplay:
  Worker → mine → HQ → Barracks → Rifleman → attack → outcome,
  plus Keychain remap/restart. Mark failures with screenshots and logs.
- Use a clean `--path apps/game` launch; record exact version
  `Godot 4.7.2.stable`, whether Game embedding is enabled,
  size policy and macOS display scaling.

## Scope and proof limitations

The source patch and new regression **have not run in this agent
environment** (there is no local Godot binary). Do not call GUI PASS
until Mac local agent returns `SCALFAGUS_MENU_POINTER_PASS` and
manual real-click test. `Viewport.push_input` proves native Control
routing when run, but **cannot guarantee** that an external desktop
automation tool delivers physical events into an embedded Godot
window. In that case use the Game bar or disable embedding.

Leave PR #18 network infrastructure as an unmerged draft, and do
not progress ENet while current user priority is one-player UX.

References: official Godot "Game embedding" documentation, and
"Multiple resolutions" (Canvas Items/Expand).
