extends ComponentEntityBase

var effects_map: Dictionary = {}

func _component_ready() -> void:
	for child: StatusEffect in get_children():
		effects_map[child.get_status_name()] = child

func process_status_effects(attk: Attack) -> Status:
	var status = Status.new()
	status.resolved_damage = attk.damage_amount
	for effect in attk.applied_effects:
		effects_map[effect].add_turn_counter()
	return status

func decrement_turn_timers() -> void:
	for child: StatusEffect in get_children():
		child.decrement_turn_counter()

func get_string() -> String:
	var output: PackedStringArray = []
	for child: StatusEffect in get_children():
		output.append(child.get_status_name() + ": " + str(child.turns_remaining))
	return "\n"+"\n".join(output)
