extends BaseEntityInteraction

func get_interaction_name() -> String:
	return "LightAttack"
func execute_action(target: EntityUnit) -> void:
	var attk: Attack = Attack.new()
	attk.init(	_entity_interaction_component_reference.base_damage, 
				attk.attack_types.NORMAL)
	target.apply_attack(attk)
