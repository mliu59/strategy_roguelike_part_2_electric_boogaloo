extends BaseEntityInteraction

func is_ranged() -> bool:
	return true
func get_interaction_name() -> String:
	return "LightRangedAttack"

func _get_attack() -> Attack:
	var attk: Attack = Attack.new()
	attk.init(	_i.get_base_damage(), 
				attk.attack_types.RANGED)
	return attk
