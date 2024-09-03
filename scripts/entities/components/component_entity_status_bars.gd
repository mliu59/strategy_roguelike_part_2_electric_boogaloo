extends ComponentEntityBase

func update_status_bar(_name: String, _val: float, _max: float):
	get_node(_name).set_ratio(_val / _max)
