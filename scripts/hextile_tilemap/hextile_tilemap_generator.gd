extends Node

class_name TilemapGenerator

@export var map_size_x: int = 10
@export var map_size_y: int = 10
const MAX_GRID_SIZE = 1000


const DEFAULT_TILE_INDEX = Vector2(1, 0)
const DEFAULT_ATLAS_ID = 0

func generate_random_map() -> TileContainer:
	var output = TileContainer.new()
	
	for i in range(map_size_x):
		for j in range(map_size_y):
			var tile = Tile.new()
			tile.init(Vector2(i - map_size_x/2, j - map_size_y/2), DEFAULT_TILE_INDEX)
			output.add(tile)
	return output
