@tool
extends Node2D
## An MFM-like simulation
##
## This node will run a simulation based on Dave Ackley's Movable Feast Machine
## Each frame, a cell in the given area is selected. It can then run its own code
## modifying the world array according to its internal rules. Each cell can only affects
## other cells that are within its 'event window', determined by the radius

@export var debug : = true
## The size of the simulation area
@export var sim_size : = Vector2i(100,100)
## The scale of the image
@export var sim_scale : = 4.0
## How many times per frame the simulation is run
@export var steps : = 20
## The event window radius
@export var radius : = 2
## Determines whether the event radius is calculated naively or excluding corners
@export var square_radius : = false
##The background color of the simulation
@export_color_no_alpha var background_color : = Color.DARK_RED

## The main world array that contains the current state
var world : = [] 
## The array that holds the relative coordinates 
## that are used to generate the event window
var event_window : = []
## This array holds references to neighboring cells for each coordinate
## This prevents repeatedly calculating neighboring coordinates
var neighbors : = []
## This determines the order in which the cells are processed
var order : = []
## This is the image data that respresents the current world state
var image : = Image.new()

## Keeps track of current progress through the order array
var order_index : = 0
## Keeps track of all cells that need redrawing each frame
var cells_changed : = []
## Maintains a refernece to the display sprite
var sprite : = Sprite2D.new()

#Virtual Methods

func _ready():
	_build_world()
	_build_event_window()
	_build_neighbors()
	_build_order()
	_build_image()
	
	#Process can run before ready in some cases, this fixes that
	set_process(false)
	await get_parent().ready
	set_process(true)
	
func _process(delta):
	_process_cells()
	_draw_cells(cells_changed)
	
func _input(event):
	if Input.is_action_just_pressed("left_click"):
		var event_pos : = get_global_mouse_position() / sim_scale
		if Rect2(global_position, sim_size).has_point(event_pos):
			world[event_pos.x][event_pos.y].content = AtomSand.new()
			cells_changed.append(event_pos)
	if Input.is_action_just_pressed("right_click"):
		var event_pos : = get_global_mouse_position() / sim_scale
		if Rect2(global_position, sim_size).has_point(event_pos):
			world[event_pos.x][event_pos.y].content = null
			cells_changed.append(event_pos)

#Initialization methods
		
func _build_world():
	world.resize(sim_size.x)
	for x in sim_size.x:
		world[x] = []
		world[x].resize(sim_size.y)
		for y in sim_size.y:
			world[x][y] = Cell.new()
			
func _build_event_window():
	event_window = [Vector2i.ZERO]
	for x in radius + 1:
		for y in radius + 1:
			if x == 0 and y == 0:
				continue
				
			if not square_radius and x + y > radius:
				continue
				
			if not event_window.has(Vector2i(x,y)):
				event_window.append(Vector2i(x,y))
			if not event_window.has(Vector2i(-x,y)):
				event_window.append(Vector2i(-x,y))
			if not event_window.has(Vector2i(x,-y)):
				event_window.append(Vector2i(x,-y))
			if not event_window.has(Vector2i(-x,-y)):
				event_window.append(Vector2i(-x,-y))

func _build_neighbors():
	neighbors.resize(sim_size.x)
	for x in sim_size.x:
		neighbors[x] = []
		neighbors[x].resize(sim_size.y)
		for y in sim_size.y:
			var directions_to_add : = event_window
			var neighbors_dict : = {}
			var current_pos : = Vector2i(x,y)
			for dir in directions_to_add:
				neighbors_dict[dir] = \
					null if not is_in_bounds(current_pos + dir) \
					else world[x + dir.x][y + dir.y]
			neighbors[x][y] = neighbors_dict
			
func _build_order():
	for y in sim_size.y:
		var temp_order : = []
		for x in sim_size.x:
			temp_order.append(Vector2i(x,sim_size.y - (y + 1)))
		temp_order.shuffle()
		order.append_array(temp_order)
	#order.shuffle()

func _build_image():
	image = Image.create(sim_size.x, sim_size.y, false, Image.FORMAT_RGB8)
	image.fill(background_color)
	
	add_child(sprite)
	sprite.centered = false
	sprite.texture = ImageTexture.create_from_image(image)
	sprite.texture_filter = Sprite2D.TEXTURE_FILTER_NEAREST
	sprite.scale *= sim_scale

#Processing methods

func _process_cells():
	for i in range(steps):
		var cell_position : Vector2i = order[order_index]
		order_index = wrapi(order_index + 1, 0, order.size())
		var current_cell : Cell = world[cell_position.x][cell_position.y]

		#Debug code that shows the event window
		#var color : = Color8(10, 150 + randi() % 70, 10)
		#for pos in neighbors[cell_position.x][cell_position.y].keys():
			#if neighbors[cell_position.x][cell_position.y][pos] != null:
				#image.set_pixelv(pos + cell_position, color )
		
		if current_cell.content != null and current_cell.content is Atom:
			var cell_changed : bool = \
				current_cell.content.update(neighbors[cell_position.x][cell_position.y])
			if cell_changed:
				cells_changed.append(cell_position)
				for neighbor in neighbors[cell_position.x][cell_position.y].keys():
					cells_changed.append(cell_position + neighbor)
	
func _draw_cells(cells_to_draw : Array):
	for cell in cells_to_draw:
		if is_in_bounds(cell):
			if world[cell.x][cell.y].content != null:
				image.set_pixelv(cell, world[cell.x][cell.y].content.get_color())
			else: 
				image.set_pixelv(cell, background_color)
	sprite.texture.update(image)
	cells_changed = []

#Util

func is_in_bounds(pos : Vector2i) -> bool:
	return pos.x >= 0 and pos.y  >= 0 and pos.x < sim_size.x and pos.y < sim_size.y
	
class Cell extends RefCounted:
	var content 
