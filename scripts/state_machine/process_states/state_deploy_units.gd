extends ProcessState

var unit: EntityUnit = null

func enter(_data: Dictionary):
	get_tree().call_group("hextile_map", "_clear_highlights")
	unit = null
	for child in get_tree().get_nodes_in_group("player_units"):
		if not child.deployed:
			unit = child
			get_tree().call_group("log", "loginfo", "Player deploying %s" % unit.get_display_name())
			break
	if unit == null:
		get_tree().call_group("log", "loginfo", "Player deployment complete!")
		transitioned.emit(self, "state_select_unit", {})
	
func mouse_hover(tile: Tile) -> void:
	get_tree().call_group("hextile_map", "_clear_highlights")
	unit.update_deployment_preview(tile)
	get_tree().call_group("hextile_map", "_highlight_deployment_target", tile)

func clicked_tile(tile: Tile) -> void:
	if tile.is_occupied():
		get_tree().call_group("log", "logerr", "Tile is occupied!")
		return
	if not tile.is_traversable():
		get_tree().call_group("log", "logerr", "Tile is not traversable/deployable!")
		return
	unit.deploy_at_tile(tile)
	transitioned.emit(self, "state_deploy_units", {})
