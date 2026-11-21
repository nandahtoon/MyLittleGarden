extends Node3D
## LW3D-T1 isolated native 3D feasibility scene.
## Launch from Godot with res://scenes/prototypes/lw3d_spike.tscn.
## No changes to legacy scene/main.tscn, saved garden, permissions, child data or engine version.

const PlayerScript = preload("res://scripts/prototypes/lw3d_player.gd")
const HudScript = preload("res://scripts/prototypes/lw3d_touch_hud.gd")
const BEACON_POS := Vector3(3.4, 0.0, -4.8)

var _player: CharacterBody3D
var _camera: Camera3D
var _hud: Control
var _bridge: MeshInstance3D
var _completed := false
var _resting := false
var _space_was_down := false


func _ready() -> void:
    name = "WonderGarden3DTechSpike"
    _make_lighting()
    _make_bounded_world()
    _make_player()
    _make_touch_hud()
    set_process(true)


func _process(delta: float) -> void:
    if _hud.call("take_home"):
        get_tree().change_scene_to_file("res://scenes/main.tscn")
        return

    if _hud.call("take_rest"):
        _resting = not _resting
        _hud.set("resting", _resting)

    if _resting:
        _player.set("movement", Vector2.ZERO)
    else:
        var movement: Vector2 = _hud.call("movement_vector")
        var keyboard := Vector2(
            float(Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) - float(Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)),
            float(Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)) - float(Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP))
        )
        _player.set("movement", (movement + keyboard).limit_length(1.0))
        var space_down := Input.is_key_pressed(KEY_SPACE)
        if _hud.call("take_jump") or (space_down and not _space_was_down):
            _player.call("request_jump")
        _space_was_down = space_down

        if _hud.call("take_action") or Input.is_key_pressed(KEY_E):
            _try_interact()

    if _camera != null and _player != null:
        var target := _player.global_position + Vector3(0.0, 4.2, 7.7)
        _camera.global_position = _camera.global_position.lerp(target, minf(delta * 4.0, 1.0))
        _camera.look_at(_player.global_position + Vector3(0.0, 0.8, 0.0), Vector3.UP)


func _make_lighting() -> void:
    var background := WorldEnvironment.new()
    var environment := Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color("#B9EDF3")
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color("#EFFEF4")
    environment.ambient_light_energy = 0.75
    background.environment = environment
    add_child(background)

    var sun := DirectionalLight3D.new()
    sun.name = "WarmSun"
    sun.rotation_degrees = Vector3(-58.0, 28.0, 0.0)
    sun.light_energy = 1.35
    add_child(sun)


func _make_bounded_world() -> void:
    _solid_box("GrassIsland", Vector3(28.0, 0.6, 28.0), Vector3(0, -0.35, 0), Color("#83C98A"))
    _solid_box("NorthEdge", Vector3(28.0, 2.0, 0.4), Vector3(0, 0.7, -14.0), Color("#79C186"))
    _solid_box("SouthEdge", Vector3(28.0, 2.0, 0.4), Vector3(0, 0.7, 14.0), Color("#79C186"))
    _solid_box("WestEdge", Vector3(0.4, 2.0, 28.0), Vector3(-14, 0.7, 0), Color("#79C186"))
    _solid_box("EastEdge", Vector3(0.4, 2.0, 28.0), Vector3(14, 0.7, 0), Color("#79C186"))

    for i in range(7):
        var at := Vector3(-1.5 + float(i % 2) * 0.5, 0.06, 6.5 - float(i) * 1.75)
        _solid_box("PathStone%d" % i, Vector3(1.6, 0.12, 1.2), at, Color("#EAE3C2"))

    for at in [
        Vector3(-9, 0, -9), Vector3(-6, 0, -11), Vector3(9, 0, -9),
        Vector3(-10, 0, 7), Vector3(11, 0, 7), Vector3(8, 0, 11)
    ]:
        _make_tree(at)

    _solid_box("BeaconBase", Vector3(2.1, 0.3, 2.1), BEACON_POS + Vector3(0, 0.10, 0), Color("#E9C58D"))
    _ball("GoldBeacon", BEACON_POS + Vector3(0, 1.0, 0), Vector3(0.48, 0.7, 0.48), Color("#FFE48E"))
    _bridge = _solid_box("BridgeChangesColor", Vector3(4.0, 0.34, 1.7), Vector3(0, 0.15, -9.5), Color("#9EAAAC"))
    _ball("BridgeFlowerLeft", Vector3(-2.2, 0.9, -9.5), Vector3(0.45, 0.45, 0.45), Color("#EBA1C8"))
    _ball("BridgeFlowerRight", Vector3(2.2, 0.9, -9.5), Vector3(0.45, 0.45, 0.45), Color("#EBA1C8"))


