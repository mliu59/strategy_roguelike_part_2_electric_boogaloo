extends ComponentEntityBase

@export var max_movement_points: float = 5
var remaining_movement_points: float
var viable_paths: Dictionary
var moving: bool = false
var current_tile: Tile
var flip_dir_h: bool = false

var _attacked: bool = false

var action_queue: Array = []

@export var max_move_velocity: float = 200
@export var max_move_acceleration: float = 100
var cur_velocity: float = 0

signal highlight_cell(tile: Tile)
signal highlight_path(path: TilemapPath)
signal clear_highlights
signal highlight_movable_cell(tile: Tile)
signal flip_sprite(dir: bool)
signal entered_tile(tile: Tile)
signal action_to_tile_complete()

func get_string() -> String:
	return "%s/%s" % [remaining_movement_points, max_movement_points]

func _component_ready() -> void:
	reset_movement()

func _signal_status_bar_change() -> void:
	_c_map['status_bars'].update_status_bar("movement_bar", remaining_movement_points, max_movement_points)

func zero_movement() -> void:
	remaining_movement_points = 0
	_signal_status_bar_change()

func reset_movement() -> void:
	remaining_movement_points = max_movement_points
	_signal_status_bar_change()

func get_current_paths() -> void:
	viable_paths = find_all_paths(get_parent().current_tile, remaining_movement_points)
func show_current_paths() -> void:
	for uid in viable_paths:
		var tile: Tile = viable_paths[uid].end_tile
		if tile == get_parent().current_tile:
			continue
		highlight_movable_cell.emit(tile)

func _physics_process(delta: float) -> void:
	if action_queue.is_empty():
		moving = false
		return
	moving = true
	var target: Vector2 = action_queue[0]['tile'].global_position
	var err: Vector2 = target - get_parent().global_position
	
	if flip_dir_h != (err[0] < 0):
		flip_dir_h = err[0] < 0
		flip_sprite.emit(flip_dir_h)
		
	cur_velocity = min(cur_velocity + max_move_acceleration * delta, max_move_velocity)
	get_parent().global_position = get_parent().global_position.move_toward(
		target, cur_velocity * delta)
	if get_parent().global_position == target:
		get_parent().current_tile.clear_unit()
		entered_tile.emit(action_queue[0]['tile'])
		action_queue.pop_front()
		if action_queue.is_empty():
			_arrived_at_target()
		elif action_queue[0]['action'] == 'interact':
			_attacked = true
			zero_movement()
			get_parent().apply_unit_interaction(action_queue[0]['unit'])
			var dict = action_queue.pop_front()
			if action_queue.is_empty():
				if not dict['tile'].is_occupied():
					action_queue.append({'action': 'move', 'tile': dict['tile']}) 
				else:
					_arrived_at_target()
			
func _arrived_at_target() -> void:
	clear_highlights.emit()
	action_to_tile_complete.emit()

func set_entity_acceleration(a) -> void:
	max_move_acceleration = a
func set_entity_max_velocity(v) -> void:
	max_move_velocity = v

func has_attacked() -> bool:
	return _attacked

func action_to_tile(tile: Tile) -> void:
	if moving: return
	get_current_paths()
	if not tile.is_traversable(): 			return
	if not tile.get_uid() in viable_paths: 	return
	move_to_tile(tile)

func move_to_tile(tile: Tile) -> void:
	cur_velocity = max_move_velocity
	set_entity_acceleration(max_move_acceleration)
	set_entity_max_velocity(max_move_velocity)
	
	var path: TilemapPath = viable_paths[tile.get_uid()]
	if tile.is_occupied():
		if len(path.path) - 1 > 0:
			for ind in range(len(path.path) - 1):
				action_queue.append({'action': 'move', 'tile': path.path[ind]})
		action_queue.append({'action': 'interact', 	'tile': tile, 'unit': tile.get_occupying_unit()})
	else:
		for move_tile in path.path:
			action_queue.append({'action': 'move', 'tile': move_tile})
	
	remaining_movement_points -= path.total_weight
	_signal_status_bar_change()

func ai_get_nearest_hostile_path() -> TilemapPath:
	get_current_paths()
	var min_path: TilemapPath = null
	for key in viable_paths:
		var path: TilemapPath = viable_paths[key]
		if path.end_tile.is_occupied() and path.end_tile.get_occupying_unit().is_hostile(get_parent()):
			if min_path == null or path.total_weight < min_path.total_weight:
				min_path = path
	return min_path

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
