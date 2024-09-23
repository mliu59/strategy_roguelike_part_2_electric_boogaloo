extends TileMapLayer

var _tiles: TileContainer

signal clicked_tile(tile: Tile)
signal clicked_non_tile()
signal mouse_hover(tile: Tile)

func set_map(tiles: TileContainer) -> void:
	_tiles = tiles
	_populate_new_map()

func clear_map() -> void:
	clear()
	_clear_highlights()

func clear_draw_path() -> void:
	$hextile_arrows.clear()
	$hextile_tilemap_target_effect.clear()

func _clear_highlights() -> void:
	for child in get_children():
		if child is TileMapLayer:
			child.clear()
		elif child is Line2D:
			child.clear_points()

func _highlight_moveable_tile(tile: Tile) -> void:
	if (not tile.is_occupied()) or tile.get_occupying_unit().is_controllable():
		$hextile_tilemap_movable_tiles.set_cell(tile.tilemap_coordinates, 0, Vector2(0, 3))
	else:
		$hextile_tilemap_movable_tiles_enemy.set_cell(tile.tilemap_coordinates, 0, Vector2(0, 3))

func _highlight_tile_dimmed(tile: Tile) -> void:
	$hextile_tilemap_effects_dimmed.set_cell(tile.tilemap_coordinates, 0, Vector2(0, 3))
	
func _highlight_tile(tile: Tile) -> void:
	$hextile_tilemap_effects.set_cell(tile.tilemap_coordinates, 0, Vector2(0, 3))
	
func _highlight_attack_target(tile: Tile) -> void:
	$hextile_tilemap_target_effect.modulate = Color(1, 0, 0, 1)
	$hextile_tilemap_target_effect.set_cell(tile.tilemap_coordinates, 0, Vector2(0, 2))
	
func _highlight_deployment_target(tile: Tile) -> void:
	$hextile_tilemap_target_effect.modulate = Color(0, 1, 0, 1)
	$hextile_tilemap_target_effect.set_cell(tile.tilemap_coordinates, 0, Vector2(0, 2))
	
func _draw_tilemappath(path: TilemapPath, hostile: bool) -> void:
	$hextile_arrows.draw_path(path.path, hostile)

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
		if get_cell_source_id(cell) == -1:
			continue
		var atlas_coords = get_cell_atlas_coords(cell)
		var tile = Tile.new()
		tile.init(cell, atlas_coords)
		output.add(tile)
	return output

var last_mouse_hover: Tile = null

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
	elif event is InputEventMouseMotion:
		var tile: Tile = get_mouse_tile()
		if tile == null:
			return
		if last_mouse_hover == null or tile != last_mouse_hover:
			last_mouse_hover = tile
			mouse_hover.emit(get_mouse_tile())
