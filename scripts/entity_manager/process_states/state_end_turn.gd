extends ProcessState

func enter(_data: Dictionary):
	print("Entering end turn")
	get_tree().call_group("all_units", "end_turn")
	await get_tree().create_timer(0.1).timeout
	transitioned.emit(self, "state_select_unit", {})
