extends "res://scripts/prototypes/lw3d_touch_hud.gd"
## LW3D-U1: responsive, child-facing Rainbow Forest HUD.
## Keeps the T1 public take_* and _touch APIs so integration and synthetic QA remain compatible.
## No persistent UI settings, no accounts, analytics or child tracking.

const DESIGN_SIZE := Vector2(1280.0, 800.0)
const JOYSTICK_RANGE := 91.0

var context_action: String = "LOOK"
var goal: String = "Help the rainbow bridge"
var help_open := false
var _active_touches: Dictionary = {}


func _ui_scale() -> float:
    if size.x <= 1.0 or size.y <= 1.0:
        return 1.0
    return clampf(minf(size.x / DESIGN_SIZE.x, size.y / DESIGN_SIZE.y), 0.38, 1.40)


func _joy_center() -> Vector2:
    var s := _ui_scale()
    return Vector2(158.0 * s, size.y - 144.0 * s)


func _jump_center() -> Vector2:
    var s := _ui_scale()
    return Vector2(size.x - 143.0 * s, size.y - 143.0 * s)


func _action_center() -> Vector2:
    var s := _ui_scale()
    return Vector2(size.x - 322.0 * s, size.y - 143.0 * s)


func _home_center() -> Vector2:
    var s := _ui_scale()
    return Vector2(93.0 * s, 80.0 * s)


func _rest_center() -> Vector2:
    var s := _ui_scale()
    return Vector2(size.x - 93.0 * s, 80.0 * s)


func _help_center() -> Vector2:
    var s := _ui_scale()
    return Vector2(size.x * 0.5, size.y - 86.0 * s)


func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        var touch := event as InputEventScreenTouch
        _touch(touch.index, touch.position, touch.pressed)
    elif event is InputEventScreenDrag:
        var drag := event as InputEventScreenDrag
        if drag.index == _move_finger:
            _update_stick(drag.position)
    elif event is InputEventMouseButton:
        var button := event as InputEventMouseButton
        if button.button_index == MOUSE_BUTTON_LEFT:
            _touch(1000, button.position, button.pressed)
    elif event is InputEventMouseMotion and _move_finger == 1000:
        _update_stick((event as InputEventMouseMotion).position)


func _touch(finger: int, point: Vector2, pressed: bool) -> void:
    var s := _ui_scale()
    if not pressed:
        _active_touches.erase(finger)
        if _move_finger == finger:
            _move_finger = -1
            _move_vector = Vector2.ZERO
        queue_redraw()
        return

    # A tap or synthetic touch press is one event; repeated press IDs are ignored.
    if _active_touches.has(finger):
        return
    _active_touches[finger] = true

    if point.distance_to(_rest_center()) <= 69.0 * s:
        _cancel_stick()
        _rest_requested = true
        queue_redraw()
        return
    if point.distance_to(_home_center()) <= 69.0 * s:
        _cancel_stick()
        _home_requested = true
        queue_redraw()
        return
    if resting:
        return
    if point.distance_to(_help_center()) <= 72.0 * s:
        help_open = not help_open
    elif point.distance_to(_joy_center()) <= 135.0 * s and _move_finger < 0:
        _move_finger = finger
        _update_stick(point)
    elif point.distance_to(_jump_center()) <= 84.0 * s:
        _jump_requested = true
    elif point.distance_to(_action_center()) <= 84.0 * s:
        _action_requested = true
    queue_redraw()


func _update_stick(point: Vector2) -> void:
    _move_vector = ((point - _joy_center()) / (JOYSTICK_RANGE * _ui_scale())).limit_length(1.0)
    queue_redraw()


func _cancel_stick() -> void:
    _move_vector = Vector2.ZERO
    _move_finger = -1
    _active_touches.clear()


func _notification(what: int) -> void:
    if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
        _cancel_stick()


func _draw() -> void:
    var s := _ui_scale()
    var white := Color("#FFFDF5")
    var ink := Color("#234E60")
    var mid := size.x * 0.5
    var bg := Color(0.06, 0.19, 0.24, 0.66)

    # Clear center objective and hint; no long overlapping sentence on the edges.
    draw_rect(Rect2(Vector2(176.0 * s, 22.0 * s), Vector2(maxf(180.0, size.x - 352.0 * s), 116.0 * s)), bg, true)
    _center_text(goal, mid, 54.0 * s, size.x - 380.0 * s, 25, Color("#FFF3B9"), s)
    if help_open:
        _center_text("MATCH TRIANGLE   OR   PLANT + WATER", mid, 96.0 * s, size.x - 380.0 * s, 21, white, s)
    else:
        _center_text(hint, mid, 100.0 * s, size.x - 380.0 * s, 19, white, s)

    _button(_home_center(), 61.0 * s, "HOME", Color("#EFF7E6"), ink, 18, s)
    _button(_rest_center(), 61.0 * s, "REST", Color("#FFE2AC"), ink, 18, s)

    # Touch-friendly joystick and two primary actions.
    draw_circle(_joy_center(), 106.0 * s, Color(0.06, 0.29, 0.35, 0.49))
    draw_circle(_joy_center(), 97.0 * s, Color("#E5F7ED", 0.82))
    draw_circle(_joy_center() + _move_vector * (48.0 * s), 42.0 * s, Color("#72C2D4"))
    _center_text("MOVE", _joy_center().x, _joy_center().y + 8.0 * s, 105.0 * s, 18, ink, s)

    _button(_action_center(), 71.0 * s, context_action, Color("#FFD981"), ink, 17, s)
    _button(_jump_center(), 71.0 * s, "JUMP", Color("#C6EFF0"), ink, 18, s)
    _button(_help_center(), 48.0 * s, "?", Color("#FCFAEF"), ink, 28, s)

    if resting:
        draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.17, 0.23, 0.84), true)
        _center_text("A LITTLE REST", mid, size.y * 0.43, size.x - 70.0 * s, 38, white, s)
        _center_text("Tap REST to play, or HOME to leave.", mid, size.y * 0.53, size.x - 70.0 * s, 24, white, s)
        _button(_home_center(), 61.0 * s, "HOME", Color("#EFF7E6"), ink, 18, s)
        _button(_rest_center(), 61.0 * s, "REST", Color("#FFE2AC"), ink, 18, s)


func _button(center: Vector2, radius: float, label: String, fill: Color, ink: Color, font_size: int, s: float) -> void:
    draw_circle(center + Vector2(0.0, 4.0 * s), radius, Color(0.02, 0.13, 0.17, 0.25))
    draw_circle(center, radius, fill)
    _center_text(label, center.x, center.y + 7.0 * s, radius * 1.88, font_size, ink, s)


func _center_text(label: String, center_x: float, bottom_y: float, max_width: float, base_size: int, color: Color, s: float) -> void:
    if label.is_empty():
        return
    var font := ThemeDB.fallback_font
    var font_size := maxi(11, int(round(float(base_size) * s)))
    while font_size > 11 and font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > max_width:
        font_size -= 1
    draw_string(font, Vector2(center_x - max_width * 0.5, bottom_y), label, HORIZONTAL_ALIGNMENT_CENTER, max_width, font_size, color)
