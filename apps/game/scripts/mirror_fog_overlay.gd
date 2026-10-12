extends Node3D
class_name MirrorFogOverlay

# A single Godot MultiMesh per fog state; no 4096 SceneTree nodes and no
# homegrown renderer. Tile positions use the canonical 2m world contract.
const GEOM = preload("res://scripts/mirror_geometry.gd")
const FOG = preload("res://scripts/mirror_fog_of_war.gd")
const BOARD: int = FOG.BOARD
const AREA: int = BOARD * BOARD

var unexplored_mesh: MultiMesh
var remembered_mesh: MultiMesh
var unexplored_node: MultiMeshInstance3D
var remembered_node: MultiMeshInstance3D
var counts: Dictionary = {"unexplored": 0, "remembered": 0}

func _create_layer(label: String, tint: Color) -> MultiMeshInstance3D:
    var material := StandardMaterial3D.new()
    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    material.cull_mode = BaseMaterial3D.CULL_DISABLED
    material.albedo_color = tint
    var plane := PlaneMesh.new()
    plane.size = Vector2(GEOM.METERS_PER_TILE, GEOM.METERS_PER_TILE)
    plane.material = material
    var multi := MultiMesh.new()
    multi.transform_format = MultiMesh.TRANSFORM_3D
    multi.mesh = plane
    multi.instance_count = AREA
    multi.visible_instance_count = 0
    var node := MultiMeshInstance3D.new()
    node.name = label
    node.multimesh = multi
    node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    add_child(node)
    return node

func _ready() -> void:
    unexplored_node = _create_layer(
        "UndiscoveredShroud", Color(0.018, 0.025, 0.05, 0.97))
    remembered_node = _create_layer(
        "ExploredOutOfSight", Color(0.025, 0.045, 0.075, 0.62))
    unexplored_mesh = unexplored_node.multimesh
    remembered_mesh = remembered_node.multimesh

func render(fog: MirrorFogOfWar, slot: int = 0) -> void:
    if unexplored_mesh == null or remembered_mesh == null:
        return
    var dark: int = 0
    var dimmed: int = 0
    for y in range(BOARD):
        for x in range(BOARD):
            var cell := Vector2i(x, y)
            if not fog.is_discovered(cell, slot):
                unexplored_mesh.set_instance_transform(
                    dark, Transform3D(Basis.IDENTITY, GEOM.tile_to_world(cell, 0.35)))
                dark += 1
            elif not fog.is_visible(cell, slot):
                remembered_mesh.set_instance_transform(
                    dimmed, Transform3D(Basis.IDENTITY, GEOM.tile_to_world(cell, 0.33)))
                dimmed += 1
    unexplored_mesh.visible_instance_count = dark
    remembered_mesh.visible_instance_count = dimmed
    counts = {"unexplored": dark, "remembered": dimmed}

func set_spectator(enabled: bool) -> void:
    visible = not enabled
