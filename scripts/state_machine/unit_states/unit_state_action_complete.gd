extends ProcessState

@onready var entity_obj: EntityUnit = get_node("../../..")
@onready var movement_comp: ComponentEntityBase = get_node("../..")

const action_state_map = {
	"ranged_interact": "unit_state_ranged_attack",
	"interact": "unit_state_attack",
	"move": "unit_state_move"
}

func enter(_data: Dictionary) -> void:
	var action_queue: Array = movement_comp.action_queue
	if action_queue.is_empty():
		transitioned.emit(self, "unit_state_idle", {})
		return
	var action: Dictionary = action_queue.pop_front()
	transitioned.emit(self, action_state_map[action['action']], action)
	
