extends Sprite2D

class_name Sprite2DWithShadow

@export var shadow_angle: float
var has_shadow: bool = false

func _ready() -> void:
	get_node("../component_entity_movement/process_state_machine_unit/unit_state_move").connect(
		"flip_sprite", _on_component_entity_movement_flip_sprite)
	$shadow_sprite.offset = offset
	$shadow_sprite.texture = texture
	$shadow_sprite.skew = deg_to_rad(shadow_angle)
	has_shadow = true
	


func _on_component_entity_movement_flip_sprite(dir: bool) -> void:
	flip_h = dir
	if has_shadow:
		$shadow_sprite.flip_h = dir

func toggle_hostile_emblem(val: bool) -> void:
	$hostile_unit_emblem.visible = val
