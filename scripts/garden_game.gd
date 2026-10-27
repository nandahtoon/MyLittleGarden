extends Node2D
## Little Wonder Garden — small, offline Godot 4.x touchscreen MVP.
## Draws vector art in code: no copyrighted game assets or external services.

const SaveStore = preload("res://scripts/save_store.gd")
const DESIGN_SIZE := Vector2(1280.0, 800.0)
const PLOT_START := Vector2(314.0, 181.0)
const PLOT_STEP := Vector2(237.0, 154.0)
const PLOT_SIZE := Vector2(202.0, 126.0)
const COLOR_SKY := Color("f0f9f4")
const COLOR_DARK := Color("294c43")
const COLOR_MUTED := Color("648278")
const COLOR_CREAM := Color("fffaf0")
const COLOR_GROUND := Color("e6f0d8")
const COLOR_GREEN := Color("63966d")
const COLOR_WATER := Color("87c8cf")

var plots: Array[int] = []
var screen := "welcome"
var selected_tool := "seed"
var sound_enabled := true
var breaks_enabled := true
var break_minutes := 10
var play_seconds := 0.0
var elapsed := 0.0
var message := "Choose a seed, then touch a garden bed."
var message_seconds := 0.0
var parent_pressing := false
var parent_press_seconds := 0.0
var last_drag_plot := -1
var reset_confirmation := false
var sound_nodes: Dictionary = {}
var pointer_down := false
var audio_files := {
    "seed": "res://assets/audio/seed.wav",
    "water": "res://assets/audio/water.wav",
    "bloom": "res://assets/audio/bloom.wav",
    "bird": "res://assets/audio/bird.wav"
}


func _ready() -> void:
    for _i in range(9):
        plots.append(0)
    var saved: Dictionary = SaveStore.load_data()
    if saved.has("plots") and saved["plots"] is Array:
        var existing: Array = saved["plots"]
        for i in range(mini(existing.size(), plots.size())):
            if existing[i] is int or existing[i] is float:
                plots[i] = clampi(int(existing[i]), 0, 3)
    sound_enabled = bool(saved.get("sound_enabled", true))
    breaks_enabled = bool(saved.get("break_enabled", true))
    break_minutes = clampi(int(saved.get("break_minutes", 10)), 5, 15)
    for key in audio_files.keys():
        var p := AudioStreamPlayer.new()
        p.name = "Sound_" + str(key)
        p.stream = load(audio_files[key])
        p.volume_db = -14.0
        add_child(p)
        sound_nodes[key] = p
    set_process(true)
    queue_redraw()


func _process(delta: float) -> void:
    elapsed += delta
    if screen == "garden":
        play_seconds += delta
        if breaks_enabled and play_seconds >= float(break_minutes * 60):
            play_seconds = 0.0
            screen = "rest"
            parent_pressing = false
        if parent_pressing:
            parent_press_seconds += delta
            if parent_press_seconds >= 2.5:
                screen = "parent"
                parent_pressing = false
                parent_press_seconds = 0.0
    if message_seconds > 0.0:
        message_seconds = maxf(0.0, message_seconds - delta)
    queue_redraw()


func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        var p: Vector2 = _design_point(event.position)
        if event.pressed:
            _press(p)
        else:
            _release(p)
    elif event is InputEventScreenDrag:
        _move_touch(_design_point(event.position))
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        var m: Vector2 = _design_point(event.position)
        if event.pressed:
            _press(m)
        else:
            _release(m)
    elif event is InputEventMouseMotion and pointer_down:
        _move_touch(_design_point(event.position))


func _design_point(raw: Vector2) -> Vector2:
    var window_size := get_viewport_rect().size
    var factor: float = minf(window_size.x / DESIGN_SIZE.x, window_size.y / DESIGN_SIZE.y)
    factor = maxf(factor, 0.001)
    var offset := (window_size - DESIGN_SIZE * factor) * 0.5
    return (raw - offset) / factor


func _press(p: Vector2) -> void:
    pointer_down = true
    last_drag_plot = -1
    if screen == "garden" and Rect2(1160, 22, 92, 82).has_point(p):
        parent_pressing = true
        parent_press_seconds = 0.0


func _move_touch(p: Vector2) -> void:
    if screen == "garden":
        if parent_pressing and not Rect2(1148, 15, 110, 99).has_point(p):
            parent_pressing = false
            parent_press_seconds = 0.0
        if not parent_pressing:
            var plot := _plot_at(p)
            if plot >= 0 and plot != last_drag_plot:
                _use_tool(plot)
                last_drag_plot = plot


