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
const FLOWER_ART := ["cosmos", "sunflower", "tulip", "daisy", "poppy", "bluebell"]

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
var plant_art: Dictionary = {}
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
    for art_name in ["seed", "sprout", "cosmos", "sunflower", "tulip", "daisy", "poppy", "bluebell"]:
        var image: Texture2D = load("res://assets/art/" + art_name + ".svg") as Texture2D
        if image != null:
            plant_art[art_name] = image
        else:
            push_warning("Missing plant art: " + art_name)
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
    # Original pastel storybook landscape; slow shapes, no flashing effects.
    draw_rect(Rect2(0, 0, 1280, 800), Color("e9f7f1"))
    draw_circle(Vector2(1093, 104), 84, Color("fff6d9", 0.72))
    draw_circle(Vector2(1093, 104), 51, Color("ffe7aa", 0.75))
    _cloud(Vector2(217, 112), 1.23)
    _cloud(Vector2(810, 83), 0.79)
    _cloud(Vector2(1071, 228), 0.50)
    draw_colored_polygon(PackedVector2Array([
        Vector2(0, 481), Vector2(139, 440), Vector2(291, 496), Vector2(470, 444),
        Vector2(659, 482), Vector2(820, 439), Vector2(1017, 489),
        Vector2(1169, 432), Vector2(1280, 469), Vector2(1280, 800), Vector2(0, 800)
    ]), Color("dcefdc"))
    draw_colored_polygon(PackedVector2Array([
        Vector2(0, 615), Vector2(151, 564), Vector2(352, 631), Vector2(615, 573),
        Vector2(822, 631), Vector2(1068, 576), Vector2(1280, 609),
        Vector2(1280, 800), Vector2(0, 800)
    ]), Color("cbe5c7"))
    # Quiet grassy details, without scoring or reward decoration.
    for j in range(26):
        var p := Vector2(float((j * 83 + 37) % 1280), float(665 + (j * 31) % 115))
        draw_line(p, p + Vector2(-5, -12), Color("82b68c", 0.66), 3, true)
        draw_line(p, p + Vector2(5, -9), Color("93c49b", 0.63), 3, true)
        if j % 4 == 0:
            draw_circle(p + Vector2(1, -13), 5, Color("fff5d9", 0.94))
            draw_circle(p + Vector2(1, -13), 2.2, Color("e4bc74"))


func _draw_welcome() -> void:
    _rounded(Rect2(188, 125, 908, 574), Color("7ca28c", 0.16), 48)
    _rounded(Rect2(180, 114, 908, 574), Color("fffdf5", 0.96), 48)
    _rounded(Rect2(220, 147, 827, 52), Color("ecf6e9"), 24)
    _text("A LITTLE PLACE TO GROW", Vector2(635, 181), 19, Color("648b72"), HORIZONTAL_ALIGNMENT_CENTER, 780)
    _text("Little Wonder", Vector2(636, 256), 57, Color("315e49"), HORIZONTAL_ALIGNMENT_CENTER, 840)
    _text("Garden", Vector2(636, 319), 64, Color("457953"), HORIZONTAL_ALIGNMENT_CENTER, 840)
    _text("Plant a seed. Watch something lovely grow.", Vector2(636, 360), 24, Color("6b8872"), HORIZONTAL_ALIGNMENT_CENTER, 830)
    _draw_plant_art("tulip", Rect2(327, 361, 162, 175))
    _draw_plant_art("sunflower", Rect2(544, 357, 178, 188))
    _draw_plant_art("cosmos", Rect2(779, 362, 157, 176))
    _rounded(Rect2(424, 572, 436, 111), Color("294e3e", 0.22), 32)
    _rounded(Rect2(422, 565, 436, 111), Color("417957"), 32)
    _text("Let's play!", Vector2(640, 635), 38, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 390)
    _text("No rush. No wrong answers.", Vector2(640, 734), 21, Color("507d63"), HORIZONTAL_ALIGNMENT_CENTER, 630)


