extends Line2D

class_name TilemapPath

var start_tile: Tile
var end_tile: Tile
var path: Array = []
var total_weight: float = 0

func copy_path(path_obj: TilemapPath) -> void:
	start_tile = path_obj.start_tile
	end_tile = path_obj.end_tile
	path = path_obj.path.duplicate()
	total_weight = path_obj.total_weight
	
func append_tile(tile: Tile) -> void:
	end_tile = tile
	path.append(tile)
	total_weight += tile.get_travel_weight()
