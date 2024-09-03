extends Node
class_name BaseEntityInteraction

## Copy block
func get_interaction_name() -> String:
	return "BaseInteraction"
func execute_action(_target: EntityUnit) -> void:
	pass



var _entity_interaction_component_reference: Node

func set_interaction_component(node: Node) -> void:
	_entity_interaction_component_reference = node
	
