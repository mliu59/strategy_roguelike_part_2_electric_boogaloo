extends ComponentEntityBase

var bar_orders: Array = [
	"movement_bar",
	"health_bar",
]

func _component_ready() -> void:
	_update_x_positions()

func update_status_bar(_name: String, _val: float, _max: float):
	get_node(_name).set_ratio(_val / _max)

func _update_x_positions() -> void:
	var arr: Array = []
	for item in bar_orders:
		if get_node(item).visible:
			arr.append(item)
	var max_y_pos = null
	for child in get_children():
		if max_y_pos == null or child.position[1] > max_y_pos:
			max_y_pos = child.position[1]
	for ind in range(len(arr)):
		var node = get_node(arr[ind])
		node.position[1] = max_y_pos - ind * (node.OUTER_BAR_HEIGHT-1)

func toggle_hostile(val: bool) -> void:
	$movement_bar.visible = !val
	_update_x_positions()