func _release(p: Vector2) -> void:
    if not pointer_down:
        return
    pointer_down = false
    if parent_pressing:
        parent_pressing = false
        parent_press_seconds = 0.0
        return
    match screen:
        "welcome":
            if Rect2(422, 569, 436, 111).has_point(p):
                screen = "garden"
        "garden":
            if Rect2(40, 186, 190, 100).has_point(p):
                selected_tool = "seed"
                _notice("Touch a patch of soil to plant.")
            elif Rect2(40, 305, 190, 100).has_point(p):
                selected_tool = "water"
                _notice("Touch a seed or sprout to water.")
            elif Rect2(40, 424, 190, 100).has_point(p):
                sound_enabled = not sound_enabled
                _persist()
                _notice("Soft sound on." if sound_enabled else "Sound off.")
            elif Rect2(40, 543, 190, 100).has_point(p):
                play_seconds = 0.0
                screen = "rest"
            else:
                if p.distance_to(Vector2(1126, 527)) < 68.0:
                    _play("bird")
                    _notice("Listen! A little bird is nearby.")
                else:
                    var plot := _plot_at(p)
                    if plot >= 0 and plot != last_drag_plot:
                        _use_tool(plot)
        "rest":
            if Rect2(424, 554, 434, 103).has_point(p):
                play_seconds = 0.0
                screen = "garden"
        "parent":
            if Rect2(464, 555, 350, 89).has_point(p):
                screen = "garden"
                reset_confirmation = false
            elif Rect2(403, 231, 474, 69).has_point(p):
                sound_enabled = not sound_enabled
                _persist()
            elif Rect2(403, 314, 474, 69).has_point(p):
                breaks_enabled = not breaks_enabled
                _persist()
            elif Rect2(403, 397, 474, 69).has_point(p):
                break_minutes = 5 if break_minutes == 15 else break_minutes + 5
                _persist()
            elif Rect2(403, 480, 474, 55).has_point(p):
                if reset_confirmation:
                    for i in range(plots.size()):
                        plots[i] = 0
                    _persist()
                    reset_confirmation = false
                else:
                    reset_confirmation = true
    queue_redraw()


func _plot_at(p: Vector2) -> int:
    for i in range(9):
        var col := i % 3
        var row := i / 3
        var r := Rect2(PLOT_START + Vector2(float(col), float(row)) * PLOT_STEP, PLOT_SIZE)
        if r.has_point(p):
            return i
    return -1


func _use_tool(i: int) -> void:
    if selected_tool == "seed":
        if plots[i] == 0:
            plots[i] = 1
            _play("seed")
            _notice("A tiny seed is sleeping in the soil.")
            _persist()
        else:
            _notice("This little patch already has a plant.")
    else:
        if plots[i] == 0:
            _notice("Try planting a seed here first.")
        elif plots[i] < 3:
            plots[i] += 1
            _play("bloom" if plots[i] == 3 else "water")
            _notice("A flower says hello!" if plots[i] == 3 else "Look! A little sprout!")
            _persist()
        else:
            _play("water")
            _notice("Your flower likes the gentle rain.")
    queue_redraw()


func _play(sound: String) -> void:
    if sound_enabled and sound_nodes.has(sound):
        var player: AudioStreamPlayer = sound_nodes[sound]
        player.play()


func _persist() -> void:
    SaveStore.save_data(plots, sound_enabled, breaks_enabled, break_minutes)


func _notice(value: String) -> void:
    message = value
    message_seconds = 4.0


func _draw() -> void:
    var viewport_size := get_viewport_rect().size
    draw_rect(Rect2(Vector2.ZERO, viewport_size), COLOR_SKY)
    var factor: float = minf(viewport_size.x / DESIGN_SIZE.x, viewport_size.y / DESIGN_SIZE.y)
    var offset := (viewport_size - DESIGN_SIZE * factor) * 0.5
    draw_set_transform(offset, 0.0, Vector2(factor, factor))
    _paint_background()
    match screen:
        "welcome":
            _draw_welcome()
        "garden":
            _draw_garden()
        "rest":
            _draw_rest()
        "parent":
            _draw_parent()
    draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _rounded(r: Rect2, fill: Color, radius: float = 20.0) -> void:
    var pts := PackedVector2Array()
    var corners := [
        Vector2(r.end.x - radius, r.position.y + radius),
        Vector2(r.end.x - radius, r.end.y - radius),
        Vector2(r.position.x + radius, r.end.y - radius),
        Vector2(r.position.x + radius, r.position.y + radius)
    ]
    for j in range(4):
        for k in range(9):
            var angle: float = -PI / 2.0 + float(j) * PI / 2.0 + float(k) * PI / 16.0
            pts.append(corners[j] + Vector2(cos(angle), sin(angle)) * radius)
    draw_colored_polygon(pts, fill)


