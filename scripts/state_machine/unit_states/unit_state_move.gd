extends ProcessState

@onready var entity_obj: EntityUnit = get_node("../../..")
@onready var movement_comp: ComponentEntityBase = get_node("../..")
var target_tile: Tile = null

signal flip_sprite(dir: bool)
var flip_dir_h: bool = false

var zero_cost_move: bool = false

func enter(_data: Dictionary) -> void:
	active = true
	target_tile = _data['tile']
	zero_cost_move = "zero_cost" in _data
	
func _physics_process(delta: float) -> void:
	if not active:
		return
	
	var target: Vector2 = target_tile.global_position
	var err: Vector2 = target - entity_obj.global_position
	
	if flip_dir_h != (err[0] < 0):
		flip_dir_h = err[0] < 0
		flip_sprite.emit(flip_dir_h)
		
	entity_obj.global_position = entity_obj.global_position.move_toward(
		target, entity_obj.get_move_velocity() * delta)
	if entity_obj.global_position == target:
		if not zero_cost_move:
			movement_comp.deduct_movement_points(target_tile.travel_weight)
		entity_obj._set_current_tile(target_tile)
		transitioned.emit(self, "unit_state_action_complete", {})
