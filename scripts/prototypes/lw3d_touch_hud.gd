extends Control
## LW3D-T1 touch HUD. Drawn in Godot, not an image mockup.
## The same interaction can be tested with mouse/keyboard on desktop.
## Joypad is forgiving, supports independent fingers for move and buttons.

const JOY_RADIUS := 92.0
var _move_finger := -1
var _move_vector := Vector2.ZERO
var _jump_requested := false
var _action_requested := false
var _rest_requested := false
var _home_requested := false
var resting := false
var hint := "Explore the garden. Find the gold beacon!"


func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    set_process(true)


func _process(_delta: float) -> void:
    queue_redraw()


func movement_vector() -> Vector2:
    return _move_vector


func take_jump() -> bool:
    var requested := _jump_requested
    _jump_requested = false
    return requested


func take_action() -> bool:
    var requested := _action_requested
    _action_requested = false
    return requested


func take_rest() -> bool:
    var requested := _rest_requested
    _rest_requested = false
    return requested


func take_home() -> bool:
    var requested := _home_requested
    _home_requested = false
    return requested


func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        var touch := event as InputEventScreenTouch
        _touch(touch.index, touch.position, touch.pressed)
    elif event is InputEventScreenDrag:
        var drag := event as InputEventScreenDrag
        if drag.index == _move_finger:
            _move_vector = ((drag.position - _joy_center()) / JOY_RADIUS).limit_length(1.0)
    elif event is InputEventMouseButton:
        var mouse := event as InputEventMouseButton
        if mouse.button_index == MOUSE_BUTTON_LEFT:
            _touch(1000, mouse.position, mouse.pressed)
    elif event is InputEventMouseMotion and _move_finger == 1000:
        var motion := event as InputEventMouseMotion
        _move_vector = ((motion.position - _joy_center()) / JOY_RADIUS).limit_length(1.0)


func _touch(finger: int, point: Vector2, pressed: bool) -> void:
    if not pressed:
        if finger == _move_finger:
            _move_finger = -1
            _move_vector = Vector2.ZERO
        return

    if point.distance_to(_home_center()) < 84.0:
        _home_requested = true
    elif point.distance_to(_rest_center()) < 84.0:
        _rest_requested = true
    elif resting:
        return
    elif point.distance_to(_joy_center()) < JOY_RADIUS + 45.0 and _move_finger < 0:
        _move_finger = finger
        _move_vector = ((point - _joy_center()) / JOY_RADIUS).limit_length(1.0)
    elif point.distance_to(_jump_center()) < 88.0:
        _jump_requested = true
    elif point.distance_to(_action_center()) < 88.0:
        _action_requested = true


func _joy_center() -> Vector2:
    return Vector2(145.0, size.y - 151.0)


func _jump_center() -> Vector2:
    return Vector2(size.x - 142.0, size.y - 154.0)


func _action_center() -> Vector2:
    return Vector2(size.x - 315.0, size.y - 143.0)


func _home_center() -> Vector2:
    return Vector2(112.0, 74.0)


func _rest_center() -> Vector2:
    return Vector2(size.x - 112.0, 74.0)


func _draw() -> void:
    var white := Color("#FFFDF4")
    var ink := Color("#24576A")
    draw_rect(Rect2(Vector2(0.0, 0.0), Vector2(size.x, 98.0)), Color(0.07, 0.24, 0.26, 0.32))
    _button(_home_center(), 65.0, "GARDEN", Color("#E8F4D6"), ink)
    _button(_rest_center(), 65.0, "REST", Color("#FFDBA1"), ink)
    _text(hint, Vector2(size.x * 0.5, 67.0), 24, white, HORIZONTAL_ALIGNMENT_CENTER)

    draw_circle(_joy_center(), JOY_RADIUS + 9.0, Color(0.05, 0.28, 0.34, 0.45))
    draw_circle(_joy_center(), JOY_RADIUS, Color("#DEFAF2", 0.72))
    draw_circle(_joy_center() + _move_vector * 47.0, 38.0, Color("#66B8C8", 0.94))
    _text("MOVE", _joy_center() + Vector2(0.0, 9.0), 19, ink, HORIZONTAL_ALIGNMENT_CENTER)
    _button(_action_center(), 71.0, "LOOK", Color("#F8DD79"), ink)
    _button(_jump_center(), 71.0, "JUMP", Color("#CBEDEC"), ink)

    if resting:
        draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.21, 0.25, 0.78))
        _text("TIME FOR A LITTLE REST", Vector2(size.x * 0.5, size.y * 0.42), 38, white, HORIZONTAL_ALIGNMENT_CENTER)
        _text("Tap REST to continue, or GARDEN to leave.", Vector2(size.x * 0.5, size.y * 0.5), 22, white, HORIZONTAL_ALIGNMENT_CENTER)
        _button(_home_center(), 65.0, "GARDEN", Color("#E8F4D6"), ink)
        _button(_rest_center(), 65.0, "REST", Color("#FFDBA1"), ink)


func _button(center: Vector2, radius: float, label: String, fill: Color, ink: Color) -> void:
    draw_circle(center + Vector2(0, 5), radius, Color(0.02, 0.17, 0.21, 0.24))
    draw_circle(center, radius, fill)
    _text(label, center + Vector2(0.0, 8.0), 19, ink, HORIZONTAL_ALIGNMENT_CENTER)


func _text(label: String, at: Vector2, font_size: int, color: Color, alignment: HorizontalAlignment) -> void:
    var width := 900.0 if alignment == HORIZONTAL_ALIGNMENT_CENTER else -1.0
    var left := at - Vector2(width * 0.5, 0.0) if alignment == HORIZONTAL_ALIGNMENT_CENTER else at
    draw_string(ThemeDB.fallback_font, left, label, alignment, width, font_size, color)
