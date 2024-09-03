extends Node

var tiles: TileContainer

const _initial_units: Array = [
	["entity_unit_commander", 0, null],
	["entity_unit_commander", 0, null],
	["entity_unit_commander", 1, null],
	["entity_unit_commander", 1, null]
]

func _ready() -> void:
	#tiles = $hextile_tilemap_base/hextile_tilemap_generator.generate_random_map()
	tiles = $hextile_tilemap_base.get_current_map()
	$hextile_tilemap_base.set_map(tiles)
	
	for unit in _initial_units:
		var tile = unit[2]
		if tile == null:
			tile = tiles.get_random_empty_traversable_tile()
			#print(tile.tilemap_coordinates)
		$entity_manager.spawn_unit_at_tile(unit[0], unit[1], tile)

	$process_state_machine.connect_unit_signals()
	$process_state_machine.start_state_machine()
