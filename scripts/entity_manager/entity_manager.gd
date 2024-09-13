extends EntityGenericContainer

var unit_uid_counter: int = 0

func _get_scenes() -> Array:
	return [
		"res://scenes/units/entity_unit_commander.tscn",
		"res://scenes/units/entity_unit_longbowman.tscn"
	]
	
func spawn_unit_at_tile(unit_name	: String,
						faction		: int,
						start_tile  : Tile) -> bool:
	if unit_name not in _scene_map:
		print("Did not find unit with name ", unit_name)
		return false
	if not start_tile.is_traversable() or start_tile.is_occupied():
		print("tile cant be used")
		return false
	var unit: EntityUnit = _scene_map[unit_name].instantiate()
	unit.set_faction(faction)
	unit.set_uid(unit_uid_counter)
	unit.set_unit_name(unit_name)
	unit_uid_counter+=1
	unit.set_starting_tile(start_tile)
	add_child(unit)
	return true
	
