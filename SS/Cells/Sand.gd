@tool
extends Node2D

@export var dispersion_rate := 1.0
@export var friction := 0.0 
@export var bounce := 0.0 
@export var lifetime := 0 
@export var temperature := 10.0 
@export var cell_name : = "Sand"
@export_color_no_alpha var color 

@export_node_path("TileMap") var tilemap_path 

@export var tool_run : bool = false : 
	set(_val):
		_tool_run() 

signal move_started()
signal move_finished()
#Movement Functions

func _tool_run():
	var tilemap : TileMap = get_node(tilemap_path)
	var cell : = TileSetAtlasSource.new()
	
	var image : = Image.create(tilemap.tile_set.tile_size.x, tilemap.tile_set.tile_size.x, false, Image.FORMAT_RGBAF)
	image.fill(color)
	
	cell.texture = ImageTexture.create_from_image(image)
	cell.create_tile(Vector2i(0,0), tilemap.tile_set.tile_size)
	
	tilemap.tile_set.add_source(cell, get_index())
#
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
