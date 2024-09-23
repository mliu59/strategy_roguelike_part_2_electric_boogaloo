extends ProcessState

var enemy_queue: Array = []

func enter(_data: Dictionary):
	get_tree().call_group("log", "loginfo", "Starting enemy turn...")
	get_tree().call_group("hextile_map", "_clear_highlights")
	enemy_queue = get_tree().get_nodes_in_group("enemy_units")
	if enemy_queue.is_empty():
		transitioned.emit(self, "state_end_turn", {})
		return
	get_enemy_and_execute_action()

func get_enemy_and_execute_action() -> void:
	var child: EntityUnit = enemy_queue.pop_front()
	var pathtile = child.ai_get_nearest_hostile_path()
	if pathtile != null:
		child.action_to_tile(pathtile)
	else:
		action_to_tile_complete()

func action_to_tile_complete() -> void:
	if enemy_queue.is_empty():
		transitioned.emit(self, "state_end_turn", {})
		return
	get_enemy_and_execute_action()
