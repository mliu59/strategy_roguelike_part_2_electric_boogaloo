extends ProcessState

func enter(_data: Dictionary):
	print("Entering enemy turn...")
	get_tree().call_group("hextile_map", "_clear_highlights")
	ai_turn_logic()
	transitioned.emit(self, "state_end_turn", {})
	
func ai_turn_logic() -> void:
	for child: EntityUnit in get_tree().get_nodes_in_group("enemy_units"):
		var path = child.ai_get_nearest_hostile_path()
		if path != null:
			child.action_to_tile(path.end_tile)
			await get_tree().create_timer(1).timeout
