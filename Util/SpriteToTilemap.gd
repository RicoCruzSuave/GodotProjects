@tool
extends Sprite2D

@export var run_tool : = false : 
	set(_bool) : run()
@export var run_on_ready : = false 

@export_node_path("TileMap") var tilemap_path
@onready var tilemap : TileMap = get_node(tilemap_path)

@export var tile_size : = Vector2i(16,16) 
@export var tex_offset : = Vector2i(0,0)
@export var tex_scale : = Vector2i(2.5,2.5)
	
func _ready():
	if run_on_ready:
		run()
		
func _draw():
	var texture_size : = texture.get_size()
	for x in range(0, texture_size.x, tile_size.x):
		draw_line(Vector2i(x, 0) + tex_offset / tex_scale, Vector2i(x, texture_size.y) + tex_offset / tex_scale, Color.RED)
		for y in range(0, texture_size.y, tile_size.y):
			draw_line(Vector2i(0, y) + tex_offset / tex_scale, Vector2i(texture_size.x, y) + tex_offset / tex_scale, Color.RED)			
	
func run():
	queue_redraw()
	
	var tileset : = TileSet.new()
	var texture_size : = texture.get_size()
	var image : = texture.get_image()
	tileset.tile_size = tile_size
	tilemap.tile_set = tileset
	tilemap.position = tex_offset
	
	var data_cache : = []
	
	for x in range(0, texture_size.x - tile_size.x, tile_size.x):
		for y in range(0, texture_size.y - tile_size.y, tile_size.y):
			var tileset_source : = TileSetAtlasSource.new()
			var region : = Rect2i(Vector2i(x,y) + tex_offset, tile_size)
			if not Rect2i(Vector2i.ZERO, texture_size).encloses(region):
				#print("Skipping")
				continue
			var region_image : = image.get_region(region)
			for i in data_cache:
				if i.data.hash() == region_image.data.hash():
					print("Identical tile found")
			data_cache.append(region_image)
			if data_cache.size() > 5:
				data_cache.pop_front()
			var tile_texture : = ImageTexture.create_from_image(region_image)
			tileset_source.texture = tile_texture
			tileset_source.texture_region_size = tile_size
			tileset_source.create_tile(Vector2i.ZERO)
			var id : = tileset.add_source(tileset_source)
			tilemap.set_cell(0, Vector2i(x,y) / tile_size, id, Vector2i.ZERO)
