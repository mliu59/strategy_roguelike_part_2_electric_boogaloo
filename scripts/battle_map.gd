extends Node

var tiles: TileContainer

const _initial_units: Array = [
	["entity_unit_commander", 0, null],
	["entity_unit_commander", 0, null],
	["entity_unit_commander", 1, null],
	["entity_unit_commander", 1, null],
	["entity_unit_longbowman", 0, null],
	["entity_unit_longbowman", 1, null],
]

const _initial_items: Array = [
	"snow_lotus", 
	"wooden_round_shield", 
	"black_pearl", 
	"mysterious_elixir"
]

func _ready() -> void:
	tiles = $hextile_tilemap_base/hextile_tilemap_generator.generate_random_map()
	#tiles = $hextile_tilemap_base.get_current_map()
	$hextile_tilemap_base.set_map(tiles)
	$world_decor.set_map(tiles)
	
	for unit in _initial_units:
		if unit[1] == 0:
			$entity_manager.queue_for_deployment(unit[0], unit[1])
			continue
		var tile = unit[2]
		if tile == null:
			tile = tiles.get_random_empty_traversable_tile()
		$entity_manager.spawn_unit_at_tile(unit[0], unit[1], tile)
	
	for item in _initial_items:
		get_parent().get_node("item_inventory").add_item(item)
		
	$process_state_machine.connect_unit_signals()
	$process_state_machine.start_state_machine()
