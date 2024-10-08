extends ComponentEntityBase

@export var _base_damage: int = 4
@export var _base_range: int = 6

var _container: PackedStringArray = []
var _action_dict: Dictionary = {}

func get_range() -> int:
	return _base_range
func get_base_damage() -> int:
	return _base_damage

func _component_ready() -> void:
	for child in get_children():
		if child is BaseEntityInteraction:
			add_action(child, -1, false)

func apply_unit_interaction(unit: EntityUnit):
	var self_desc = "" if get_parent().is_controllable() else "Enemy "
	var trgt_desc = "" if unit.is_controllable() else "Enemy "
	get_tree().call_group("log", "loginfo", 
		"%s%s (%s) attacked %s%s (%s)" % [
			self_desc, get_parent().get_display_name(), get_parent().get_uid(), 
			trgt_desc, unit.get_display_name(), unit.get_uid()])
	apply_actions(unit)

func get_string() -> String:
	var output: PackedStringArray = []
	for child: BaseEntityInteraction in get_children():
		output.append(child.get_interaction_name())
	return "\n"+"\n".join(output)

	
func add_action(node: BaseEntityInteraction, index=-1, add_as_child=true) -> bool:
	if not node.is_ranged() == get_parent().is_ranged_unit():
		get_tree().call_group("log", "logerr", 
			"Not a valid assignment of movesets, skipping... %s" % node.get_interaction_name())
		return false
	if node.get_interaction_name() in _action_dict:
		get_tree().call_group("log", "logerr", 
			"Unit already has action %s" % node.get_interaction_name())
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

func apply_actions(target: EntityUnit) -> void:
	for action_name in _container:
		var action_node: BaseEntityInteraction = _action_dict[action_name]
		if target == null:
			get_tree().call_group("log", "logerr", "NULL TARGET!")
			return
		if target.marked_for_clear:
			continue
		action_node.execute_action(target)
			
