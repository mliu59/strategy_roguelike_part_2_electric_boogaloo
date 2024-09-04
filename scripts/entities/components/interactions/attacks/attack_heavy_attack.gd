extends BaseEntityInteraction

func get_interaction_name() -> String:
	return "HeavyAttack"

func _get_attack() -> Attack:
	var attk: Attack = Attack.new()
	var bleed_effect = StatusEffect_Bleeding.new()
	bleed_effect.add_turn_counter(1)
	attk.init(	_i.base_damage * 2, 
				attk.attack_types.NORMAL,
				[bleed_effect])
	return attk
