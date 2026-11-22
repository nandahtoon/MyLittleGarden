extends RefCounted
## LW3D-W1: authored, offline, child-friendly garden world dressing.
## Kenney CC0 glTF models are bundled locally; no runtime downloads.
## Only used by Rainbow Forest. Original 2D scene and saves stay unchanged.

const MODELS := "res://assets/models/kenney_nature/"
const EXTENT := 14.0
const GRID := 32
const FARM_POSITIONS := [
    Vector2(9.0, -7.5), Vector2(10.7, -7.5),
    Vector2(9.0, -9.2), Vector2(10.7, -9.2)
]



static func build(root: Node3D) -> void:
    # Keep the T1 prototype, controls and mission mechanics, but replace its
    # giant collision box with a gently undulating *walkable* terrain mesh.
    var old_ground := root.get_node_or_null("GrassIsland")
    if old_ground != null:
        old_ground.queue_free()
    _terrain(root)
    _cottage(root)
    _pond(root)
    _place_nature(root)
    _paths(root)
    _farm(root)


static func height_at(x: float, z: float) -> float:
    var here := Vector2(x, z)
    # Rolling edge hills, not a bumpy play area. All mission markers, the
    # rainbow bridge and Nova's spawn get level, accessible ground.
    var h := (
        1.10 * exp(-pow(here.distance_to(Vector2(-10.7, -1.3)) / 5.0, 2.0))
        + 1.20 * exp(-pow(here.distance_to(Vector2(11.0, 3.8)) / 5.0, 2.0))
        + 0.85 * exp(-pow(here.distance_to(Vector2(-9.0, 10.5)) / 5.2, 2.0))
        + 0.74 * exp(-pow(here.distance_to(Vector2(9.8, -10.2)) / 5.2, 2.0))
    )
    for clear in [
        Vector2(0.0, 8.2), Vector2(-4.6, -3.8),
        Vector2(-1.9, -3.8), Vector2(6.0, -4.4),
        Vector2(0.0, -9.5), Vector2(0.0, 0.0)
    ]:
        h *= smoothstep(0.9, 5.5, here.distance_to(clear))
    return h


static func _terrain(root: Node3D) -> void:
    var surface := SurfaceTool.new()
    surface.begin(Mesh.PRIMITIVE_TRIANGLES)
    var material := StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.roughness = 0.98
    surface.set_material(material)
    var step := 2.0 * EXTENT / float(GRID)
    for zi in range(GRID):
        for xi in range(GRID):
            var x := -EXTENT + float(xi) * step
            var z := -EXTENT + float(zi) * step
            var a := Vector3(x, height_at(x, z) - 0.04, z)
            var b := Vector3(x + step, height_at(x + step, z) - 0.04, z)
            var c := Vector3(x, height_at(x, z + step) - 0.04, z + step)
            var d := Vector3(x + step, height_at(x + step, z + step) - 0.04, z + step)
            _vertex(surface, a)
            _vertex(surface, c)
            _vertex(surface, b)
            _vertex(surface, b)
            _vertex(surface, c)
            _vertex(surface, d)
    surface.generate_normals()
    var mesh: ArrayMesh = surface.commit()
    var ground := StaticBody3D.new()
    ground.name = "W1WalkableRollingTerrain"
    root.add_child(ground)
    var visible := MeshInstance3D.new()
    visible.name = "TerrainSurface"
    visible.mesh = mesh
    ground.add_child(visible)
    var collider := CollisionShape3D.new()
    collider.name = "TerrainCollision"
    collider.shape = mesh.create_trimesh_shape()
    ground.add_child(collider)


static func _vertex(surface: SurfaceTool, p: Vector3) -> void:
    var greenness := clampf(p.y / 1.5, 0.0, 1.0)
    var shade := Color("#92D59B").lerp(Color("#69B97C"), greenness)
    surface.set_color(shade)
    surface.add_vertex(p)


static func _model(root: Node3D, asset: String, x: float, z: float, size: float = 1.0, heading: float = 0.0, y_offset: float = 0.0) -> void:
    var path := MODELS + asset + ".glb"
    if not ResourceLoader.exists(path):
        push_warning("Garden model missing: " + path)
        return
    var packed := load(path) as PackedScene
    if packed == null:
        push_warning("Could not import garden model: " + path)
        return
    var item := packed.instantiate() as Node3D
    if item == null:
        push_warning("Non-Node3D garden model: " + path)
        return
    item.name = "W1_" + asset.replace("-", "_") + "_" + str(root.get_child_count())
    item.position = Vector3(x, height_at(x, z) + y_offset, z)
    item.rotation.y = heading
    item.scale = Vector3.ONE * size
    root.add_child(item)
    # Only solid obstacles get approximated physics. Small flowers and grass
    # intentionally remain non-solid so children cannot become trapped.
    if asset.begins_with("tree-") or asset == "rock-largea":
        var tree := asset.begins_with("tree-")
        var radius := (0.38 if tree else 0.52) * size
        var height := (1.60 if tree else 0.72) * size
        var body := StaticBody3D.new()
        body.name = "W2Obstacle_" + str(root.get_child_count())
        body.position = Vector3(x, height_at(x, z) + height * 0.5, z)
        var collision := CollisionShape3D.new()
        var shape := CylinderShape3D.new()
        shape.radius = radius
        shape.height = height
        collision.shape = shape
        body.add_child(collision)
        root.add_child(body)


