extends Node

func _ready() -> void:
	pass
	
func apply_effects() -> void:
	for child: Item_Base in get_children():
		get_tree().call_group("player_units", "apply_item_effect", child)
