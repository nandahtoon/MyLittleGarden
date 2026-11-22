extends SceneTree
## LW3D-W2: isolated four-bed actions, collision, persistence, old mission safety.

const Plots = preload("res://scripts/gameplay/garden_plot_progress.gd")
const GardenWorld = preload("res://scripts/worlds/garden_world_w1.gd")


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    # These CI tests use an isolated runner user directory, not real child saves.
    if FileAccess.file_exists(Plots.FILE_PATH):
        DirAccess.remove_absolute(ProjectSettings.globalize_path(Plots.FILE_PATH))
    var invalid := Plots._sanitize({"plots": [-2, 9, "unknown", 2]})
    if invalid["plots"] != [0, 3, 0, 2]:
        _fail("Stage validation or clamping is incorrect")
        return
    var packed := load("res://scenes/worlds/rainbow_forest_v1.tscn") as PackedScene
    if packed == null:
        _fail("Rainbow scene could not load")
        return
    var world := packed.instantiate() as Node3D
    root.add_child(world)
    await process_frame
    await process_frame

    var player := world.get_node_or_null("NovaPlaceholder") as CharacterBody3D
    if player == null:
        _fail("Nova controller missing")
        return
    for i in range(4):
        var plot := world.get_node_or_null("W2GardenPlot%d" % i) as Node3D
        if plot == null or plot.get_node_or_null("W2GrowthVisual") == null:
            _fail("Missing usable garden bed " + str(i))
            return
        var soil_body := plot.get_node_or_null("W2SoilBedCollision") as StaticBody3D
        var has_shape := false
        if soil_body != null:
            for child in soil_body.get_children():
                if child is CollisionShape3D and child.shape != null:
                    has_shape = true
        if not has_shape:
            _fail("Garden bed physics collision missing")
            return

    var obstacles := 0
    for child in world.get_children():
        if child.name.begins_with("W2Obstacle_") and child is StaticBody3D:
            obstacles += 1
    if obstacles < 9:
        _fail("Solid trees and rocks are missing collisions")
        return
    if GardenWorld.nearest_farm_plot(Vector3(0.0, 0.0, 8.2)) != -1:
        _fail("Garden action is active too far from the beds")
        return

    var site: Vector2 = GardenWorld.FARM_POSITIONS[0]
    player.global_position = Vector3(site.x, 0.8, site.y)
    await process_frame
    await process_frame
    if str(world.get_node("TouchOverlay/PrototypeHUD").get("context_action")) != "PLANT":
        _fail("Nearby empty garden bed should offer PLANT")
        return
    _action(world)
    var data: Dictionary = Plots.load_progress()
    if data["plots"] != [1, 0, 0, 0]:
        _fail("Plant action did not persist only the selected bed")
        return
    var visual := world.get_node("W2GardenPlot0/W2GrowthVisual")
    if visual.get_node_or_null("W2Seed") == null:
        _fail("Actual seed visual not shown")
        return
    _action(world)
    data = Plots.load_progress()
    if data["plots"] != [2, 0, 0, 0]:
        _fail("Water did not grow the seed")
        return
    if visual.get_node_or_null("W2Crop") == null:
        _fail("Bundled crop GLB was not instantiated for sprout")
        return
    _action(world)
    data = Plots.load_progress()
    if data["plots"] != [3, 0, 0, 0]:
        _fail("Third action did not grow the crop")
        return
    # A finished Rainbow mission must not disable the new calm gardening.
    world.set("_completed", true)
    var next_site: Vector2 = GardenWorld.FARM_POSITIONS[1]
    player.global_position = Vector3(next_site.x, 0.8, next_site.y)
    _action(world)
    data = Plots.load_progress()
    if data["plots"] != [3, 1, 0, 0]:
        _fail("Garden must work after completing the Rainbow mission")
        return
    world.queue_free()
    await process_frame
    var again := packed.instantiate() as Node3D
    root.add_child(again)
    await process_frame
    await process_frame
    if again.get_node_or_null("W2GardenPlot0/W2GrowthVisual/W2Crop") == null:
        _fail("Mature crops not rendered after scene restart")
        return
    if again.get_node_or_null("W2GardenPlot1/W2GrowthVisual/W2Seed") == null:
        _fail("Second plot stage not restored")
        return
    again.queue_free()
    await process_frame
    if FileAccess.file_exists(Plots.FILE_PATH):
        DirAccess.remove_absolute(ProjectSettings.globalize_path(Plots.FILE_PATH))
    print("PASS LW3D-W2: four interactive plots, collision, PLANT/WATER growth, save/restart and post-mission gardening")
    quit(0)


func _action(world: Node3D) -> void:
    world.set("_look_cooldown_ms", -100000)
    world.call("_try_interact")


func _fail(reason: String) -> void:
    push_error("FAIL LW3D-W2: " + reason)
    quit(1)
