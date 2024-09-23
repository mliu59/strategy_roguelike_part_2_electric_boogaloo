extends Node

class_name ProcessStateMachineBase

@export var initial_state : ProcessState

var current_state : ProcessState
var states : Dictionary = {}


func _ready():
	for child in get_children():
		if child is ProcessState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			
func start_state_machine():
	if initial_state:
		current_state = initial_state
		current_state.active = true
		current_state.enter({})

func on_child_transition(state: ProcessState, new_state_name: String, data: Dictionary):
	if not state.active: 
		return 
	var new_state = states.get(new_state_name.to_lower())
	if !new_state: 
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.active = true
	current_state.enter(data)

func _get_current_state() -> ProcessState:
	return current_state
