extends ComponentEntityBase

var effects_map: Dictionary = {}

func _component_ready() -> void:
	for child: StatusEffect in get_children():
		effects_map[child.get_status_name()] = child

func apply_offensive_statuses(attk: Attack) -> Attack:
	for child: StatusEffect in get_children():
		attk = child.apply_offensive_status(attk)
	return attk
func apply_defensive_statuses(attk: Attack) -> Attack:
	for child: StatusEffect in get_children():
		attk = child.apply_defensive_status(attk)
	return attk
func apply_end_turn_statuses() -> Attack:
	var attk: Attack = Attack.new()
	for child: StatusEffect in get_children():
		attk = child.apply_end_turn_status(attk)
	return attk

func decrement_turn_timers() -> void:
	for child: StatusEffect in get_children():
		child.decrement_turn_counter()

func get_string() -> String:
	var output: PackedStringArray = []
	for child: StatusEffect in get_children():
		output.append(child.get_status_name() + ": " + str(child.get_turns_remaining()))
	return "\n"+"\n".join(output)

func apply_statuses(arr: Array) -> void:
	for status: StatusEffect in arr:
		if status.get_turns_remaining() <= 0 and not status.is_permanent():
			continue
		var found: bool = false
		for child_status: StatusEffect in get_children():
			if status.get_status_name() == child_status.get_status_name():
				found = true
				child_status.add_turn_counter(status.get_turns_remaining())
		if not found:
			var node: StatusEffect = status.duplicate()
			node.add_turn_counter(status.get_turns_remaining())
			add_child(node)
