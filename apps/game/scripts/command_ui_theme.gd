extends RefCounted

static func panel(color: Color = Color("#101e2c")) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = color
    style.border_color = Color("#3c5968")
    style.set_border_width_all(1)
    style.set_corner_radius_all(6)
    style.content_margin_left = 16
    style.content_margin_right = 16
    style.content_margin_top = 12
    style.content_margin_bottom = 12
    return style

static func create() -> Theme:
    var theme := Theme.new()
    theme.default_font_size = 16
    theme.set_color("font_color", "Label", Color("#dce9ed"))
    theme.set_color("font_color", "Button", Color("#dce9ed"))
    theme.set_stylebox("panel", "PanelContainer", panel())
    theme.set_stylebox("normal", "Button", panel(Color("#192d3a")))
    theme.set_stylebox("hover", "Button", panel(Color("#294957")))
    theme.set_stylebox("pressed", "Button", panel(Color("#305865")))
    theme.set_stylebox("disabled", "Button", panel(Color("#15202a")))
    var focus := panel(Color.TRANSPARENT)
    focus.border_color = Color("#edbe79")
    focus.set_border_width_all(2)
    theme.set_stylebox("focus", "Button", focus)
    return theme

static func label(text: String, font_size: int = 16) -> Label:
    var node := Label.new()
    node.text = text
    node.add_theme_font_size_override("font_size", font_size)
    node.mouse_filter = Control.MOUSE_FILTER_IGNORE
    return node
