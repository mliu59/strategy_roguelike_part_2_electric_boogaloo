extends ProcessState

@onready var entity_obj: EntityUnit = get_node("../../..")
@onready var movement_comp: ComponentEntityBase = get_node("../..")
@onready var interact_comp: ComponentEntityBase = entity_obj.get_node("component_entity_interact")

func enter(_data: Dictionary) -> void:
	movement_comp._post_attack_process()
	interact_comp.apply_unit_interaction(_data['unit'])
	if not _data['tile'].is_occupied():
		transitioned.emit(self, "unit_state_move", {
			'action': 'move', 
			'tile': _data['tile'], 
			'zero_cost': true})
	else:
		transitioned.emit(self, "unit_state_action_complete", {})
	
