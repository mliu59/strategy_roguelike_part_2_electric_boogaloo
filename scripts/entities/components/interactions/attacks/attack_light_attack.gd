extends BaseEntityInteraction

func get_interaction_name() -> String:
	return "LightAttack"

func _get_attack() -> Attack:
	var attk: Attack = Attack.new()
	attk.init(	_i.get_base_damage(), 
				attk.attack_types.NORMAL)
	return attk
