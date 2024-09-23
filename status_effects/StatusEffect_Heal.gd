extends StatusEffect
class_name StatusEffect_Heal

const HEAL_OVER_END_TURN: int = 1

func get_status_name() -> String:
	return "Healing"

func apply_end_turn_status(attk: Attack) -> Attack:
	attk.heal_amount += HEAL_OVER_END_TURN
	return attk
