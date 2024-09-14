extends StatusEffect
class_name StatusEffect_PoisonImmune

func get_status_name() -> String:
	return "PoisonImmunity"
func is_permanent() -> bool:
	return true
func apply_defensive_status(attk: Attack) -> Attack:
	var count = 0
	#print(attk.applied_effects)
	for ind in range(len(attk.applied_effects)):
		if attk.applied_effects[ind - count] is StatusEffect_Poison:
			attk.applied_effects.pop_at(ind)
			count += 1
	#print(attk.applied_effects)
	return attk
