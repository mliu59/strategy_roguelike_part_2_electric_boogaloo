extends Node
class_name Item_Base

var applied_statuses: Array = []
var _data := {}

# data_example:
#{
	#"item_name": "wooden_round_shield",
	#"item_type": 0,
	#"display_name": "WOODEN ROUND SHIELD",
	#"effect_description": "Grants your troops 1 extra defense.",
	#"lore_description": "An old and tattered wooden shield. Its glory days are clearly long past, but it's better than nothing.",
	#"status_effects": ["StatusEffect_Defense"],
	#"sprite_file": "wooden_round_shield.png"
#}

enum item_types {BATTLE, CAMPAIGN}

func init(data: Dictionary) -> void:
	_data = data
	_populate_status()
	_get_item_sprite()

func get_item_name() -> String:
	return _data['item_name']
func get_tooltip_content() -> String:
	return "\n".join([_data['display_name'], _data['effect_description'], _data['lore_description']])
func get_item_type() -> int:
	return _data['item_type']

func _populate_status() -> void:
	if 'status_effects' not in _data:
		return
	for status_str in _data['status_effects']:
		var script_path = "res://status_effects/" + status_str + ".gd"
		if not FileAccess.file_exists(script_path):
			print("%s does not exist" % script_path)
			continue
		var instance: StatusEffect = load(script_path).new()
		applied_statuses.append(instance)

func _get_item_sprite() -> void:
	var sprite_path = "res://assets/items/" + _data['sprite_file']
	if not FileAccess.file_exists(sprite_path):
		print("%s does not exist" % sprite_path)
		return
	$item_sprite.texture = ImageTexture.create_from_image(Image.load_from_file(sprite_path))
