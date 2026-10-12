extends RefCounted
class_name MirrorPhysicsLos3D

# Native physics diagnostics only. MatchState remains deterministic/authoritative:
# a renderer's frame timing, collision RID order, and raycast result must NOT
# independently decide if an RTS combat command succeeds.
const GEOM = preload("res://scripts/mirror_geometry.gd")

const LOS_MASK: int = 1
const SURFACE_MASK: int = 2
const OBSERVATION_HEIGHT_M: float = 1.5
const TRUNK_HEIGHT_M: float = 4.8

static func attach_tile(parent: Node3D, tile: Vector2i, kind: String) -> StaticBody3D:
    assert(kind == "tree" or kind == "water")
    var body := StaticBody3D.new()
    body.name = "%s_%d_%d" % [kind, tile.x, tile.y]
    body.collision_layer = LOS_MASK if kind == "tree" else SURFACE_MASK
    body.collision_mask = 0
    body.set_meta("scalfagus_obstacle", kind)
    body.position = GEOM.tile_to_world(tile)
    parent.add_child(body)
    var collision := CollisionShape3D.new()
    collision.name = "Collider"
    var shape := BoxShape3D.new()
    if kind == "tree":
        shape.size = Vector3(GEOM.METERS_PER_TILE, TRUNK_HEIGHT_M, GEOM.METERS_PER_TILE)
        collision.position.y = TRUNK_HEIGHT_M * 0.5
    else:
        shape.size = Vector3(GEOM.METERS_PER_TILE, 0.2, GEOM.METERS_PER_TILE)
        collision.position.y = 0.05
    collision.shape = shape
    body.add_child(collision)
    return body

static func trace(space: World3D, from_cell: Vector2i,
        to_cell: Vector2i, target_building_id: int = -1) -> Dictionary:
    # Only ray-test colliders that affect projectile visibility: trunks and
    # completed buildings. Ground/deck and water are not LOS occluders.
    var origin: Vector3 = GEOM.tile_to_world(from_cell, OBSERVATION_HEIGHT_M)
    var destination: Vector3 = GEOM.tile_to_world(to_cell, OBSERVATION_HEIGHT_M)
    if origin.is_equal_approx(destination):
        return {"clear": true, "hit_kind": "", "hit_entity_id": -1}
    var query := PhysicsRayQueryParameters3D.create(origin, destination)
    query.collision_mask = LOS_MASK
    query.collide_with_bodies = true
    query.collide_with_areas = false
    var hit: Dictionary = space.direct_space_state.intersect_ray(query)
    if hit.is_empty():
        return {"clear": true, "hit_kind": "", "hit_entity_id": -1}
    var collider: Object = hit.get("collider")
    if collider == null:
        return {"clear": false, "hit_kind": "unidentified", "hit_entity_id": -1}
    var owner_id: int = int(collider.get_meta("scalfagus_entity_id", -1))
    var kind: String = str(collider.get_meta("scalfagus_obstacle", "building"))
    return {
        "clear": target_building_id >= 0 and owner_id == target_building_id,
        "hit_kind": kind,
        "hit_entity_id": owner_id,
        "hit_position": hit.get("position", Vector3.ZERO)
    }