func _draw_garden() -> void:
    # Clear hierarchy: garden first, four tools at left, grown-up corner tucked away.
    _rounded(Rect2(24, 20, 1232, 110), Color("7b9d81", 0.14), 29)
    _rounded(Rect2(24, 14, 1232, 110), Color("fffdf6", 0.96), 29)
    draw_circle(Vector2(72, 72), 24, Color("dbeedc"))
    draw_circle(Vector2(64, 69), 9, Color("7eb68a"))
    draw_circle(Vector2(78, 61), 9, Color("94c39b"))
    draw_circle(Vector2(78, 79), 9, Color("77aa7c"))
    _text("My Little Garden", Vector2(112, 72), 37, Color("315b48"))
    _text("Every little flower grows in its own time.", Vector2(112, 103), 20, Color("6f8d78"))
    _rounded(Rect2(1160, 22, 92, 82), Color("e7efe3"), 24)
    _draw_gear(Vector2(1206, 57))
    if parent_pressing:
        draw_arc(Vector2(1206, 57), 39, -PI/2, -PI/2 + TAU * minf(parent_press_seconds / 2.5, 1.0), 40, Color("4c8968"), 7.0, true)
    _rounded(Rect2(266, 153, 968, 562), Color("6f916e", 0.17), 33)
    _rounded(Rect2(266, 146, 968, 562), Color("fffaf0", 0.96), 33)
    _rounded(Rect2(282, 163, 930, 527), Color("f1f6df"), 28)
    for j in range(15):
        var gx := float(319 + ((j * 131) % 760))
        var gy := float(190 + ((j * 77) % 458))
        draw_circle(Vector2(gx, gy), 4, Color("c4d9ad", 0.45))
    for i in range(9):
        _draw_plot(i)
    # Gentle interactive pond. Ripples oscillate only a few pixels.
    draw_circle(Vector2(1126, 531), 74, Color("a5cbbb"))
    draw_circle(Vector2(1126, 526), 68, Color("b8e1df"))
    draw_circle(Vector2(1126, 526), 55, Color("8bcbd0"))
    var ripple := sin(elapsed * 0.5) * 2.0
    draw_arc(Vector2(1121, 527), 28 + ripple, 0, TAU, 40, Color("d8f3ee", 0.68), 2.4, true)
    draw_circle(Vector2(1102, 516), 15, Color("72a57e"))
    draw_circle(Vector2(1161, 543), 12, Color("8bbd8b"))
    draw_circle(Vector2(1107, 514), 5, Color("f6d9bb"))
    _draw_butterfly(Vector2(1117 + sin(elapsed * 0.4) * 2.0, 425), 0.75)
    _draw_button(Rect2(40, 186, 190, 100), "Plant", "seed", selected_tool == "seed")
    _draw_button(Rect2(40, 305, 190, 100), "Water", "water", selected_tool == "water")
    _draw_button(Rect2(40, 424, 190, 100), "Sound on" if sound_enabled else "Sound off", "sound", false)
    _draw_button(Rect2(40, 543, 190, 100), "Rest", "rest", false)
    _rounded(Rect2(270, 722, 954, 57), Color("fffdf6", 0.93), 20)
    _text(message if message_seconds > 0.0 else "Pick Plant or Water, then touch the garden.", Vector2(299, 758), 22, Color("5e806d"))
    _text("Hold for grown-ups", Vector2(1136, 126), 15, Color("6b8872"), HORIZONTAL_ALIGNMENT_RIGHT, 245)


func _draw_plot(i: int) -> void:
    var col := i % 3
    var row := i / 3
    var top := PLOT_START + Vector2(float(col), float(row)) * PLOT_STEP
    var center := top + Vector2(101, 67)
    _rounded(Rect2(top + Vector2(1, 9), PLOT_SIZE), Color("9eb29a", 0.28), 27)
    _rounded(Rect2(top, PLOT_SIZE), Color("efdbb7"), 26)
    _rounded(Rect2(top + Vector2(8, 8), PLOT_SIZE - Vector2(16, 15)), Color("d2a785"), 23)
    _rounded(Rect2(top + Vector2(15, 14), PLOT_SIZE - Vector2(30, 29)), Color("9d775b"), 20)
    # Friendly soil grains and an original storybook plant sprite.
    for j in range(6):
        var grain := Vector2(top.x + 33 + float(j * 27), top.y + 75 + float((i * 11 + j * 17) % 24))
        draw_circle(grain, 2.5, Color("e8bd98", 0.75))
    if plots[i] > 0:
        var art_name: String = "seed" if plots[i] == 1 else "sprout" if plots[i] == 2 else str(FLOWER_ART[i % FLOWER_ART.size()])
        var sway := sin(elapsed * 0.54 + float(i) * 0.71) * 1.6 if plots[i] == 3 else 0.0
        _draw_plant_art(art_name, Rect2(center + Vector2(-67 + sway, -69), Vector2(134, 133)))
    else:
        draw_line(center + Vector2(-16, 17), center + Vector2(-23, 8), Color("a8c89e"), 3, true)
        draw_line(center + Vector2(-16, 17), center + Vector2(-7, 11), Color("a8c89e"), 3, true)
        draw_circle(center + Vector2(13, 4), 3.5, Color("e6c6a0"))


