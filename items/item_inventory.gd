extends Node

func _ready() -> void:
	pass
	
func init() -> void:
	for child: Node in get_tree().get_first_node_in_group("gui_item_display").get_children():
		child.queue_free()
	for child: Item_Base in get_children():
		var temp: TextureRect = TextureRect.new()
		var item_sprite_obj: TextureRect = child.get_node("item_sprite")
		temp.set_texture(item_sprite_obj.texture)
		temp.set_tooltip_text(child.get_tooltip_content())
		get_tree().get_first_node_in_group("gui_item_display").add_child(temp)
	
	
	for child: Item_Base in get_children():
		get_tree().call_group("player_units", "apply_item_effect", child)
	
