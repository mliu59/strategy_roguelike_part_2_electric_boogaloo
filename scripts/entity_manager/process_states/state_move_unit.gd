extends ProcessState

var unit: EntityUnit = null
var wait: bool = false

var count: int = 0

func enter(_data: Dictionary):
	count = 0
	print("entering unit move")
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
	unit.action_to_tile(tile)
	

func clicked_non_tile():
	get_tree().call_group("hextile_map", "_clear_highlights")
	transitioned.emit(self, "state_select_unit", {})


func clicked_end_turn():
	transitioned.emit(self, "state_enemy_turn", {})


func action_to_tile_complete():
	transitioned.emit(self, "state_select_unit", {})
