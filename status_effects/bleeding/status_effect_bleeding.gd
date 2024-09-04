extends StatusEffect
class_name StatusEffect_Bleeding

const DMG_OVER_END_TURN: int = 1

func get_status_name() -> String:
	return "Bleeding"

func apply_end_turn_status(attk: Attack) -> Attack:
	attk.damage_amount += DMG_OVER_END_TURN
	return attk
