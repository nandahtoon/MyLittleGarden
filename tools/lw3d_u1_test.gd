extends SceneTree
## LW3D-U1 synthetic UI and regression test. Runs with a temporary local user data directory in CI.
const Progress = preload("res://scripts/gameplay/rainbow_mission_save.gd")

func _initialize() -> void:
    call_deferred("_check")


func _check() -> void:
    if FileAccess.file_exists(Progress.FILE_PATH):
        DirAccess.remove_absolute(ProjectSettings.globalize_path(Progress.FILE_PATH))
    var packed := load("res://scenes/worlds/rainbow_forest_v1.tscn") as PackedScene
    if packed == null:
        _fail("Rainbow scene missing")
        return
    var world := packed.instantiate() as Node3D
    root.add_child(world)
    await process_frame
    var hud := world.get_node_or_null("TouchOverlay/PrototypeHUD") as Control
    var player := world.get_node_or_null("NovaPlaceholder") as CharacterBody3D
    if hud == null or player == null:
        _fail("Child HUD or player missing")
        return
    if str(hud.get("goal")) != "Restore the rainbow bridge":
        _fail("Child-facing goal missing")
        return
    hud.size = Vector2(1280, 800)
    if not _good_layout(hud):
        _fail("HUD controls overlap or are outside 1280x800 landscape")
        return
    hud.size = Vector2(640, 360)
    if not _good_layout(hud):
        _fail("HUD controls overlap or are outside compact 640x360 landscape")
        return
    hud.size = Vector2(1280, 800)

    var joy: Vector2 = hud.call("_joy_center")
    hud.call("_touch", 41, joy + Vector2(0, -70), true)
    if (hud.call("movement_vector") as Vector2).length() < 0.35:
        _fail("Touch joystick does not move")
        return
    # Rest pauses locomotion and cancels joystick, even if thumb remains pressed.
    var rest: Vector2 = hud.call("_rest_center")
    hud.call("_touch", 42, rest, true)
    await process_frame
    await process_frame
    if not bool(hud.get("resting")) or (hud.call("movement_vector") as Vector2).length() > 0.01:
        _fail("Rest did not cancel joystick motion and pause")
        return
    hud.call("_touch", 43, rest, true)
    await process_frame
    await process_frame
    if bool(hud.get("resting")):
        _fail("Rest did not resume")
        return
    hud.call("_touch", 44, hud.call("_help_center"), true)
    if not bool(hud.get("help_open")):
        _fail("Optional help button not functional")
        return
    hud.call("_touch", 44, hud.call("_help_center"), false)

    # Nova should face in the direction its physics visual points when moving.
    var baseline_visual := player.get_node("PrototypeVisual") as Node3D
    var actual_model := player.get_node_or_null("NovaSkinnedModel") as Node3D
    baseline_visual.rotation.y = 0.66
    baseline_visual.position.y = 0.038
    await process_frame
    await process_frame
    if actual_model == null or absf(actual_model.rotation.y - 0.66) > 0.03:
        _fail("Imported Nova did not follow character's facing rotation")
        return

    # Contextual action and distinct plant/water actions prevent instant completion.
    player.global_position = Vector3(6.0, 0.80, -4.4)
    await process_frame
    await process_frame
    if str(hud.get("context_action")) != "PLANT":
        _fail("Garden interaction must show PLANT")
        return
    world.call("_try_interact")
    world.call("_try_interact")
    if int(world.get("_progress").get("seed_stage", 0)) != 1 or bool(world.get("_completed")):
        _fail("Accidental rapid double tap must NOT complete both plant and water")
        return
    await process_frame
    await process_frame
    if str(hud.get("context_action")) != "WATER":
        _fail("Garden interaction must show WATER after planting")
        return
    world.set("_look_cooldown_ms", -100000)
    world.call("_try_interact")
    if not bool(world.get("_completed")):
        _fail("Second deliberate action must complete nature mission")
        return
    var saved: Dictionary = Progress.load_progress()
    if not bool(saved.get("completed", false)):
        _fail("UI mission completion did not persist")
        return

    world.queue_free()
    await process_frame
    if FileAccess.file_exists(Progress.FILE_PATH):
        DirAccess.remove_absolute(ProjectSettings.globalize_path(Progress.FILE_PATH))
    print("PASS LW3D-U1: compact HUD, help, Rest, joystick, Nova facing, contextual PLANT/WATER, double tap guard")
    quit(0)


func _good_layout(hud: Control) -> bool:
    var s: Vector2 = hud.size
    var joy: Vector2 = hud.call("_joy_center")
    var jump: Vector2 = hud.call("_jump_center")
    var action: Vector2 = hud.call("_action_center")
    var help: Vector2 = hud.call("_help_center")
    var home: Vector2 = hud.call("_home_center")
    var rest: Vector2 = hud.call("_rest_center")
    for p in [joy, jump, action, help, home, rest]:
        if p.x < 24.0 or p.x > s.x - 24.0 or p.y < 20.0 or p.y > s.y - 24.0:
            return false
    if jump.distance_to(action) < 115.0 * float(hud.call("_ui_scale")):
        return false
    if help.distance_to(action) < 104.0 * float(hud.call("_ui_scale")):
        return false
    return true


func _fail(message: String) -> void:
    push_error("FAIL LW3D-U1: " + message)
    quit(1)
