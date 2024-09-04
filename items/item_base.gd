extends Node
class_name Item_Base

var applied_statuses: Array = []

func get_item_name() -> String:
	return "NULL"
func _populate_status() -> void:
	pass

func _ready() -> void:
	_populate_status()
