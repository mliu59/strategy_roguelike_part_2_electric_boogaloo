extends EntityGenericContainer

var unit_uid_counter: int = 0

func _get_scenes() -> Array:
	return [
		"res://scenes/units/entity_unit_commander.tscn",
		"res://scenes/units/entity_unit_longbowman.tscn"
	]

func _check_valid_spawn(unit_name	: String,
						  _faction	: int,
						  _start_tile: Tile) -> bool:
	if unit_name not in _scene_map:
		get_tree().call_group("log", "loginfo", "Did not find unit with name %s" % unit_name)
		return false
	return true

func _unit_instance(unit_name	: String,
						  faction	: int) -> EntityUnit:
	var unit: EntityUnit = _scene_map[unit_name].instantiate()
	unit.set_faction(faction)
	unit.set_uid(unit_uid_counter)
	unit.set_unit_name(unit_name)
	unit_uid_counter+=1
	return unit
	

func queue_for_deployment(unit_name	: String,
						  faction	: int) -> bool:
	var unit: EntityUnit = _unit_instance(unit_name, faction)
	unit.queue_for_deployment()
	add_child(unit)
	return true

func spawn_unit_at_tile(unit_name	: String,
						faction		: int,
						start_tile  : Tile) -> bool:
	if not _check_valid_spawn(unit_name, faction, start_tile):
		return false
	if not start_tile.is_traversable() or start_tile.is_occupied():
		get_tree().call_group("log", "loginfo", "Tile %s cant be used" % start_tile.tilemap_coordinates)
		return false
	var unit: EntityUnit = _unit_instance(unit_name, faction)
	unit.set_starting_tile(start_tile)
	add_child(unit)
	return true
