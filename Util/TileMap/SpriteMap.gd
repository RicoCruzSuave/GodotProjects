@tool
extends TileMap

@export_node_path("Sprite2D") var sprite_path
@onready var map_tex : Texture2D = get_node(sprite_path).texture

@export var draw_sprite : = false : 
	set(new_bool) : set_draw_sprite(new_bool)

enum TILES {
	WALL,
	OPEN
}

func set_draw_sprite(new_bool : bool):
	var image : Image 
	var tex : Texture2D
	if Engine.is_editor_hint():
		tex = get_node(sprite_path).texture
		image = tex.get_image()
	else:
		tex = map_tex
		image = map_tex.get_image()
		
	for x in tex.get_width():
		for y in tex.get_height():
			#Walls
			if image.get_pixel(x,y).r > 0.5:
				set_cell(0, Vector2i(x,y), TILES.OPEN, Vector2i.ZERO)
			else:
				set_cell(0, Vector2i(x,y), TILES.WALL, Vector2i.ZERO)
				
