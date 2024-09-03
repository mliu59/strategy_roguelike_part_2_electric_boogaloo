extends EntityGenericContainer

var tiles: TileContainer
func _get_scenes() -> Array:
	return [
		"res://scenes/world_decor/world_decor_white_flower.tscn"
	]

func set_map(_tiles: TileContainer) -> void:
	tiles = _tiles
	for tile: Tile in tiles.get_tile_array():
		var decor = _scene_map["world_decor_white_flower"].instantiate()
		add_child(decor)
		decor.global_position = tile.global_position
