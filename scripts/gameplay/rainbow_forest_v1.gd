extends "res://scripts/prototypes/lw3d_spike.gd"
## LW3D-V1 first playable authored Adventure:
## one bridge problem, two meaningful child-facing approaches, offline state, easy Rest.
## This inherits isolated prototype controls. Production replacement is gated on real Android QA.

const Progress = preload("res://scripts/gameplay/rainbow_mission_save.gd")
const TRIANGLE_POS := Vector3(-4.6, 0.0, -3.8)
const CIRCLE_POS := Vector3(-1.9, 0.0, -3.8)
const SEED_POS := Vector3(6.0, 0.0, -4.4)

var _progress: Dictionary = {}
var _seed_visual: MeshInstance3D
var _nova_scene: Node3D


func _ready() -> void:
    super._ready()
    name = "RainbowForestFirstAdventure"
    _progress = Progress.load_progress()
    _completed = bool(_progress.get("completed", false))
    _load_real_nova_model()
    _update_garden_growth()
    if _completed:
        _show_completed_world()
        _hud.set("hint", "Welcome back! Your rainbow bridge is still colorful.")
    else:
        _hud.set("hint", "Help the bridge: find a TRIANGLE or grow a SEED.")


func _make_bounded_world() -> void:
    super._make_bounded_world()
    # Remove the T1 golden beacon so there are no two competing mission goals.
    var obsolete_beacon := get_node_or_null("GoldBeacon")
    if obsolete_beacon != null:
        obsolete_beacon.queue_free()
    var obsolete_base := get_node_or_null("BeaconBase")
    if obsolete_base != null:
        obsolete_base.queue_free()

    var triangle := CylinderMesh.new()
    triangle.radial_segments = 3
    triangle.top_radius = 0.06
    triangle.bottom_radius = 0.55
    triangle.height = 0.75
    var triangular_marker := MeshInstance3D.new()
    triangular_marker.name = "MatchingTriangle"
    triangular_marker.mesh = triangle
    triangular_marker.position = TRIANGLE_POS + Vector3(0, 0.80, 0)
    triangular_marker.material_override = _material(Color("#78DBE3"))
    add_child(triangular_marker)

    _ball("RoundDistractor", CIRCLE_POS + Vector3(0, 0.72, 0), Vector3(0.50, 0.50, 0.50), Color("#F4B5D1"))
    _solid_box("TrianglePlatform", Vector3(2.0, 0.16, 2.0), TRIANGLE_POS + Vector3(0, 0.05, 0), Color("#D7EBDB"))
    _solid_box("RoundPlatform", Vector3(2.0, 0.16, 2.0), CIRCLE_POS + Vector3(0, 0.05, 0), Color("#F8E2E5"))

    _solid_box("GardenBed", Vector3(2.1, 0.32, 2.1), SEED_POS + Vector3(0, 0.05, 0), Color("#AF7B5B"))
    _seed_visual = _ball("GrowingSeed", SEED_POS + Vector3(0, 0.43, 0), Vector3(0.23, 0.18, 0.23), Color("#F6CB69"))

    for i in range(6):
        var j := float(i)
        _ball("RainbowFlower%d" % i, Vector3(-7.2 + j * 1.1, 0.25, -10.1),
            Vector3(0.32, 0.39, 0.32),
            [Color("#E6A6C6"), Color("#E8C764"), Color("#B5D98D")][i % 3])


func _load_real_nova_model() -> void:
    # The glTF source is real skinned 3D geometry, not a 2D character concept.
    var packed := load("res://assets/models/nova/nova.gltf") as PackedScene
    if packed == null:
        push_error("Nova glTF model is missing or failed import.")
        return
    _nova_scene = packed.instantiate() as Node3D
    if _nova_scene == null:
        push_error("Nova model must instantiate as Node3D.")
        return
    _nova_scene.name = "NovaSkinnedModel"
    _nova_scene.position = Vector3(0.0, -0.55, 0.0)
    _nova_scene.scale = Vector3(0.73, 0.73, 0.73)
    _player.add_child(_nova_scene)
    var old_visual := _player.get_node_or_null("PrototypeVisual") as Node3D
    if old_visual != null:
        old_visual.hide()
    var animator := _nova_scene.find_child("AnimationPlayer", true, false) as AnimationPlayer
    if animator != null:
        if animator.has_animation("Idle"):
            animator.play("Idle")
        elif animator.get_animation_list().size() > 0:
            animator.play(animator.get_animation_list()[0])


func _try_interact() -> void:
    if _completed:
        _hud.set("hint", "The rainbow bridge is restored! Rest or GARDEN.")
        return

    var at := _player.global_position
    if at.distance_to(TRIANGLE_POS) < 2.3:
        _complete_mission("shape")
    elif at.distance_to(CIRCLE_POS) < 2.3:
        _hud.set("hint", "That's a CIRCLE. The bridge needs a TRIANGLE!")
    elif at.distance_to(SEED_POS) < 2.5:
        var stage := int(_progress.get("seed_stage", 0))
        stage = mini(2, stage + 1)
        _progress["seed_stage"] = stage
        if stage == 1:
            _hud.set("hint", "A seed is planted! LOOK again to give it water.")
        else:
            _hud.set("hint", "It grew into a bridge vine!")
        _update_garden_growth()
        if stage >= 2:
            _complete_mission("nature")
        else:
            Progress.save_progress(_progress)
    else:
        _hud.set("hint", "Walk near the BLUE triangle or GREEN garden bed.")


func _complete_mission(approach: String) -> void:
    _completed = true
    _progress["completed"] = true
    _progress["approach"] = approach
    if not Progress.save_progress(_progress):
        push_warning("Rainbow mission visual completion could not be saved.")
    _show_completed_world()
    _hud.set("hint", "You helped the rainbow! You can Rest anytime.")


func _update_garden_growth() -> void:
    if _seed_visual == null:
        return
    var stage := int(_progress.get("seed_stage", 0))
    if stage >= 2:
        _seed_visual.scale = Vector3(0.60, 1.30, 0.60)
        _seed_visual.position.y = 1.02
        _seed_visual.material_override = _material(Color("#70C48D"))
    elif stage == 1:
        _seed_visual.scale = Vector3(0.35, 0.55, 0.35)
        _seed_visual.position.y = 0.62
        _seed_visual.material_override = _material(Color("#96D6A3"))


func _show_completed_world() -> void:
    _bridge.material_override = _material(Color("#DFA3E9"))
    for i in range(6):
        var color: Color = [
            Color("#F4A4A4"), Color("#F9CF82"), Color("#E2EF8A"),
            Color("#B0E9B8"), Color("#90DBEC"), Color("#D4B5F2")
        ][i]
        _ball("RestoredRainbow%d" % i,
            Vector3(-2.5 + float(i) * 1.0, 1.50 + sin(float(i) / 5.0 * PI) * 0.55, -9.5),
            Vector3(0.45, 0.35, 0.3), color)
