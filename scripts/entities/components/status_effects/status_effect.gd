extends Node
class_name StatusEffect

var active = false
var turns_remaining = 0

func get_status_name() -> String:
	return "NONE"
	
func decrement_turn_counter() -> void:
	turns_remaining = max(turns_remaining-1, 0)
	if turns_remaining <= 0:
		active = false
		
func add_turn_counter(value: int = 1) -> void:
	turns_remaining += value