static func _place_nature(root: Node3D) -> void:
    # Low-poly authored asset placements; keep interaction markers visible.
    for placement in [
        ["tree-oak", -11.5, -9.7, 1.65, 0.4],
        ["tree-default", -8.5, -7.6, 1.5, 1.0],
        ["tree-oak-fall", 10.2, -9.8, 1.5, 0.5],
        ["tree-cone", 11.2, -0.3, 1.6, -0.4],
        ["tree-oak", -11.5, 9.3, 1.45, 0.1],
        ["tree-default", 7.7, 11.6, 1.45, 0.7],
        ["tree-cone", -8.2, -11.7, 1.2, 0.2],
        ["tree-default", 12.0, -10.4, 1.2, 1.0],
        ["tree-oak-fall", -11.9, 0.3, 1.35, -0.2]
    ]:
        _model(root, str(placement[0]), float(placement[1]), float(placement[2]), float(placement[3]), float(placement[4]))
    for i in range(14):
        var theta := 0.49 * float(i)
        var x := -7.4 + sin(theta * 1.6) * 2.2
        var z := -6.5 + cos(theta * 1.3) * 3.1
        _model(root, "plant-bush" if i % 3 else "plant-bushdetailed", x, z, 0.55 + 0.13 * float(i % 3), theta)
    for i in range(23):
        var x := -10.0 + float(i % 8) * 2.65
        var z := -11.2 + float(i / 8) * 0.9
        # Decorative flowers away from the triangle/seed mission buttons.
        _model(root, ["flower-purplea", "flower-yellowa", "flower-reda"][i % 3], x, z, 0.85, float(i) * 0.8)
    for i in range(9):
        var x := 9.8 + sin(float(i) * 2.3) * 1.9
        var z := 8.4 + cos(float(i) * 1.4) * 1.8
        _model(root, "rock-largea" if i % 3 == 0 else "rock-smalla", x, z, 0.85 + 0.18 * float(i % 3), float(i))
    for i in range(6):
        _model(root, "mushroom-redgroup", -10.5 + float(i % 3) * 1.5, -5.4 + float(i / 3) * 1.4, 0.55, float(i))
    for i in range(12):
        var x := -12.0 + float(i) * 2.1
        _model(root, "grass", x, 12.2, 0.8 + float(i % 3) * 0.15, float(i) * 0.4)


static func _cottage(root: Node3D) -> void:
    var x := -9.1
    var z := 2.3
    var h := height_at(x, z)
    _box(root, "W1CottageWalls", Vector3(3.45, 2.15, 2.75), Vector3(x, h + 1.1, z), Color("#FFE9BA"), true)
    _box(root, "W1CottageRoofLeft", Vector3(2.35, 0.27, 3.25), Vector3(x - 0.8, h + 2.68, z), Color("#CB7382"), false, -0.56)
    _box(root, "W1CottageRoofRight", Vector3(2.35, 0.27, 3.25), Vector3(x + 0.8, h + 2.68, z), Color("#CB7382"), false, 0.56)
    _box(root, "W1CottageDoor", Vector3(0.87, 1.35, 0.08), Vector3(x, h + 0.75, z + 1.42), Color("#99765A"))
    for offset in [-1.18, 1.18]:
        _box(root, "W1CottageWindow", Vector3(0.51, 0.54, 0.10), Vector3(x + offset, h + 1.28, z + 1.45), Color("#A6DDE7"))
    for i in range(4):
        _model(root, "fence-simple", x - 3.6 + float(i) * 1.3, z + 3.5, 1.0, 0.0)


static func _pond(root: Node3D) -> void:
    var center := Vector3(7.8, height_at(7.8, 6.8), 6.8)
    _oval(root, "W1ShallowPondShore", center + Vector3(0, 0.05, 0), Vector3(3.1, 0.21, 2.15), Color("#E5DCB6"))
    _oval(root, "W1ShallowPondWater", center + Vector3(0, 0.19, 0), Vector3(2.72, 0.07, 1.84), Color("#70C9DD"))
    for i in range(9):
        var angle := float(i) / 9.0 * TAU
        var x := center.x + 3.2 * cos(angle)
        var z := center.z + 2.25 * sin(angle)
        _model(root, "rock-smalla", x, z, 0.42, angle)
    # Shallow, friendly decorative water: no swimming or deep-water mechanics.


