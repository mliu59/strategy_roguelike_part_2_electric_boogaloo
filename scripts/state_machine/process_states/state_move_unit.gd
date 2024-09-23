extends ProcessState

var unit: EntityUnit = null
var action_in_progress: bool = false

func enter(_data: Dictionary):
	get_tree().call_group("hextile_map", "_clear_highlights")
	unit = _data["selected_unit"]
	unit.show_current_paths()
	if unit.has_movement():
		get_tree().call_group("hextile_map", "_highlight_tile", unit.current_tile)
	else:
		get_tree().call_group("hextile_map", "_highlight_tile_dimmed", unit.current_tile)
	
func clicked_tile(tile: Tile):
	if tile.is_occupied() and tile.get_occupying_unit().is_controllable():
		get_tree().call_group("hextile_map", "_clear_highlights")
		enter({"selected_unit": tile.get_occupying_unit()})
		return
	get_tree().call_group("hextile_map", "_clear_highlights")
	unit.action_to_tile(tile)
	

func clicked_non_tile():
	get_tree().call_group("hextile_map", "_clear_highlights")
	transitioned.emit(self, "state_select_unit", {})


func clicked_end_turn():
	transitioned.emit(self, "state_enemy_turn", {})


func action_to_tile_complete() -> void:
	if unit == null:
		return
	if unit.action_in_progress:
		unit.action_in_progress = false
		if  get_tree().get_nodes_in_group("enemy_units").is_empty() or \
			get_tree().get_nodes_in_group("player_units").is_empty():
			transitioned.emit(self, "state_battle_end", {})
			return
		transitioned.emit(self, "state_select_unit", {})

func mouse_hover(tile: Tile):
	if unit == null or unit.action_in_progress:
		return
	unit.try_draw_path(tile)