func _line(a: Vector2, b: Vector2, col: Color, thickness: float = 3.0) -> void:
    draw_line(a, b, col, thickness, true)


func _text(msg: String, pos: Vector2, size: int, color: Color = COLOR_DARK, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT, max_width: float = -1.0) -> void:
    var start := pos
    if max_width > 0.0 and align == HORIZONTAL_ALIGNMENT_CENTER:
        start.x -= max_width * 0.5
    elif max_width > 0.0 and align == HORIZONTAL_ALIGNMENT_RIGHT:
        start.x -= max_width
    draw_string(ThemeDB.fallback_font, start, msg, align, max_width, size, color)


func _cloud(c: Vector2, scale: float = 1.0) -> void:
    var color := Color("ffffff", 0.73)
    draw_circle(c + Vector2(-27, 2) * scale, 25 * scale, color)
    draw_circle(c + Vector2(0, -12) * scale, 33 * scale, color)
    draw_circle(c + Vector2(35, 2) * scale, 25 * scale, color)
    _rounded(Rect2(c + Vector2(-46, 1) * scale, Vector2(102, 26) * scale), color, 12 * scale)


func _paint_background() -> void:
    draw_rect(Rect2(0, 0, 1280, 800), COLOR_SKY)
    draw_circle(Vector2(1102, 112), 55, Color("ffedaf"))
    _cloud(Vector2(228, 123), 1.0)
    _cloud(Vector2(825, 90), 0.6)
    draw_colored_polygon(PackedVector2Array([Vector2(0, 505), Vector2(135, 450), Vector2(320, 502), Vector2(575, 439), Vector2(843, 515), Vector2(1091, 457), Vector2(1280, 494), Vector2(1280, 800), Vector2(0, 800)]), Color("deebce"))
    draw_colored_polygon(PackedVector2Array([Vector2(0, 635), Vector2(170, 586), Vector2(406, 652), Vector2(695, 603), Vector2(932, 657), Vector2(1280, 577), Vector2(1280, 800), Vector2(0, 800)]), COLOR_GROUND)
    for i in range(22):
        var x: float = float((i * 83 + 53) % 1240)
        var y: float = float(677 + (i * 37) % 85)
        draw_circle(Vector2(x, y), 3.0, Color("97bd85", 0.6))


func _draw_welcome() -> void:
    _rounded(Rect2(184, 115, 914, 588), Color("ffffff", 0.75), 51)
    _text("Little Wonder Garden", Vector2(640, 223), 56, COLOR_DARK, HORIZONTAL_ALIGNMENT_CENTER, 830)
    _text("A quiet little world to grow", Vector2(640, 272), 27, COLOR_MUTED, HORIZONTAL_ALIGNMENT_CENTER, 800)
    _draw_flower(Vector2(498, 455), 1.35, Color("f0a7b3"))
    _draw_flower(Vector2(642, 469), 1.65, Color("f5d49a"))
    _draw_flower(Vector2(786, 456), 1.30, Color("c6acdc"))
    _rounded(Rect2(422, 569, 436, 111), Color("467e5c"), 32)
    _text("Let's Play", Vector2(640, 639), 39, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 392)
    _text("Plant • Water • Wonder", Vector2(640, 741), 19, COLOR_MUTED, HORIZONTAL_ALIGNMENT_CENTER, 570)


func _draw_garden() -> void:
    _rounded(Rect2(24, 14, 1232, 106), Color("ffffff", 0.80), 34)
    _text("Little Wonder Garden", Vector2(65, 76), 35, COLOR_DARK)
    _text("Take your time. There is no wrong way to grow.", Vector2(67, 105), 18, COLOR_MUTED)
    _rounded(Rect2(1160, 22, 92, 82), Color("f2eee3"), 26)
    _draw_gear(Vector2(1206, 57))
    if parent_pressing:
        draw_arc(Vector2(1206, 57), 39, -PI/2, -PI/2 + TAU * minf(parent_press_seconds / 2.5, 1.0), 40, Color("4c8968"), 7.0, true)
    _rounded(Rect2(267, 146, 966, 562), Color("fffdf6", 0.89), 34)
    for i in range(9):
        _draw_plot(i)
    # Small pond, wholly decorative in this first MVP.
    draw_circle(Vector2(1126, 527), 71, Color("b6ddd7"))
    draw_circle(Vector2(1126, 527), 55, Color("8cc9cb"))
    draw_arc(Vector2(1119, 533), 29, 0, TAU, 32, Color("d9eff0"), 2.2, true)
    draw_circle(Vector2(1113, 516), 13, Color("6a9d75"))
    draw_circle(Vector2(1162, 545), 11, Color("86ad7a"))
    _draw_button(Rect2(40, 186, 190, 100), "Plant", "seed", selected_tool == "seed")
    _draw_button(Rect2(40, 305, 190, 100), "Water", "water", selected_tool == "water")
    _draw_button(Rect2(40, 424, 190, 100), "Sound on" if sound_enabled else "Sound off", "sound", false)
    _draw_button(Rect2(40, 543, 190, 100), "Rest", "rest", false)
    _rounded(Rect2(269, 720, 957, 59), Color("ffffff", 0.84), 23)
    _text(message if message_seconds > 0.0 else "Choose a tool, then touch the garden.", Vector2(300, 760), 25, COLOR_MUTED)
    _text("Hold for grown-ups", Vector2(1150, 123), 15, COLOR_MUTED, HORIZONTAL_ALIGNMENT_RIGHT, 254)


