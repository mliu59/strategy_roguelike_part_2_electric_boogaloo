extends Node2D

class_name EntityUnit

# IDENTIFICATION
var _unit_uid: int = -1
var _unit_name: String = "NULL"

func set_unit_name(_name: String) -> void:
	_unit_name = _name
func get_unit_name() -> String:
	return _unit_name

func set_uid(id: int) -> void:
	_unit_uid = id
func get_uid() -> int:
	return _unit_uid
func is_valid() -> bool:
	return _unit_uid != -1

const PLAYER_FACTION = 0
const ENEMY_FACTION = 1
@export var faction_enum: int = ENEMY_FACTION
func is_hostile(_target: EntityUnit) -> bool:
	return (_target.get_faction() != get_faction())
func get_faction() -> int:
	return faction_enum
func set_faction(faction_id: int) -> void:
	faction_enum = faction_id
	if faction_enum == ENEMY_FACTION:
		$unit_sprite.toggle_hostile_emblem(true)
		#$unit_sprite.set_modulate(Color(1, 0.5, 0.5, 1))
		add_to_group("enemy_units")
		remove_from_group("player_units")
	else:
		$unit_sprite.toggle_hostile_emblem(false)
		#$unit_sprite.set_modulate(Color(1, 1, 1, 1))
		add_to_group("player_units")
		remove_from_group("enemy_units")
func is_controllable() -> bool:
	return get_faction() == 0

func _init() -> void:
	add_to_group("all_units")
	add_to_group("all_entities")

func _ready() -> void:
	# DEBUG
	set_faction(faction_enum)

# MOVEMENT
var current_tile: Tile

func set_starting_tile(tile: Tile) -> bool:
	_set_current_tile(tile)
	global_position = tile.global_position
	#print(global_position)
	return true

func get_remaining_movement() -> float:
	return $component_entity_movement.remaining_movement_points

func _set_current_tile(tile: Tile) -> void:
	current_tile = tile
	tile.occupy_tile(self)
	print("entered tile ", tile.tilemap_coordinates)
	
func show_current_paths() -> void:
	#get_tree().call_group("hextile_map", "_clear_highlights")
	#get_tree().call_group("hextile_map", "_highlight_tile", current_tile)
	$component_entity_movement.get_current_paths()
	$component_entity_movement.show_current_paths()
	

func ai_get_nearest_hostile_path() -> TilemapPath:
	return $component_entity_movement.ai_get_nearest_hostile_path()

func end_turn() -> void:
	$component_entity_movement.reset_movement()
	$component_entity_status_effects.decrement_turn_timers()

# HEALTH
func _on_health_depleted() -> void:
	print("unit death: ", _unit_uid)
	current_tile.clear_unit()
	self.queue_free()

func action_to_tile(tile: Tile):
	$component_entity_movement.action_to_tile(tile)

func apply_unit_interaction(unit: EntityUnit):
	$component_entity_interact.apply_unit_interaction(unit)

signal apply_damage(amt: int)
func apply_attack(attack: Attack):
	var process_status_effects: Status = $component_entity_status_effects.process_status_effects(attack)
	apply_damage.emit(process_status_effects.resolved_damage)

func has_movement() -> bool:
	return $component_entity_movement.remaining_movement_points > 0
	
