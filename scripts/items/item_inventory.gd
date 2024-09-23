extends Node

var _all_items := {}

func _ready() -> void:
	for item in _json_read(_get_sibling_file(self.get_script().get_path(), "items_meta.json"))['data']:
		_all_items[item["item_name"]] = item
	_clear_item_display_gui()

func _get_sibling_file(filepath: String, sibling_file_name: String) -> String:
	var path_arr = filepath.reverse().split("/", true, 1)
	path_arr[0] = sibling_file_name.reverse()
	return "/".join(path_arr).reverse()

func _json_read(filename: String) -> Dictionary:
	var output: Dictionary = {"path": filename}
	var file = FileAccess.open(filename, FileAccess.READ)
	var json_object = JSON.new()
	if json_object.parse(file.get_as_text()) != OK:
		get_tree().call_group("log", "logerr", "Error reading JSON at %s" % filename)
		return output
	output["data"] = json_object.get_data()
	return output

func add_item(item_name: String) -> void:
	if item_name not in _all_items:
		get_tree().call_group("log", "logerr", "No item with name " % item_name)
		return
	
	var item_instance: Item_Base = load("res://scenes/items/generic_item.tscn").instantiate()
	item_instance.init(_all_items[item_name])
	add_child(item_instance)
	
	var temp: TextureRect = TextureRect.new()
	var item_sprite_obj: TextureRect = item_instance.get_node("item_sprite")
	temp.set_texture(item_sprite_obj.texture)
	temp.set_tooltip_text(item_instance.get_tooltip_content())
	get_tree().get_first_node_in_group("gui_item_display").add_child(temp)
	
	get_tree().call_group("player_units", "apply_item_effect", item_instance)

func _clear_item_display_gui():
	for child: Node in get_tree().get_first_node_in_group("gui_item_display").get_children():
		child.queue_free()
