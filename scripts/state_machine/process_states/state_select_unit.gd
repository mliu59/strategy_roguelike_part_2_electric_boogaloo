extends ProcessState

func enter(_data: Dictionary):
	get_tree().call_group("hextile_map", "_clear_highlights")
	for child in get_tree().get_nodes_in_group("player_units"):
		if child.has_movement():
			get_tree().call_group("hextile_map", "_highlight_tile", child.current_tile)
		else:
			get_tree().call_group("hextile_map", "_highlight_tile_dimmed", child.current_tile)
			

func clicked_tile(tile: Tile) -> void:
	if not tile.is_occupied():
		return
	var unit: EntityUnit = tile.get_occupying_unit()
	if not unit.is_controllable():
		return
	transitioned.emit(self, "state_move_unit", {"selected_unit": unit})
	
func clicked_end_turn():
	transitioned.emit(self, "state_enemy_turn", {})
