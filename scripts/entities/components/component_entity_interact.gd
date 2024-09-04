extends ComponentEntityBase

@export var base_damage: int = 4

var _container: PackedStringArray = []
var _action_dict: Dictionary = {}

func _component_ready() -> void:
	for child in get_children():
		if child is BaseEntityInteraction:
			add_action(child, -1, false)

func apply_unit_interaction(unit: EntityUnit):
	print("attack unit!! ", unit.get_uid(), unit.get_unit_name())
	apply_actions(unit)

func get_string() -> String:
	var output: PackedStringArray = []
	for child: BaseEntityInteraction in get_children():
		output.append(child.get_interaction_name())
	return "\n"+"\n".join(output)

	
func add_action(node: BaseEntityInteraction, index=-1, add_as_child=true) -> bool:
	if node.get_interaction_name() in _action_dict:
		print("Unit already has action ", node.get_interaction_name())
		return false
	_action_dict[node.get_interaction_name()] = node
	if index < 0 or index > len(_container):
		_container.append(node.get_interaction_name())
	else:
		_container.insert(index, node.get_interaction_name())
	if add_as_child:
		add_child(node)
	node.set_interaction_component(self)
	return true

func apply_actions(target: EntityUnit):
	for action_name in _container:
		var action_node: BaseEntityInteraction = _action_dict[action_name]
		if target != null:
			print("Applying ", action_node.get_interaction_name())
			action_node.execute_action(target)
		else:
			print("NULL TARGET!")
