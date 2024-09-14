extends ComponentEntityBase

@export var max_movement_points: float = 5
var remaining_movement_points: float
var viable_paths: Dictionary
var viable_ranged_targets: Dictionary
var moving: bool = false
var current_tile: Tile
var flip_dir_h: bool = false

var _attacked: bool = false

var action_queue: Array = []

signal highlight_cell(tile: Tile)
signal highlight_path(path: TilemapPath)
signal clear_highlights
signal highlight_movable_cell(tile: Tile)
signal action_to_tile_complete()

func get_string() -> String:
	return "%s/%s atkd:%s" % [remaining_movement_points, max_movement_points, _attacked]

func _component_ready() -> void:
	$process_state_machine_unit/unit_state_idle.connect("idle_state_reached", _arrived_at_target)
	$process_state_machine_unit.start_state_machine()
	reset_movement()

func _signal_status_bar_change() -> void:
	_c_map['status_bars'].update_status_bar("movement_bar", remaining_movement_points, max_movement_points)

func zero_movement() -> void:
	remaining_movement_points = 0
	_signal_status_bar_change()

func reset_attacked_counter() -> void:
	_attacked = false

func reset_movement() -> void:
	remaining_movement_points = max_movement_points
	_signal_status_bar_change()

func get_current_paths() -> void:
	if get_parent().is_ranged_unit():
		viable_ranged_targets = find_all_ranged_targets(
			get_parent().current_tile, 
			_c_map['interact'].get_range())
	viable_paths = find_all_paths(get_parent().current_tile, remaining_movement_points)

func show_current_paths() -> void:
	for uid in viable_paths:
		var tile: Tile = viable_paths[uid].end_tile
		if tile == get_parent().current_tile: continue
		highlight_movable_cell.emit(tile)
	if not get_parent().is_ranged_unit():
		return 
	for uid in viable_ranged_targets:
		var tile: Tile = viable_ranged_targets[uid][0]
		if tile == get_parent().current_tile: continue
		highlight_movable_cell.emit(tile)

func _post_attack_process() -> void:
	_attacked = true
	zero_movement()
			
func _arrived_at_target() -> void:
	clear_highlights.emit()
	action_to_tile_complete.emit()

func has_attacked() -> bool:
	return _attacked

func action_to_tile(tile: Tile) -> void:
	if moving: return
	action_queue.clear()
	if get_parent().is_ranged_unit():
		if tile.get_uid() in viable_ranged_targets:
			action_queue.append({'action': 'ranged_interact', 'tile': tile, 'unit': tile.get_occupying_unit()})
			return
	if not tile.is_traversable(): 			return
	if not tile.get_uid() in viable_paths: 	return
	move_to_tile(tile)
		

func move_to_tile(tile: Tile) -> void:
	var path: TilemapPath = viable_paths[tile.get_uid()]
	var tile_order: Array = path.path.duplicate()
	tile_order.pop_front()
	if tile.is_occupied():
		if len(tile_order) - 1 > 0:
			for ind in range(len(tile_order) - 1):
				action_queue.append({'action': 'move', 'tile': tile_order[ind]})
		action_queue.append({'action': 'interact', 	'tile': tile, 'unit': tile.get_occupying_unit()})
	else:
		for move_tile in tile_order:
			action_queue.append({'action': 'move', 'tile': move_tile})
	# deduct_movement_points(path.total_weight)
	
func deduct_movement_points(w: float) -> void:
	remaining_movement_points -= w
	_signal_status_bar_change()

func ai_get_nearest_hostile_path() -> Tile:
	get_current_paths()
	var min_tile: Tile = null
	if get_parent().is_ranged_unit():
		var min_target: Array = []
		for key in viable_ranged_targets:
			var target = viable_ranged_targets[key]
			if min_target.is_empty() or target[1] < min_target[1]:
				min_target = target
		if not min_target.is_empty():
			return min_target[0]
	var min_path: TilemapPath = null
	if min_tile == null:
		for key in viable_paths:
			var path: TilemapPath = viable_paths[key]
			if path.end_tile.is_occupied() and path.end_tile.get_occupying_unit().is_hostile(get_parent()):
				if min_path == null or path.total_weight < min_path.total_weight:
					min_path = path
					min_tile = path.end_tile
					
	return min_tile

func find_all_paths(start: Tile, 
					max_movement_weight: float,
					check_beyond_movement: bool = false) -> Dictionary:

	var start_path = TilemapPath.new()
	start_path.start_tile = start
	start_path.end_tile = start
	start_path.path.append(start)

	var paths: Dictionary = {start_path.end_tile.get_uid(): start_path}
	var queue: Array = [start_path]

	while len(queue) > 0:
		var old_path: TilemapPath = queue.pop_front()
		var neighbors = old_path.end_tile.get_neighbors()
		for neighbor: Tile in neighbors:
			if neighbor.is_traversable() and neighbor not in old_path.path:
				var path = TilemapPath.new()
				path.copy_path(old_path)
				path.append_tile(neighbor)
				if path.total_weight > max_movement_weight and not check_beyond_movement:
					continue
				var end_tile_uid = neighbor.get_uid()
				if (end_tile_uid not in paths) or \
				   (path.total_weight < paths[end_tile_uid].total_weight):
					paths[end_tile_uid] = path
					if not path.end_tile.is_occupied():
						queue.append(path)
	
	return paths

func find_all_ranged_targets(	start: Tile, 
								max_range: int) -> Dictionary:

	if has_attacked(): 
		print("skipping check because attacked")
		return {}
	
	var paths: Dictionary = {}
	var targets: Dictionary = {}
	var queue: Array = [[start, 0]]

	while len(queue) > 0:
		var _arr: Array = queue.pop_front()
		var tile: Tile = _arr[0]
		var _len: int = _arr[1]
		if _len >= max_range:
			continue
		var neighbors = tile.get_neighbors()
		for neighbor: Tile in neighbors:
			var end_tile_uid = neighbor.get_uid()
			if neighbor.is_occupied() and get_parent().is_hostile(neighbor.get_occupying_unit()):
				if (end_tile_uid not in paths) or \
				   (paths[end_tile_uid] > _len + 1):
					paths[end_tile_uid] = _len + 1
					targets[end_tile_uid] = [neighbor, _len + 1]
			if end_tile_uid not in paths:
				paths[end_tile_uid] = _len + 1
				queue.append([neighbor, _len + 1])
	
	return targets
