extends Node2D

const _unit_scenes: Array = [
	"res://scenes/units/entity_unit_commander.tscn"
]
var _unit_scene_map: Dictionary = {}
var unit_uid_counter: int = 0

func _load_unit_scenes() -> void:
	for unit_scene_path: String in _unit_scenes:
		var unit_name = unit_scene_path.split("/")[-1].replace(".tscn", "")
		if ResourceLoader.exists(unit_scene_path):
			_unit_scene_map[unit_name] = ResourceLoader.load(unit_scene_path)

func _ready() -> void:
	for n in get_children():
		remove_child(n)
		n.queue_free()
	_load_unit_scenes()
	
func spawn_unit_at_tile(unit_name	: String,
						faction		: int,
						start_tile  : Tile) -> bool:
	if unit_name not in _unit_scene_map:
		print("Did not find unit with name ", unit_name)
		return false
	if not start_tile.is_traversable() or start_tile.is_occupied():
		print("tile cant be used")
		return false
	var unit: EntityUnit = _unit_scene_map[unit_name].instantiate()
	unit.set_faction(faction)
	unit.set_uid(unit_uid_counter)
	unit.set_unit_name(unit_name)
	unit_uid_counter+=1
	unit.set_starting_tile(start_tile)
	add_child(unit)
	return true
	