func _make_player() -> void:
    _player = CharacterBody3D.new()
    _player.set_script(PlayerScript)
    _player.position = Vector3(0.0, 1.2, 8.2)
    add_child(_player)

    _camera = Camera3D.new()
    _camera.name = "ChildFriendlyFollowCamera"
    _camera.position = Vector3(0.0, 5.2, 14.0)
    _camera.current = true
    _camera.fov = 62.0
    _camera.near = 0.1
    add_child(_camera)
    _camera.look_at(_player.position + Vector3(0, 0.8, 0), Vector3.UP)


func _make_touch_hud() -> void:
    var canvas := CanvasLayer.new()
    canvas.name = "TouchOverlay"
    add_child(canvas)
    _hud = Control.new()
    _hud.name = "PrototypeHUD"
    _hud.set_script(HudScript)
    _hud.anchor_right = 1.0
    _hud.anchor_bottom = 1.0
    _hud.offset_right = 0.0
    _hud.offset_bottom = 0.0
    canvas.add_child(_hud)


func _try_interact() -> void:
    if _completed:
        _hud.set("hint", "Wonderful! Explore or tap GARDEN to return.")
        return
    var distance := _player.global_position.distance_to(BEACON_POS)
    if distance > 3.0:
        _hud.set("hint", "Find the GOLD beacon, then tap LOOK!")
        return
    _completed = true
    var material := StandardMaterial3D.new()
    material.albedo_color = Color("#A3E4BC")
    material.roughness = 0.75
    _bridge.material_override = material
    _hud.set("hint", "You helped the garden grow! Try REST or GARDEN.")


func _make_tree(at: Vector3) -> void:
    var trunk := CylinderMesh.new()
    trunk.height = 2.3
    trunk.top_radius = 0.25
    trunk.bottom_radius = 0.38
    var stem := MeshInstance3D.new()
    stem.mesh = trunk
    stem.position = at + Vector3(0, 1.15, 0)
    stem.material_override = _material(Color("#967254"))
    add_child(stem)
    _ball("TreeCrown", at + Vector3(0, 2.65, 0), Vector3(1.25, 1.0, 1.15), Color("#4DAD83"))


func _ball(label: String, at: Vector3, scale_value: Vector3, tint: Color) -> MeshInstance3D:
    var node := MeshInstance3D.new()
    node.name = label
    node.mesh = SphereMesh.new()
    node.position = at
    node.scale = scale_value
    node.material_override = _material(tint)
    add_child(node)
    return node


func _solid_box(label: String, dimensions: Vector3, at: Vector3, tint: Color) -> MeshInstance3D:
    var body := StaticBody3D.new()
    body.name = label
    body.position = at
    add_child(body)
    var shape := BoxShape3D.new()
    shape.size = dimensions
    var collision := CollisionShape3D.new()
    collision.shape = shape
    body.add_child(collision)
    var mesh := BoxMesh.new()
    mesh.size = dimensions
    var visual := MeshInstance3D.new()
    visual.name = "Surface"
    visual.mesh = mesh
    visual.material_override = _material(tint)
    body.add_child(visual)
    return visual


func _material(tint: Color) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = tint
    material.roughness = 0.85
    return material
