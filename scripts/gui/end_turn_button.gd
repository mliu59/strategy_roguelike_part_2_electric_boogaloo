extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_button_press)
	
	
func _on_button_press() -> void:
	get_tree().call_group("global_turn_based_state_machine", "_on_clicked_end_turn")
