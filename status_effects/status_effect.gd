extends Node
class_name StatusEffect

enum category {ATTACK, DEFENSE}

var _turns_remaining := 0

func get_status_name() -> String:
	return "NULL"
func get_turns_remaining() -> int:
	return _turns_remaining
func is_permanent() -> bool:
	return false	
func decrement_turn_counter() -> void:
	if is_permanent(): return
	_turns_remaining = max(_turns_remaining-1, 0)
	if _turns_remaining <= 0:
		queue_free()
		
func add_turn_counter(value: int = 1) -> void:
	if is_permanent(): return
	_turns_remaining += value

func apply_offensive_status(attk: Attack) -> Attack:
	return attk
func apply_defensive_status(attk: Attack) -> Attack:
	return attk
func apply_end_turn_status(attk: Attack) -> Attack:
	return attk
