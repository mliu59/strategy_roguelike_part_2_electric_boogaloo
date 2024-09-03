extends ComponentEntityBase

func update_status_bar(name: String, val: float, max: float):
	get_node(name).set_ratio(val / max)
