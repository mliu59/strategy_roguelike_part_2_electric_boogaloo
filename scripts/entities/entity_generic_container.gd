extends Node
class_name EntityGenericContainer

var _scene_map: Dictionary = {}
func _load_scenes() -> void:
	for scene_path: String in _get_scenes():
		var _name = scene_path.split("/")[-1].replace(".tscn", "")
		if ResourceLoader.exists(scene_path):
			_scene_map[_name] = ResourceLoader.load(scene_path)

func _ready() -> void:
	for n in get_children():
		remove_child(n)
		n.queue_free()
	_load_scenes()
	
func _get_scenes() -> Array:
	return []
