extends ColorRect

#TODO move this into a component

func _init() -> void:
	toggle_display(false)

func update_text(input: String) -> void:
	$text_label.text = input

func toggle_display(val: bool) -> void:
	self.visible = val

func _show_unit_hover_info_box(text: String) -> void:
	#get_parent().set_global_position(get_global_mouse_position())
	update_text(text)
	toggle_display(true)
	
func _close_unit_hover_info_box() -> void:
	toggle_display(false)
