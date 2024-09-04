extends Node
class_name BaseEntityInteraction

## Copy block
func get_interaction_name() -> String:
	return "BaseInteraction"
func _get_attack() -> Attack:
	var attk: Attack = Attack.new()
	return attk

func execute_action(_target: EntityUnit) -> void:
	var attk: Attack = _get_attack()
	attk = get_parent()._c_map['status_effects'].apply_offensive_statuses(attk)
	_target.apply_attack(attk)

var _i: Node

func set_interaction_component(node: Node) -> void:
	_i = node
	
