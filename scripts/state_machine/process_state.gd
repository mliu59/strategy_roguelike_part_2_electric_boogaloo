class_name ProcessState
extends Node

signal transitioned(state: ProcessState, new_state_name: String, data: Dictionary)

var active = false

func _ready():
	_state_ready()
func enter(_data: Dictionary):
	pass
func _state_ready() -> void:
	pass

func exit():
	# get_tree().call_group("hextile_map", "_clear_highlights")
	active = false
	#print("exit ", self.name)

func clicked_tile(_tile: Tile):
	pass
func clicked_non_tile():
	pass
func action_to_tile_complete():
	pass
func clicked_end_turn():
	pass
