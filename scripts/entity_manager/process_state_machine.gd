extends Node

class_name ProcessStateMachine

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

func connect_unit_signals() -> void:
	for child in get_tree().get_nodes_in_group("player_units"):
		child.get_node("component_entity_movement").connect("action_to_tile_complete", _on_action_to_tile_complete)


func on_child_transition(state: ProcessState, new_state_name: String, data: Dictionary):
	if not state.active:
		return 
	#if state != current_state:
		#print("??")
		#return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	# Clean up the previous state
	if current_state:
		current_state.exit()
	
	# Intialize the new state
	new_state.active = true
	new_state.enter(data)
	
	current_state = new_state

func _on_clicked_tile(tile: Tile):
	current_state.clicked_tile(tile)
func _on_clicked_non_tile():
	current_state.clicked_non_tile()
func _on_action_to_tile_complete():
	current_state.action_to_tile_complete()

func _on_clicked_end_turn():
	current_state.clicked_end_turn()
