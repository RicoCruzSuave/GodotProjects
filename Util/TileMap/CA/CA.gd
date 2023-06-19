@tool
extends Node2D

@export var test_step : = false :
	set = test

@export_node_path("Node2D") var cells_path
@onready var cells_node : = get_node(cells_path)
@export_node_path("TileMap") var tilemap_path
@onready var tilemap : TileMap = get_node(tilemap_path)
 
@export var steps_per_second : = 1.0
@export var sim_size : = Vector2i(480, 270)
var buffer_map : = []
var current_map : = []

var current_cell 
var current_cell_pos


@export var cell_types : Dictionary = { }

func test(_val):
	load_cells()
	init_cells()
	process_cells()
	commit_cells()
	draw_cells()

func load_cells():
	if cells_node == null:
		return
	cell_types = {}
	for child in cells_node.get_children():
		cell_types[String(child.name)] = {
			"id" : child.get_index(),
			"name": child.name,
			"data": child.cell_data.duplicate()
		}
		create_tile(cell_types[child.name]["id"], child.name, child.cell_data.color)

func init_cells():
	var size : = sim_size.x * sim_size.y
	current_map.resize(size)
	current_map.fill(cell_types.get("Air"))
	for i in range(size):
		if randf() < 0.5:
			current_map[i] = cell_types.get("Sand").duplicate()
			current_map[i].data = current_map[i].data.duplicate()
	
	buffer_map = current_map.duplicate()
	
func process_cells():
	for i in current_map.size():
		current_cell_pos = id_to_pos(i)
		current_cell = current_map[i]
		if current_cell.name != "Air":
			var reasoner : = get_node("Cells/" + current_cell.name + "/Reasoner")
			if reasoner != null:
				reasoner.think()
		var desired_direction = current_cell.data.desired_direction
		if desired_direction != Vector2i.ZERO:
			swap_cells(current_cell_pos, current_cell_pos + desired_direction)
	
func commit_cells():
	current_map = buffer_map.duplicate()

func draw_cells():
	for x in sim_size.x:
		for y in sim_size.y:
			tilemap.set_cell(0, Vector2i(x,y), get_cell_tile_id(Vector2i(x,y)), Vector2i.ZERO)

func create_tile(tile_id : int, tile_name : String, color : Color):
	if Engine.is_editor_hint():
		tilemap = get_node(tilemap_path)
	var tileset : = tilemap.tile_set
	var tileset_source : = TileSetAtlasSource.new()
	var image : = Image.create(
		tileset.tile_size.x, 
		tileset.tile_size.y, 
		false,
		Image.FORMAT_RGBA8
	)
	image.fill(color)
	var tex : = ImageTexture.create_from_image(image)
	tileset_source.texture = tex
	tileset_source.create_tile(Vector2i.ZERO)
	if tileset.has_source(tile_id):
		tileset.remove_source(tile_id)
	tileset.add_source(tileset_source, tile_id)
	

func get_cell(pos : Vector2i):
	return current_map[pos_to_id(pos)]
	
func get_cell_type(pos : Vector2i):
	return get_cell(pos).get("name")
	
func get_cell_tile_id(pos : Vector2i):
	return get_cell(pos).get("id")
	
func get_neighbor_cell(pos : Vector2i, neighbor_direction : Vector2i):
	return get_cell(pos + neighbor_direction)
	
func get_cell_neighbors(pos : Vector2i) -> Array:
	var neighbors : = []
#	for x in [-1, 0, 1]:
#		for y in [-1, 0, 1]:
#			if x == 0 and y == 0:
#				continue
#			neighbors.append(current_map[pos_to_id(pos + Vector2i(x,y))])
	for coords in tilemap.get_surrounding_cells(pos):
		neighbors.append(current_cell[coords])
	return neighbors


func pos_to_id(pos : Vector2i) -> int:
	if is_in_bounds(pos):
		return (pos.y * sim_size.x) + pos.x
	return -1
	
func id_to_pos(id : int) -> Vector2i:
	return Vector2i(id % sim_size.y, id / sim_size.y)
	
func is_in_bounds(pos : Vector2i) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < sim_size.x and pos.y < sim_size.y
	
func add_cells():
	pass
	
func delete_cells():
	pass

func swap_cells(pos1 : Vector2i, pos2 : Vector2i) -> void:
	
	if is_in_bounds(pos1) and is_in_bounds(pos2):
		var cell1 = current_map[pos_to_id(pos1)]
		var cell2 = current_map[pos_to_id(pos2)]
		buffer_map[pos_to_id(pos1)] = cell2
		buffer_map[pos_to_id(pos2)] = cell1
	
	
func change_cell_type(pos : Vector2i, type : String):
	pass
