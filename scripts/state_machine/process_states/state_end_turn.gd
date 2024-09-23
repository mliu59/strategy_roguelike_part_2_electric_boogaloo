extends ProcessState

signal end_of_turn()

func enter(_data: Dictionary):
	get_tree().call_group("log", "loginfo", "End of turn %s" % get_parent().turn_counter)
	get_parent().turn_counter += 1
	get_tree().call_group("all_units", "end_turn")	
	end_of_turn.emit()
	get_tree().call_group("log", "loginfo", "Starting turn %s" % get_parent().turn_counter)
	transitioned.emit(self, "state_select_unit", {})
