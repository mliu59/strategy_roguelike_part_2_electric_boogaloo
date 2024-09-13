extends ProcessState

signal idle_state_reached()

@onready var movement_comp: ComponentEntityBase = get_node("../..")

func enter(_data: Dictionary) -> void:
	idle_state_reached.emit()
	
func _process(_delta: float) -> void:
	if not movement_comp.action_queue.is_empty() and active:
		transitioned.emit(self, "unit_state_action_complete", {})
