extends ProcessState

func enter(_data: Dictionary):
	get_tree().call_group("hextile_map", "_clear_highlights")
	#print("entering unit select")
	for child in get_tree().get_nodes_in_group("player_units"):
		#print("unit selected! %s %s" % [child._unit_uid, child.get_unit_name()])
		if child.has_movement():
			get_tree().call_group("hextile_map", "_highlight_tile", child.current_tile)
		else:
			get_tree().call_group("hextile_map", "_highlight_tile_dimmed", child.current_tile)
			

func clicked_tile(tile: Tile) -> void:
	if not tile.is_occupied():
		print("No unit at tile")
		return
	var unit: EntityUnit = tile.get_occupying_unit()
	if not unit.is_controllable():
		print("Not a controllable unit")
		return
	#print("selected unit ", unit.get_unit_name()," ", unit.get_remaining_movement())
	transitioned.emit(self, "state_move_unit", {"selected_unit": unit})
	
func clicked_end_turn():
	transitioned.emit(self, "state_enemy_turn", {})
