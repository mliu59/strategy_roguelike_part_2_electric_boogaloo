class_name Tile

const DEFAULT_ATLAS_ID = 0
const MAX_GRID_SIZE: int = TilemapGenerator.MAX_GRID_SIZE

@export var default_travel_weight: float = 1.0
@export var higher_travel_weight: float = 1.0

var travel_weight: float = default_travel_weight
var tilemap_coordinates: Vector2
var tileset_atlas_coordinates: Vector2
var atlas_id: int
var uid: int
var _neighbors: Array
var global_position: Vector2
var _occupied_unit: EntityUnit = null


func add_neighbor(tile: Tile) -> void:
	_neighbors.append(tile)
		
func get_neighbors() -> Array:
	return _neighbors

func init(map_coords: Vector2, atlas_coords: Vector2) -> void:
	tilemap_coordinates = map_coords
	tileset_atlas_coordinates = atlas_coords
	atlas_id = DEFAULT_ATLAS_ID
	uid = _get_uid_from_coords(tilemap_coordinates)
	travel_weight = _get_travel_weight()

func get_uid() -> int:
	return uid


func _get_uid_from_coords(map_coords: Vector2) -> int:
	var _0 = map_coords[0] * MAX_GRID_SIZE
	var _1 = map_coords[1] * 1
	if _0 < 0:
		_0 = -map_coords[0] * MAX_GRID_SIZE ** 3
	if _1 < 0:
		_1 = -map_coords[1] * MAX_GRID_SIZE ** 2
	return _0 + _1

func _get_coords_from_uid(_uid: int) -> Vector2:
	var nx: int = _uid / (MAX_GRID_SIZE ** 3)
	var ny: int = (_uid % (MAX_GRID_SIZE ** 3)) / (MAX_GRID_SIZE ** 2)
	var px: int = (nx % (MAX_GRID_SIZE ** 2)) / (MAX_GRID_SIZE)
	var py: int = ny % (MAX_GRID_SIZE)
	var output = Vector2(px, py)
	if nx > 0:
		output[0] = -nx
	if ny > 0:
		output[1] = -ny
	return output

func occupy_tile(unit: EntityUnit) -> bool:
	if is_occupied():
		return false
	_occupied_unit = unit
	return true
func clear_unit() -> void:
	_occupied_unit = null
func is_occupied() -> bool:
	return _occupied_unit != null
func get_occupying_unit() -> EntityUnit:
	return _occupied_unit

func is_traversable() -> bool:
	assert(tileset_atlas_coordinates != null)
	# abstract / placeholder cells are not traversable
	if tileset_atlas_coordinates[0] == 0:
		return false
	# col 2 on atlas is reserved for untraversable tiles
	if tileset_atlas_coordinates[0] == 2:
		return false
	
	return true

func _get_travel_weight() -> float:
	assert(tileset_atlas_coordinates != null)
	if tileset_atlas_coordinates[0] == 3:
		return higher_travel_weight
	return default_travel_weight

func get_travel_weight() -> float:
	return travel_weight


func get_adj_dir(other: Tile) -> int:
	var a := self.tilemap_coordinates
	var b := other.tilemap_coordinates
	if a[0] - 1 == b[0]:
		if int(a[0]) % 2 == 0:
			if a[1] == b[1]:
				return 1
			if a[1] + 1 == b[1]:
				return 2
		else:
			if a[1] - 1 == b[1]:
				return 1
			if a[1] == b[1]:
				return 2
	if a[0] == b[0]:
		if a[1] - 1 == b[1]:
			return 0
		if a[1] + 1 == b[1]:
			return 3
	if a[0] + 1 == b[0]:
		if int(a[0]) % 2 == 0:
			if a[1] == b[1]:
				return 5
			if a[1] + 1 == b[1]:
				return 4
		else:
			if a[1] - 1 == b[1]:
				return 5
			if a[1] == b[1]:
				return 4
	return -1