func _draw_plot(i: int) -> void:
    var col := i % 3
    var row := i / 3
    var top := PLOT_START + Vector2(float(col), float(row)) * PLOT_STEP
    var center := top + Vector2(101, 73)
    _rounded(Rect2(top + Vector2(1, 8), PLOT_SIZE), Color("e9e5d5"), 25)
    _rounded(Rect2(top, PLOT_SIZE), Color("e6c8a4"), 26)
    _rounded(Rect2(top + Vector2(12, 10), PLOT_SIZE - Vector2(24, 26)), Color("bb916d"), 23)
    for s in range(5):
        var gx := top.x + 36 + float(s * 31)
        var gy := top.y + 53 + float((s * 17 + i * 3) % 39)
        draw_circle(Vector2(gx, gy), 2.0, Color("d5b696"))
    var phase: float = sin(elapsed * 0.7 + float(i) * 0.8) * 1.7
    if plots[i] == 1:
        draw_circle(center + Vector2(0, 15), 10, Color("826043"))
        draw_circle(center + Vector2(-3, 12), 3, Color("dfbd8b"))
    elif plots[i] == 2:
        _draw_sprout(center + Vector2(phase, 10))
    elif plots[i] == 3:
        var petals := [Color("edb5bd"), Color("f4d488"), Color("b6addd"), Color("f3c8ac"), Color("a6cebd")]
        _draw_flower(center + Vector2(phase, 9), 0.78, petals[i % petals.size()])
    else:
        _line(center + Vector2(-18, 17), center + Vector2(-12, 9), Color("7da56b"), 3)
        _line(center + Vector2(13, 16), center + Vector2(21, 10), Color("7da56b"), 3)


func _draw_sprout(c: Vector2) -> void:
    _line(c + Vector2(0, 26), c + Vector2(0, -12), Color("4c885c"), 7)
    draw_colored_polygon(PackedVector2Array([c + Vector2(-1, 6), c + Vector2(-29, -7), c + Vector2(-22, 14)]), Color("7fb78b"))
    draw_colored_polygon(PackedVector2Array([c + Vector2(1, -3), c + Vector2(28, -17), c + Vector2(19, 5)]), Color("6da97a"))
    draw_circle(c + Vector2(0, -15), 7, Color("a4ca8a"))


func _draw_flower(c: Vector2, scale: float, petal_color: Color) -> void:
    var bottom := c + Vector2(0, 35) * scale
    var head := c + Vector2(0, -37) * scale
    _line(bottom, head, Color("4a875b"), 7 * scale)
    draw_colored_polygon(PackedVector2Array([c + Vector2(-2, 14) * scale, c + Vector2(-33, -2) * scale, c + Vector2(-23, 19) * scale]), Color("86b88c"))
    draw_colored_polygon(PackedVector2Array([c + Vector2(2, -5) * scale, c + Vector2(30, -18) * scale, c + Vector2(26, 7) * scale]), Color("79ac7a"))
    for j in range(6):
        var a := TAU * float(j) / 6.0
        draw_circle(head + Vector2(cos(a), sin(a)) * (19 * scale), 15 * scale, petal_color)
    draw_circle(head, 15 * scale, Color("f5d685"))
    draw_circle(head + Vector2(-4, -4) * scale, 3.2 * scale, Color("fff1bd"))


