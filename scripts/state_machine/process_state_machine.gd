extends ProcessStateMachineBase
class_name ProcessStateMachine


var turn_counter := 1

func connect_unit_signals() -> void:
	for child in get_tree().get_nodes_in_group("all_units"):
		child.get_node("component_entity_movement").connect("action_to_tile_complete", _on_action_to_tile_complete)
func _on_clicked_tile(tile: Tile):
	_get_current_state().clicked_tile(tile)
func _on_clicked_non_tile():
	_get_current_state().clicked_non_tile()
func _on_action_to_tile_complete():
	_get_current_state().action_to_tile_complete()
func _on_clicked_end_turn():
	_get_current_state().clicked_end_turn()
func _on_mouse_hover(tile: Tile):
	_get_current_state().mouse_hover(tile)