func _draw_plant_art(art_name: String, destination: Rect2) -> void:
    if plant_art.has(art_name):
        var sprite: Texture2D = plant_art[art_name]
        draw_texture_rect(sprite, destination, false, Color.WHITE)
    else:
        # Fallback stays gentle if an art import is unavailable.
        _draw_sprout(destination.get_center())


func _draw_butterfly(center: Vector2, size: float) -> void:
    draw_circle(center + Vector2(-11, -7) * size, 14 * size, Color("f7bdd0", 0.89))
    draw_circle(center + Vector2(12, -7) * size, 14 * size, Color("f4c9da", 0.93))
    draw_circle(center + Vector2(-9, 7) * size, 10 * size, Color("f0aebf", 0.91))
    draw_circle(center + Vector2(9, 7) * size, 10 * size, Color("f0aebf", 0.91))
    draw_line(center + Vector2(0, -8) * size, center + Vector2(0, 12) * size, Color("715c55"), 4 * size, true)
    draw_line(center + Vector2(0, -8) * size, center + Vector2(-5, -17) * size, Color("715c55"), 2 * size, true)
    draw_line(center + Vector2(0, -8) * size, center + Vector2(5, -17) * size, Color("715c55"), 2 * size, true)


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
    var surface := Color("e4f3dc") if active else Color("fffdf8")
    var accent := Color("5c9c6f")
    if kind == "water":
        accent = Color("5a9fac")
    elif kind == "sound":
        accent = Color("9381b2")
    elif kind == "rest":
        accent = Color("c69d5f")
    _rounded(Rect2(rect.position + Vector2(0, 6), rect.size), Color("638c70", 0.20), 25)
    _rounded(rect, surface, 25)
    _rounded(Rect2(rect.position + Vector2(10, 14), Vector2(68, 70)), Color("ebf4eb") if not active else Color("d1e6d0"), 21)
    if active:
        _rounded(Rect2(rect.position + Vector2(4, 15), Vector2(6, 69)), Color("5d9f6d"), 3)
    var p := rect.position + Vector2(45, 49)
    match kind:
        "seed":
            draw_circle(p + Vector2(-2, 5), 16, Color("956d4a"))
            draw_circle(p + Vector2(-8, -1), 5, Color("d7ad7a"))
            draw_line(p + Vector2(7, -7), p + Vector2(19, -24), Color("518d60"), 5, true)
            draw_circle(p + Vector2(22, -24), 8, Color("86bf8e"))
        "water":
            _rounded(Rect2(p + Vector2(-20, -13), Vector2(36, 32)), Color("78c2ce"), 8)
            draw_line(p + Vector2(9, -9), p + Vector2(22, -21), Color("5a9fac"), 5, true)
            draw_arc(p + Vector2(13, 5), 14, -PI/2, PI/2, 18, Color("5a9fac"), 5.0, true)
            draw_circle(p + Vector2(24, -21), 3, Color("9dd8dd"))
        "sound":
            draw_colored_polygon(PackedVector2Array([
                p + Vector2(-21,-9),p + Vector2(-9,-9),p + Vector2(6,-21),
                p + Vector2(6,19),p + Vector2(-9,9),p + Vector2(-21,9)
            ]), accent)
            if sound_enabled:
                draw_arc(p + Vector2(8,0), 20, -PI/3, PI/3, 18, accent, 3, true)
            else:
                draw_line(p + Vector2(16,-16), p + Vector2(27,15), Color("c78f8b"), 4, true)
        "rest":
            draw_circle(p, 23, Color("efcb81"))
            draw_circle(p + Vector2(11,-9), 21, Color("ebf4eb") if not active else Color("d1e6d0"))
    _text(label, rect.position + Vector2(90, 61), 21, Color("3f6355"))

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
