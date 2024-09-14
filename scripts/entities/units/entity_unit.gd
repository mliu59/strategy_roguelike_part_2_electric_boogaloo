extends Node2D

class_name EntityUnit

@export var _ranged: bool = false
@export var max_move_velocity: float = 400
var action_in_progress: bool = false
func get_move_velocity() -> float:
	return max_move_velocity

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
		_set_hostile_visuals(true)
		add_to_group("enemy_units")
		remove_from_group("player_units")
	else:
		_set_hostile_visuals(false)
		add_to_group("player_units")
		remove_from_group("enemy_units")
func is_controllable() -> bool:
	return get_faction() == 0

func _set_hostile_visuals(val: bool) -> void:
	$component_entity_status_bars.toggle_hostile(val)
	$unit_sprite.toggle_hostile_emblem(val)

func _init() -> void:
	add_to_group("all_units")
	add_to_group("all_entities")

func _remove_from_all_groups() -> void:
	remove_from_group("all_units")
	remove_from_group("all_entities")
	remove_from_group("enemy_units")
	remove_from_group("player_units")

func _ready() -> void:
	set_faction(faction_enum)

var current_tile: Tile

func set_starting_tile(tile: Tile) -> bool:
	_set_current_tile(tile)
	global_position = tile.global_position
	return true

func get_remaining_movement() -> float:
	return $component_entity_movement.remaining_movement_points
func has_movement() -> bool:
	return get_remaining_movement() > 0

func _set_current_tile(tile: Tile) -> void:
	if current_tile != null:
		current_tile.clear_unit()
	current_tile = tile
	tile.occupy_tile(self)
	
func show_current_paths() -> void:
	$component_entity_movement.get_current_paths()
	$component_entity_movement.show_current_paths()
	
func ai_get_nearest_hostile_path() -> Tile:
	return $component_entity_movement.ai_get_nearest_hostile_path()

func is_ranged_unit() -> bool:
	return _ranged

func action_to_tile(tile: Tile):
	action_in_progress = true
	$component_entity_movement.action_to_tile(tile)

func apply_attack(attack: Attack):
	var attk: Attack = $component_entity_status_effects.apply_defensive_statuses(attack)
	$component_entity_health._on_damage(attk.damage_amount)
	$component_entity_status_effects.apply_statuses(attk.applied_effects)

func end_turn() -> void:
	#print("end turn, ", _unit_uid)
	#print($component_entity_movement.has_attacked())
	$component_entity_movement.reset_movement()
	$component_entity_movement.reset_attacked_counter()
	apply_attack($component_entity_status_effects.apply_end_turn_statuses())
	$component_entity_status_effects.decrement_turn_timers()

func _on_health_depleted() -> void:
	_remove_from_all_groups()
	print("unit death! %s %s" % [_unit_uid, get_unit_name()])
	current_tile.clear_unit()
	self.queue_free()

func apply_item_effect(item: Item_Base) -> void:
	$component_entity_status_effects.apply_statuses(item.applied_statuses)
