@tool
extends Node2D

@export var dispersion_rate := 1.0
@export var friction := 0.0 
@export var bounce := 0.0 
@export var lifetime := 0 
@export var temperature := 10.0 
@export var cell_name : = "Water"
@export_color_no_alpha var color 

@export_node_path("TileMap") var tilemap_path 

@export var tool_run : bool = false : 
	set(val):
		_tool_run() 

signal updated()
#Movement Functions

func _tool_run():
#	print("going")
	print("Now")
	
	var tilemap : TileMap = $"../../TileMap"
	var cell : = TileSetAtlasSource.new()
	var image : = Image.create(tilemap.tile_set.tile_size.x, tilemap.tile_set.tile_size.x, false, Image.FORMAT_RGBAF)
	image.fill(color)
	cell.texture = ImageTexture.create_from_image(image)
#	cell.create_tile(Vector2i(0,0), tilemap.tile_set.tile_size)
	tilemap.tile_set.add_source(cell, get_index())
	tilemap.tile_set.set_custom_data_layer_name(get_index(), cell_name)

	
	
	
	
	
	
	
	
	
	
	
	
	
	
