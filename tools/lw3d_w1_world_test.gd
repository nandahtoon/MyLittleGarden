extends SceneTree
## LW3D-W1 headless smoke: real bundled GLBs, terrain collision, landmarks.
const WorldArt = preload("res://scripts/worlds/garden_world_w1.gd")

func _initialize() -> void:
    call_deferred("_test")


func _test() -> void:
    var expected := [
        "tree-oak", "tree-default", "tree-oak-fall", "tree-cone",
        "plant-bush", "plant-bushdetailed", "flower-purplea",
        "flower-yellowa", "flower-reda", "rock-largea",
        "rock-smalla", "mushroom-redgroup", "grass", "fence-simple",
        "crop-carrot", "crop-pumpkin"
    ]
    for model in expected:
        if not ResourceLoader.exists("res://assets/models/kenney_nature/" + model + ".glb"):
            _fail("Missing bundled GLB: " + model)
            return
    if WorldArt.height_at(-10.7, -1.3) < 0.30:
        _fail("Rolling hill is flat")
        return
    if WorldArt.height_at(6.0, -4.4) > 0.05:
        _fail("Plant mission ground is no longer flat")
        return
    var scene := load("res://scenes/worlds/rainbow_forest_v1.tscn") as PackedScene
    if scene == null:
        _fail("Rainbow mission scene missing")
        return
    var world := scene.instantiate() as Node3D
    root.add_child(world)
    await process_frame
    await process_frame
    var ground := world.get_node_or_null("W1WalkableRollingTerrain") as StaticBody3D
    if ground == null:
        _fail("Walkable terrain was not created")
        return
    var collider := ground.get_node_or_null("TerrainCollision") as CollisionShape3D
    if collider == null or collider.shape == null:
        _fail("Terrain has no physical collision shape")
        return
    if world.get_node_or_null("GrassIsland") != null:
        _fail("Old flat plane was not replaced")
        return
    if world.get_node_or_null("W1ShallowPondWater") == null:
        _fail("Pond landmark missing")
        return
    if world.get_node_or_null("W1CottageWallsCollision") == null:
        _fail("Walkable world cottage obstacle missing")
        return
    var count := 0
    for child in world.get_children():
        if child.name.begins_with("W1_"):
            count += 1
    if count < 60:
        _fail("Expected actual nature GLB instances, found " + str(count))
        return
    var player := world.get_node_or_null("NovaPlaceholder") as CharacterBody3D
    if player == null or player.get_node_or_null("NovaSkinnedModel") == null:
        _fail("Nova player disappeared after adding the world")
        return
    if world.get_node_or_null("MatchingTriangle") == null or world.get_node_or_null("GardenBed") == null:
        _fail("Existing Rainbow Forest mission markers missing")
        return
    world.queue_free()
    await process_frame
    print("PASS LW3D-W1: 16 imported nature GLBs, ", count, " placements, terrain collision, cottage, pond, Nova, both mission markers")
    quit(0)


func _fail(reason: String) -> void:
    push_error("FAIL LW3D-W1: " + reason)
    quit(1)
