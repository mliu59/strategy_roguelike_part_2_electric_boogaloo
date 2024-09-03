extends BaseEntityInteraction

func get_interaction_name() -> String:
	return "HeavyAttack"
func execute_action(target: EntityUnit) -> void:
	var attk: Attack = Attack.new()
	attk.init(	_entity_interaction_component_reference.base_damage * 2, 
				attk.attack_types.NORMAL,
				[
					attk.attack_applied_effects.BLEEDING
				])
	target.apply_attack(attk)
