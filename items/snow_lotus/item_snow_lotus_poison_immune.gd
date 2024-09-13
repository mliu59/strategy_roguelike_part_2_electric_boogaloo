extends Item_Base
class_name Item_PoisonImmune

func get_item_name() -> String:
	return "snow_lotus"
func _populate_status() -> void:
	applied_statuses.append(StatusEffect_PoisonImmune.new())
func get_tooltip_content() -> String:
	return "SNOW LOTUS\nGrants your troops immunity against poisonous attacks."
