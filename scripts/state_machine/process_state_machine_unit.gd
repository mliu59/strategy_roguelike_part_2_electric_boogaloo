extends ProcessStateMachineBase
class_name ProcessStateMachineUnit

var started = false

func start_state_machine():
	current_state = $unit_state_idle
	current_state.active = true
	current_state.enter({})