func _draw_button(rect: Rect2, label: String, kind: String, active: bool) -> void:
    _rounded(Rect2(rect.position + Vector2(0, 5), rect.size), Color("dce6db"), 24)
    _rounded(rect, Color("d1e9d6") if active else Color("ffffff", 0.92), 24)
    if active:
        _rounded(Rect2(rect.position + Vector2(7, 8), Vector2(7, rect.size.y - 16)), Color("559a70"), 3)
    var p := rect.position + Vector2(51, 50)
    match kind:
        "seed":
            draw_circle(p, 17, Color("9f7652"))
            draw_circle(p + Vector2(-5, -5), 5, Color("cfaa85"))
            _line(p + Vector2(9, -14), p + Vector2(16, -23), Color("619b67"), 4)
        "water":
            _rounded(Rect2(p + Vector2(-17, -12), Vector2(29, 28)), COLOR_WATER, 6)
            _line(p + Vector2(9, -12), p + Vector2(27, -21), COLOR_WATER, 6)
            draw_arc(p + Vector2(15, 3), 13, -PI/2, PI/2, 16, COLOR_WATER, 5, true)
        "sound":
            draw_colored_polygon(PackedVector2Array([p + Vector2(-19, -8), p + Vector2(-8, -8), p + Vector2(5, -19), p + Vector2(5, 18), p + Vector2(-8, 8), p + Vector2(-19, 8)]), COLOR_GREEN)
            if sound_enabled:
                draw_arc(p + Vector2(5, 0), 19, -PI/3, PI/3, 18, COLOR_GREEN, 3, true)
            else:
                _line(p + Vector2(15, -17), p + Vector2(26, 14), Color("c48b7d"), 4)
        "rest":
            draw_circle(p, 22, Color("e9cf94"))
            draw_circle(p + Vector2(12, -10), 20, Color.WHITE)
    _text(label, rect.position + Vector2(88, 62), 21, COLOR_DARK)


func _draw_gear(c: Vector2) -> void:
    draw_arc(c, 22, 0, TAU, 32, COLOR_MUTED, 7, true)
    draw_circle(c, 9, Color("f2eee3"))
    for i in range(8):
        var a: float = float(i) * TAU / 8.0
        _line(c + Vector2(cos(a), sin(a)) * 25, c + Vector2(cos(a), sin(a)) * 33, COLOR_MUTED, 6)


func _draw_rest() -> void:
    _rounded(Rect2(265, 127, 750, 585), Color("fffdf5", 0.94), 48)
    draw_circle(Vector2(643, 345), 93, Color("f4dfad"))
    draw_circle(Vector2(683, 307), 83, Color("fffdf5"))
    _text("A little garden rest", Vector2(640, 204), 43, COLOR_DARK, HORIZONTAL_ALIGNMENT_CENTER, 700)
    _text("Stretch, breathe, or look outside.", Vector2(640, 468), 30, COLOR_MUTED, HORIZONTAL_ALIGNMENT_CENTER, 700)
    _text("Your garden will be here when you return.", Vector2(640, 512), 23, COLOR_MUTED, HORIZONTAL_ALIGNMENT_CENTER, 700)
    _rounded(Rect2(424, 554, 434, 103), Color("467e5c"), 28)
    _text("Back to Garden", Vector2(640, 621), 34, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 420)


func _draw_parent() -> void:
    _rounded(Rect2(329, 119, 622, 571), Color("fffdf5"), 38)
    _text("Grown-up Corner", Vector2(640, 187), 43, COLOR_DARK, HORIZONTAL_ALIGNMENT_CENTER, 580)
    _text("Keep play gentle and comfortable.", Vector2(640, 215), 19, COLOR_MUTED, HORIZONTAL_ALIGNMENT_CENTER, 580)
    _parent_option(Rect2(403, 231, 474, 69), "Soft sound", "On" if sound_enabled else "Off")
    _parent_option(Rect2(403, 314, 474, 69), "Gentle break reminder", "On" if breaks_enabled else "Off")
    _parent_option(Rect2(403, 397, 474, 69), "Break reminder", str(break_minutes) + " min")
    _parent_option(Rect2(403, 480, 474, 55), "Clear saved garden", "Tap again" if reset_confirmation else "Reset")
    _rounded(Rect2(464, 555, 350, 89), Color("467e5c"), 25)
    _text("Done", Vector2(638, 612), 32, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 325)


func _parent_option(r: Rect2, title: String, value: String) -> void:
    _rounded(r, Color("e8f2e7"), 17)
    _text(title, r.position + Vector2(24, r.size.y / 2 + 9), 22, COLOR_DARK)
    _text(value, r.position + Vector2(r.size.x - 25, r.size.y / 2 + 9), 21, COLOR_MUTED, HORIZONTAL_ALIGNMENT_RIGHT, 140)
