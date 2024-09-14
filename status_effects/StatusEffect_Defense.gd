extends StatusEffect
class_name StatusEffect_Defense

func get_status_name() -> String:
	return "Defense"
func is_permanent() -> bool:
	return true
func apply_defensive_status(attk: Attack) -> Attack:
	attk.damage_amount = max(0, attk.damage_amount-1)
	return attk
