extends SceneTree
## Deterministic CI regression for LW3D-T1 physics, virtual touch, rest and interaction.
## No save data, screenshots, device identifiers or network calls are created.

func _initialize() -> void:
    call_deferred("_run_test")


func _run_test() -> void:
    var packed: PackedScene = load("res://scenes/prototypes/lw3d_spike.tscn")
    if packed == null:
        _fail("3D prototype PackedScene failed to load")
        return

    var game: Node3D = packed.instantiate()
    root.add_child(game)
    await process_frame

    var player := game.get_node_or_null("NovaPlaceholder") as CharacterBody3D
    var hud := game.get_node_or_null("TouchOverlay/PrototypeHUD") as Control
    var camera := game.get_node_or_null("ChildFriendlyFollowCamera") as Camera3D
    if player == null or hud == null or camera == null:
        _fail("Prototype must include a player, camera and HUD")
        return

    var initial_z := player.global_position.z
    var stick: Vector2 = hud.call("_joy_center")
    hud.call("_touch", 21, stick + Vector2(0.0, -85.0), true)
    for _i in range(50):
        await physics_frame
    hud.call("_touch", 21, stick, false)

    if player.global_position.z >= initial_z - 1.0:
        _fail("Moving virtual thumbstick did not move player forward")
        return

    var rest_center: Vector2 = hud.call("_rest_center")
    hud.call("_touch", 22, rest_center, true)
    # SceneTree.process_frame fires before Node._process; allow world to consume the queued UI action.
    await process_frame
    await process_frame
    if not bool(hud.get("resting")):
        _fail("Rest control did not pause movement")
        return

    hud.call("_touch", 23, rest_center, true)
    await process_frame
    await process_frame
    if bool(hud.get("resting")):
        _fail("Rest control did not resume")
        return

    player.global_position = Vector3(3.4, 1.1, -4.8)
    var action_center: Vector2 = hud.call("_action_center")
    hud.call("_touch", 24, action_center, true)
    await process_frame
    await process_frame
    if not bool(game.get("_completed")):
        _fail("Beacon LOOK action did not complete prototype interaction")
        return

    print("PASS LW3D-T1: camera, virtual joystick, Rest toggle, beacon interaction")
    quit(0)


func _fail(reason: String) -> void:
    push_error("FAIL LW3D-T1: " + reason)
    quit(1)
