extends Item_Base
class_name Item_PoisonImmune

func get_item_name() -> String:
	return "__PoisonImmune_test"
func _populate_status() -> void:
	applied_statuses.append(StatusEffect_PoisonImmune.new())
