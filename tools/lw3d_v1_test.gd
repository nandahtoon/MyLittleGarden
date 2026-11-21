extends SceneTree
## Deterministic headless V1 mission regression; uses synthetic CI-local save only.
## Proves both paths, incorrect-shape hint, persistence, model instance and v1 isolation.

const Progress = preload("res://scripts/gameplay/rainbow_mission_save.gd")
const ADVENTURE := "res://scenes/worlds/rainbow_forest_v1.tscn"

func _initialize() -> void:
    call_deferred("_test")


func _test() -> void:
    var legacy_existed := FileAccess.file_exists("user://little_wonder_garden.json")
    if FileAccess.file_exists(Progress.FILE_PATH):
        DirAccess.remove_absolute(ProjectSettings.globalize_path(Progress.FILE_PATH))
    var scene := load(ADVENTURE) as PackedScene
    if scene == null:
        _fail("Rainbow Forest scene cannot load")
        return
    var world := scene.instantiate() as Node3D
    root.add_child(world)
    await process_frame

    var player := world.get_node_or_null("NovaPlaceholder") as CharacterBody3D
    if player == null:
        _fail("3D player missing")
        return
    var visual := player.get_node_or_null("NovaSkinnedModel")
    if visual == null:
        _fail("Original skinned Nova glTF did not instantiate")
        return
    var animator := visual.find_child("AnimationPlayer", true, false) as AnimationPlayer
    if animator == null:
        _fail("Nova animation player was not imported from glTF")
        return
    var imported_clips := animator.get_animation_list()
    if imported_clips.size() < 3:
        _fail("Expected Idle, Walk and Wave animation tracks in Nova model")
        return

    player.global_position = Vector3(-1.9, 0.9, -3.8)
    world.call("_try_interact")
    if bool(world.get("_completed")):
        _fail("Incorrect circle must not solve triangle bridge mission")
        return

    player.global_position = Vector3(6.0, 0.9, -4.4)
    world.call("_try_interact")
    if int(world.get("_progress").get("seed_stage", 0)) != 1:
        _fail("Seed stage one missing")
        return
    # A second deliberate interaction is separate from an accidental double tap.
    world.set("_look_cooldown_ms", -100000)
    world.call("_try_interact")
    if not bool(world.get("_completed")):
        _fail("Nature solution path should complete after planting and watering")
        return
    var saved: Dictionary = Progress.load_progress()
    if not bool(saved.get("completed", false)) or saved.get("approach") != "nature":
        _fail("Offline nature completion not persisted")
        return

    world.queue_free()
    await process_frame
    var reopened := scene.instantiate() as Node3D
    root.add_child(reopened)
    await process_frame
    if not bool(reopened.get("_completed")):
        _fail("Rainbow bridge completion lost after reload")
        return
    if reopened.get_node_or_null("RestoredRainbow0") == null:
        _fail("Persisted world change not visually restored")
        return

    reopened.queue_free()
    await process_frame
    var stage := Progress.defaults()
    if not Progress.save_progress(stage):
        _fail("Could not reset CI synthetic test fixture")
        return
    var shape_world := scene.instantiate() as Node3D
    root.add_child(shape_world)
    await process_frame
    var shape_player := shape_world.get_node("NovaPlaceholder") as CharacterBody3D
    shape_player.global_position = Vector3(-4.6, 0.9, -3.8)
    shape_world.call("_try_interact")
    saved = Progress.load_progress()
    if saved.get("approach") != "shape" or not bool(saved.get("completed", false)):
        _fail("Triangle route failed to complete and persist")
        return

    if legacy_existed != FileAccess.file_exists("user://little_wonder_garden.json"):
        _fail("Existing v1 Garden save file was created or destroyed")
        return

    shape_world.queue_free()
    await process_frame
    if FileAccess.file_exists(Progress.FILE_PATH):
        DirAccess.remove_absolute(ProjectSettings.globalize_path(Progress.FILE_PATH))
    print("PASS LW3D-V1: imported skinned Nova, wrong shape hint, nature path, shape path, persistent world, v1 save isolation")
    quit(0)


func _fail(reason: String) -> void:
    push_error("FAIL LW3D-V1: " + reason)
    quit(1)
