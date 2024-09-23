extends ProcessState

signal end_of_battle()

func enter(_data: Dictionary):
	get_tree().call_group("log", "loginfo", "Battle ended in %s turns..." % get_parent().turn_counter)
	get_tree().call_group("all_units", "end_battle")
	if get_tree().get_nodes_in_group("enemy_units").is_empty():
		get_tree().call_group("log", "loginfo", "Victory!")
	elif get_tree().get_nodes_in_group("player_units").is_empty():
		get_tree().call_group("log", "loginfo", "Defeat!")
	end_of_battle.emit()
