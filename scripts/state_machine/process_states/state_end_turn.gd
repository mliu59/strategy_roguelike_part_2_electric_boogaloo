extends ProcessState

func enter(_data: Dictionary):
	#print("Entering end turn")
	get_tree().call_group("all_units", "end_turn")
	# await get_tree().create_timer(1).timeout
	print("######")
	print("NEW TURN")
	print("######")
	transitioned.emit(self, "state_select_unit", {})
