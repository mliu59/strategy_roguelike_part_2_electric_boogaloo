extends ComponentEntityBase

@export var health: int = 10
var max_health: int = health

signal entity_health_depleted()
signal health_changed(cur: int, max: int)

func _component_ready() -> void:
	_signal_status_bar_change()

func _on_damage(dmg: int) -> void:
	health = max(0, health - dmg)
	print("Unit health ", health)
	check_health_status()

func _on_heal(amt: int) -> void:
	health = min(max_health, health+amt)
	check_health_status()

func check_health_status() -> void:
	_signal_status_bar_change()
	if health <= 0:
		entity_health_depleted.emit()

func get_string() -> String:
	return "%s/%s" % [health, max_health]

func _signal_status_bar_change() -> void:
	_c_map['status_bars'].update_status_bar("health_bar", health, max_health)
