@tool
extends Node2D

@export var run_tool : = false :
	set(_bool) : build()
@export var on_ready_build : = false

@export var background_size : = Vector2i(1200,350)
@export var grid_size : = Vector2i(7,7)
@export var spot_size : = Vector2i(96,32)
@export var separation : = Vector2i(150, 40)

@export var background_color : = Color("01295f")
@export var spot_color : = Color("437f97")
@export var highlight_color : = Color("ffb30f")

func _ready():
	if on_ready_build:
		build()

func build():
	clear_children()
	draw_background()
	draw_spots()
	highlight_spot(Vector2i(1,1))
	highlight_spot(Vector2i(1,7))
	highlight_spot(Vector2i(7,4))
	highlight_spot(Vector2i(4,4))
			
func draw_background():
	var background_sprite : = Sprite2D.new()
	add_child(background_sprite)
	background_sprite.owner = get_tree().edited_scene_root
	
	var image : = Image.create(background_size.x, background_size.y, false, Image.FORMAT_RGBA8, )
	image.fill(background_color)
	var tex : = ImageTexture.create_from_image(image)
	background_sprite.texture = tex
	
	background_sprite.z_index = -1
	background_sprite.name = "Background"
	
func draw_spots():
	#Create a range centered on this node
	#This is needed to properly include the end of the range if the number is odd
	var x_range_min : = -grid_size.x / 2
	var x_range_max : = grid_size.x / 2 if grid_size.x % 2 == 0 else (grid_size.x / 2) + 1
	var y_range_min : = -grid_size.y / 2
	var y_range_max : = grid_size.y / 2 if grid_size.y % 2 == 0 else (grid_size.y / 2) + 1
	for x in range(x_range_min, x_range_max):
		var new_row : = Node2D.new()
		add_child(new_row)
		new_row.owner = get_tree().edited_scene_root
		
		new_row.position.x = x * separation.x
		#Properly center even numbers
		if grid_size.x % 2 == 0:
			new_row.position.x += separation.x / 2
		new_row.name = "Row"
		for y in range(y_range_min, y_range_max):
			var spot_sprite : = Sprite2D.new()
			new_row.add_child(spot_sprite)
			spot_sprite.owner = get_tree().edited_scene_root
			
			var image : = Image.create(spot_size.x, spot_size.y, false, Image.FORMAT_RGBA8)
			image.fill(spot_color)
			var tex : = ImageTexture.create_from_image(image)
			spot_sprite.texture = tex
			
			spot_sprite.position.y = y * separation.y
			#Properly center even numbers
			if grid_size.y % 2 == 0:
				spot_sprite.position.y += separation.y / 2
			spot_sprite.name = "Spot"

func highlight_spot(coords : Vector2i, color : = highlight_color):
	var highlight_position : Vector2 = get_spot_position(coords)
	if highlight_position == null:
		return
	
	if get_node("Highlights") == null:
		var highlights_node : = Node2D.new()
		add_child(highlights_node)
		highlights_node.owner = get_tree().edited_scene_root
		highlights_node.name = "Highlights"
		
	var highlights_node = get_node("Highlights")
	var highlight_sprite : = Sprite2D.new()
	highlights_node.add_child(highlight_sprite)
	highlight_sprite.owner = get_tree().edited_scene_root
	
	var image : = Image.create(spot_size.x, spot_size.y, false, Image.FORMAT_RGBA8)
	image.fill(Color(color, 0.5))
	var tex : = ImageTexture.create_from_image(image)
	highlight_sprite.texture = tex
	highlight_sprite.name = str(coords)
	
	highlight_sprite.position = highlight_position

func get_spot_position(coords : Vector2i, local_pos : = true):
	if not Rect2i(Vector2i.ONE, grid_size).has_point(coords):
		print_debug(str(coords) + " not a valid point")
		return
	var row_node_name : = "Row"
	if coords.x != 1:
		row_node_name += str(coords.x)
	var spot_node_name : = "Spot"
	if coords.y != 1:
		spot_node_name += str(coords.y)
	
	var row_node : = get_node(row_node_name)
	var spot_node : = get_node(row_node_name+"/"+spot_node_name)
	if local_pos:
		return Vector2(row_node.position.x, spot_node.position.y)
	else:
		return spot_node.global_position
		
func clear_highlights():
	if get_node("Highlights") != null:
		var highlights_node : = get_node("Highlights")
		for child in highlights_node.get_children():
			child.free()

func clear_children():
	for child in get_children():
		child.free()
