extends TileMapLayer

@export var hostile_color:= Color(1, 0, 0, 0.75)
@export var default_color:= Color(0, 0.2, 1, 0.75)

func _ready() -> void:
	clear()

func draw_path(path: Array, hostile: bool) -> void:
	clear()
	var dir_map: Array = []
	if len(path) < 2:
		return
	for i in range(len(path)):
		var cur: Tile = path[i]
		var dir_arrow := Vector2(-1, -1)
		if i != 0:
			dir_arrow[0] = _get_opposite_tileset(dir_map[i-1][1][1])
		if i != len(path)-1:
			var next: Tile = path[i+1]
			dir_arrow[1] = cur.get_adj_dir(next)
			if dir_arrow[1] == -1:
				print("Path not continuous")
				return
		dir_map.append([cur.tilemap_coordinates, dir_arrow])
	
	modulate = default_color if not hostile else hostile_color
	
	for arr in dir_map:
		set_cell(arr[0], 10, _convert_to_tileset(arr[1]))

func _get_opposite_tileset(dir: int) -> int:
	return (dir + 3) % 6

func _convert_to_tileset(v:Vector2) -> Vector2:
	const _dir_to_tileset_map: Dictionary = {
		0: 0,
		1: 1,
		5: 2,
		4: 3,
		2: 4,
		3: 5
	}
	var x:=0
	var y:=0
	if v[1] == -1:
		y = 6
	else:
		y = _dir_to_tileset_map[int(v[1])]
	if v[0] == -1:
		x = y
	else:
		x = _dir_to_tileset_map[int(v[0])]
	return Vector2(x, y)
