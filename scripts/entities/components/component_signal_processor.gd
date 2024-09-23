extends ComponentEntityBase

func _component_ready() -> void:
	#_c_map["movement"].connect("clear_highlights", _on_clear_highlights)
	#_c_map["movement"].connect("highlight_cell", _on_highlight_tile)
	_c_map["movement"].connect("highlight_movable_cell", _on_highlight_moveable_tile)
	_c_map["movement"].connect("highlight_path", _on_draw_tilemap)
	_c_map["movement"].connect("clear_highlight_path", _on_clear_draw_path)

func _on_clear_draw_path():
	get_tree().call_group("hextile_map", "clear_draw_path")
	
func _on_clear_highlights():
	get_tree().call_group("hextile_map", "_clear_highlights")
	
func _on_highlight_moveable_tile(tile: Tile):
	get_tree().call_group("hextile_map", "_highlight_moveable_tile", tile)

func _on_highlight_tile(tile: Tile):
	get_tree().call_group("hextile_map", "_highlight_tile", tile)

func _on_draw_tilemap(path: TilemapPath, hostile: bool):
	get_tree().call_group("hextile_map", "_draw_tilemappath", path, hostile)

func _on_open_unit_tooltip():
	var output := "{unit_name} {unit_uid}\n"
	output += "Current tile: {unit_position}\n"
	output = output.format({
		"unit_name": get_parent().get_unit_name(),
		"unit_uid": get_parent().get_uid(),
		"unit_position": str(get_parent().current_tile.tilemap_coordinates),
	})
	
	var _string_container: PackedStringArray = []
	for _c in _c_map:
		var comp_str = _c_map[_c].get_string()
		if len(comp_str) > 0:
			_string_container.append("%s: %s" % [_c, comp_str])
	output += "\n".join(_string_container)
	get_tree().call_group("singleton_hover_info_box", "_show_unit_hover_info_box", output)
	
func _on_close_unit_tooltip():
	get_tree().call_group("singleton_hover_info_box", "_close_unit_hover_info_box")
