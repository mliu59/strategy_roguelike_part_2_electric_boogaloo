extends Node
class_name ComponentEntityBase

var _c_map: Dictionary = {}

func _ready() -> void:
	for node in get_parent().get_children():
		if node == self:
			continue
		var node_name: String = node.name
		var target_substring = "component_entity_"
		if len(node_name) <= len(target_substring):
			continue
		if node_name.substr(0, len(target_substring)) == target_substring:
			var subname: String = node_name.substr(len(target_substring))
			_c_map[subname] = node
	_component_ready()
	
	
func _component_ready() -> void:
	pass

func get_string() -> String:
	return ""
