extends CharacterBody3D
## LW3D-T1: standalone original procedural Nova-shaped PLACEHOLDER, not a finished rigged character.
## This scene deliberately has no persistence, child data, external assets or dependencies.

const MOVE_SPEED := 4.2
const JUMP_SPEED := 5.6
const FALL_ACCEL := 19.5

var movement: Vector2 = Vector2.ZERO
var jump_queued := false
var _visual: Node3D
var _elapsed := 0.0


func _ready() -> void:
    name = "NovaPlaceholder"
    collision_layer = 1
    collision_mask = 1

    var shape := CapsuleShape3D.new()
    shape.radius = 0.38
    shape.height = 1.3
    var collider := CollisionShape3D.new()
    collider.name = "CapsuleCollider"
    collider.shape = shape
    add_child(collider)

    _visual = Node3D.new()
    _visual.name = "PrototypeVisual"
    add_child(_visual)
    _make_placeholder_robot()


func request_jump() -> void:
    jump_queued = true


func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= FALL_ACCEL * delta

    var move_direction := Vector3(movement.x, 0.0, movement.y)
    if move_direction.length_squared() > 1.0:
        move_direction = move_direction.normalized()
    velocity.x = move_direction.x * MOVE_SPEED
    velocity.z = move_direction.z * MOVE_SPEED

    if jump_queued and is_on_floor():
        velocity.y = JUMP_SPEED
    jump_queued = false

    move_and_slide()
    if move_direction.length_squared() > 0.001:
        var desired_yaw := atan2(-move_direction.x, -move_direction.z)
        _visual.rotation.y = lerp_angle(_visual.rotation.y, desired_yaw, minf(1.0, delta * 12.0))


func _process(delta: float) -> void:
    _elapsed += delta
    if _visual != null:
        var bob_speed := 10.0 if movement.length_squared() > 0.01 else 2.4
        var amplitude := 0.045 if movement.length_squared() > 0.01 else 0.018
        _visual.position.y = sin(_elapsed * bob_speed) * amplitude


func _make_placeholder_robot() -> void:
    var ivory := Color("#F9F5E9")
    var aqua := Color("#79D9E1")
    var navy := Color("#214B60")
    var orange := Color("#F5BF7C")
    _part("Body", SphereMesh.new(), ivory, Vector3(0, 0.05, 0), Vector3(0.51, 0.47, 0.39))
    _part("Head", SphereMesh.new(), ivory, Vector3(0, 0.52, -0.035), Vector3(0.52, 0.44, 0.43))
    _part("Face", SphereMesh.new(), navy, Vector3(0, 0.55, -0.33), Vector3(0.42, 0.28, 0.13))
    _part("LeftEye", SphereMesh.new(), aqua, Vector3(-0.17, 0.58, -0.456), Vector3(0.09, 0.14, 0.05))
    _part("RightEye", SphereMesh.new(), aqua, Vector3(0.17, 0.58, -0.456), Vector3(0.09, 0.14, 0.05))
    _part("LeftHand", SphereMesh.new(), orange, Vector3(-0.50, 0.02, 0), Vector3(0.17, 0.18, 0.20))
    _part("RightHand", SphereMesh.new(), orange, Vector3(0.50, 0.02, 0), Vector3(0.17, 0.18, 0.20))
    _part("LeftFoot", SphereMesh.new(), navy, Vector3(-0.23, -0.47, -0.10), Vector3(0.21, 0.13, 0.25))
    _part("RightFoot", SphereMesh.new(), navy, Vector3(0.23, -0.47, -0.10), Vector3(0.21, 0.13, 0.25))
    var antenna := CylinderMesh.new()
    antenna.height = 0.28
    antenna.top_radius = 0.045
    antenna.bottom_radius = 0.045
    _part("Antenna", antenna, navy, Vector3(0, 1.02, 0), Vector3.ONE)
    _part("AntennaStarPlaceholder", SphereMesh.new(), orange, Vector3(0, 1.20, 0), Vector3(0.12, 0.12, 0.12))


func _part(part_name: String, part_mesh: Mesh, tint: Color, at: Vector3, size: Vector3) -> void:
    var instance := MeshInstance3D.new()
    instance.name = part_name
    instance.mesh = part_mesh
    instance.position = at
    instance.scale = size
    var material := StandardMaterial3D.new()
    material.albedo_color = tint
    material.roughness = 0.72
    instance.material_override = material
    _visual.add_child(instance)
