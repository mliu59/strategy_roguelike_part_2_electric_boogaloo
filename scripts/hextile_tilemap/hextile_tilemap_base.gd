extends TileMapLayer

var _tiles: TileContainer

signal clicked_tile(tile: Tile)
signal clicked_non_tile()

func set_map(tiles: TileContainer) -> void:
	_tiles = tiles
	_populate_new_map()

func clear_map() -> void:
	clear()
	_clear_highlights()

func _clear_highlights() -> void:
	 # make more modular
	$hextile_tilemap_effects.clear()
	$hextile_tilemap_movable_tiles.clear()
	$hextile_tilemap_movable_tiles_enemy.clear()
	$hextile_tilemap_path_effects.clear_points()

func _highlight_moveable_tile(tile: Tile) -> void:
	if (not tile.is_occupied()) or tile.get_occupying_unit().is_controllable():
		$hextile_tilemap_movable_tiles.set_cell(tile.tilemap_coordinates, 0, Vector2(0, 3))
	else:
		$hextile_tilemap_movable_tiles_enemy.set_cell(tile.tilemap_coordinates, 0, Vector2(0, 3))
		
	
func _highlight_tile(tile: Tile) -> void:
	$hextile_tilemap_effects.set_cell(tile.tilemap_coordinates, 0, Vector2(0, 3))
	
func _draw_tilemappath(path: TilemapPath) -> void:
	$hextile_tilemap_path_effects.clear_points()
	for tile in path.path:
		$hextile_tilemap_path_effects.add_point(
			$hextile_tilemap_path_effects.to_local(tile.global_position))

func get_mouse_tile() -> Tile:
	var vec = local_to_map(get_local_mouse_position())
	if not _tiles.has_tile(vec):
		return null
	return _tiles.get_tile(vec)

func _populate_new_map() -> void:
	clear_map()
	var tiles_arr = _tiles.get_tile_array()
	for tile: Tile in tiles_arr:
		set_cell(
			tile.tilemap_coordinates,
			tile.DEFAULT_ATLAS_ID,
			tile.tileset_atlas_coordinates)
		tile.global_position = to_global(map_to_local(tile.tilemap_coordinates))
	
	for tile: Tile in tiles_arr:
		var neighbor_cells = get_surrounding_cells(tile.tilemap_coordinates)
		for neighbor in neighbor_cells:
			if _tiles.has_tile(neighbor):
				tile.add_neighbor(_tiles.get_tile(neighbor))


func get_current_map() -> TileContainer:
	var output = TileContainer.new()
	for cell in get_used_cells():
		var source = get_cell_source_id(cell)
		if source == -1:
			continue
		var atlas_coords = get_cell_atlas_coords(cell)
		var tile = Tile.new()
		tile.init(cell, atlas_coords)
		output.add(tile)
	return output

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				var tile: Tile = get_mouse_tile()
				if tile == null:
					clicked_non_tile.emit()
				else:
					clicked_tile.emit(tile)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				clicked_non_tile.emit()
