extends Node2D

@export var block_prefab: PackedScene;

var blocks: Node

signal block_destroyed;

func _block_destroyed_proxy(_block: Block):
	emit_signal("block_destroyed")

func _ready() -> void:
	blocks = $"."
	
	var tile_set = $TileMapLayer.tile_set
	for cell in $TileMapLayer.get_used_cells():
		var cell_data: TileData = $TileMapLayer.get_cell_tile_data(cell);
		var cell_color = cell_data.get_custom_data("color")

		var cell_local_position: Vector2 = $TileMapLayer.map_to_local(cell)
		
		#var cell_possition: Vector2 = $TileMapLayer.to_global(cell_local_position)
		var cell_possition: Vector2 = cell_local_position
		
		$TileMapLayer.erase_cell(cell)
		
		var block_instance: Block = block_prefab.instantiate()
		
		block_instance.color = cell_color
		block_instance.destroyed.connect(_block_destroyed_proxy)
		
		blocks.add_child(block_instance)
		
		block_instance.position = cell_possition