static func _paths(root: Node3D) -> void:
    # A visible winding branching path leads from Nova's starting area.
    for i in range(9):
        var z := 9.5 - float(i) * 1.7
        var x := -1.0 + sin(float(i) * 0.52) * 0.95
        _stone(root, x, z, 1.0 + float(i % 2) * 0.16)
    for i in range(7):
        var x := -0.5 - float(i) * 0.85
        var z := -3.6 + sin(float(i) * 0.4) * 0.44
        _stone(root, x, z, 0.65)
    for i in range(8):
        var x := 0.5 + float(i) * 0.92
        var z := -5.8 + sin(float(i) * 0.38) * 0.48
        _stone(root, x, z, 0.65)


static func _stone(root: Node3D, x: float, z: float, size: float) -> void:
    _oval(root, "W1SteppingStone", Vector3(x, height_at(x, z) + 0.065, z), Vector3(size * 0.5, 0.095, size * 0.4), Color("#E8DEBC"))


static func _farm(root: Node3D) -> void:
    # Four persistent growable beds. Unlike W1's decorative crops they begin
    # empty and have individual stage visuals and small collision platforms.
    for i in range(FARM_POSITIONS.size()):
        var site: Vector2 = FARM_POSITIONS[i]
        var bed := Node3D.new()
        bed.name = "W2GardenPlot%d" % i
        bed.position = Vector3(site.x, height_at(site.x, site.y), site.y)
        root.add_child(bed)
        _box(bed, "W2SoilBed", Vector3(1.3, 0.25, 1.3), Vector3(0, 0.06, 0), Color("#986B4D"), true)
        _box(bed, "W2SoilTop", Vector3(1.12, 0.06, 1.12), Vector3(0, 0.21, 0), Color("#684D37"))
        var growth := Node3D.new()
        growth.name = "W2GrowthVisual"
        bed.add_child(growth)
    for i in range(3):
        _model(root, "fence-simple", 7.7 + float(i) * 1.5, -10.7, 1.0)


static func nearest_farm_plot(player_position: Vector3) -> int:
    var near_index := -1
    var best := 2.10
    var horizontal := Vector2(player_position.x, player_position.z)
    for i in range(FARM_POSITIONS.size()):
        var distance := horizontal.distance_to(FARM_POSITIONS[i])
        if distance < best:
            best = distance
            near_index = i
    return near_index


static func render_growth(root: Node3D, plot_index: int, stage: int) -> void:
    var plot := root.get_node_or_null("W2GardenPlot%d" % plot_index) as Node3D
    if plot == null:
        return
    var growth := plot.get_node_or_null("W2GrowthVisual") as Node3D
    if growth == null:
        return
    for old in growth.get_children():
        growth.remove_child(old)
        old.queue_free()
    if stage <= 0:
        return
    if stage == 1:
        var seed := MeshInstance3D.new()
        seed.name = "W2Seed"
        seed.mesh = SphereMesh.new()
        seed.scale = Vector3(0.18, 0.12, 0.18)
        seed.position.y = 0.34
        seed.material_override = _material(Color("#F0CD6E"))
        growth.add_child(seed)
        return
    var asset := "crop-carrot" if plot_index % 2 == 0 else "crop-pumpkin"
    var packed := load(MODELS + asset + ".glb") as PackedScene
    if packed == null:
        push_warning("Missing W2 crop model: " + asset)
        return
    var crop := packed.instantiate() as Node3D
    if crop == null:
        return
    crop.name = "W2Crop"
    crop.position.y = 0.31
    crop.scale = Vector3.ONE * (0.37 if stage == 2 else 0.85)
    growth.add_child(crop)


static func _box(root: Node3D, label: String, size: Vector3, center: Vector3, color: Color, solid: bool = false, roll: float = 0.0) -> void:
    var parent: Node3D = root
    if solid:
        var body := StaticBody3D.new()
        body.name = label + "Collision"
        body.position = center
        root.add_child(body)
        parent = body
        var shape := CollisionShape3D.new()
        var box_shape := BoxShape3D.new()
        box_shape.size = size
        shape.shape = box_shape
        body.add_child(shape)
    var piece := MeshInstance3D.new()
    piece.name = label
    var box_mesh := BoxMesh.new()
    box_mesh.size = size
    piece.mesh = box_mesh
    piece.material_override = _material(color)
    if not solid:
        piece.position = center
    piece.rotation.z = roll
    parent.add_child(piece)


static func _oval(root: Node3D, label: String, center: Vector3, dimensions: Vector3, color: Color) -> void:
    var piece := MeshInstance3D.new()
    piece.name = label
    piece.mesh = SphereMesh.new()
    piece.position = center
    piece.scale = dimensions
    piece.material_override = _material(color)
    root.add_child(piece)


static func _material(color: Color) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.82
    return material
