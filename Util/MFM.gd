extends TileMap
class_name MFM

@export var world_size : = Vector2i(100, 100)
@export var radius : = 1
@export var square_radius : = true

var cells : = []
var world : = []
var event_window : = []
var neighbors : = []
var order : = []
var order_index : = 0

func _ready():
	_build_world()
	_build_event_window()
	_build_neighbors()
	_build_order()

func _build_world():
	world.resize(world_size.x)
	for x in world_size.x:
		world[x] = []
		world[x].resize(world_size.y)
		for y in world_size.y:
			var new_space : = Space.new()
			world[x][y] = new_space
			
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
	neighbors.resize(world_size.x)
	for x in world_size.x:
		neighbors[x] = []
		neighbors[x].resize(world_size.y)
		for y in world_size.y:
			var directions_to_add : = event_window
			var neighbors_dict : = {}
			var current_pos : = Vector2i(x,y)
			neighbors_dict[Vector2i.ZERO] = world[x][y]
			for dir in directions_to_add:
				neighbors_dict[dir] = \
					null if not is_in_bounds(current_pos + dir) \
					else world[x + dir.x][y + dir.y]
			neighbors[x][y] = neighbors_dict

func _build_order():
	for x in world_size.x:
		for y in world_size.y:
			order.append(Vector2i(x,y))
	order.shuffle()

func update_cells():
	for _i in range(order.size()):
		var cell : Vector2i = order[order_index]
		if is_space_valid(cell) and not is_space_empty(cell):
			update_cell(cell)
		order_index = wrapi(order_index + 1, 0, order.size())

func update_cell(cell : Vector2i):
	world[cell.x][cell.y].content.update(neighbors[cell.x][cell.y])
	for key in neighbors[cell.x][cell.y].keys():
		if neighbors[cell.x][cell.y][key] != null:
			draw_cell(cell + key)

func draw_cell(cell : Vector2i):
	if not is_space_empty(cell):
		set_cell(0, cell, world[cell.x][cell.y].content.id, Vector2i.ZERO)
	else:
		set_cell(0, cell)

#Util
func is_in_bounds(pos : Vector2i) -> bool:
	return pos.x >= 0 and pos.y  >= 0 and pos.x < world_size.x and pos.y < world_size.y

func is_space_valid(pos : Vector2i) -> bool:
	if is_in_bounds(pos):
		return world[pos.x][pos.y] != null
	return false

func is_space_empty(pos : Vector2i) -> bool:
	if is_in_bounds(pos):
		return world[pos.x][pos.y].content == null
	return true

class Space extends RefCounted:
	var content = null
	var environment : Dictionary = {}
