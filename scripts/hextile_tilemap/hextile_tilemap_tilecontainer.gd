extends Node
class_name TileContainer

var map : Dictionary = {}
var _placeholder_tile = Tile.new()
var random = RandomNumberGenerator.new()

func length() -> int:
	return len(map)

func add(tile: Tile) -> void:
	map[tile.get_uid()] = tile

func get_tile(coords: Vector2) -> Tile:
	return map[_placeholder_tile._get_uid_from_coords(coords)]

func has_tile(coords: Vector2) -> bool:
	return _placeholder_tile._get_uid_from_coords(coords) in map

func get_random_tile() -> Tile:
	var ind = random.randi_range(0, length()-1)
	return map[map.keys()[ind]]
	
func get_random_empty_traversable_tile() -> Tile:
	var tile_arr: Array = []
	for key in map:
		var tile: Tile = map[key]
		if tile.is_traversable() and not tile.is_occupied():
			tile_arr.append(tile)
	if len(tile_arr):
		return tile_arr[random.randi_range(0, len(tile_arr)-1)]
	get_tree().call_group("log", "logerr", "No tiles that meet empty criteria")
	return get_random_tile()

func get_tile_array() -> Array:
	var output = []
	for key in map:
		output.append(map[key])
	return output
