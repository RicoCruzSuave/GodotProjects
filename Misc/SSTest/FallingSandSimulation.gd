extends Node2D

@onready var tilemap : TileMap = $TileMap

enum CELLS {
	EMPTY = -1,
	SAND,
	WATER
}

func _ready():
	"""
	ToDo:
		Add in all grid manipulation code here
		Make tilemap determine boundaries? Use tilemap for cell_size and coordinate translation?
		Add in list of cells as a subnode
		Give each of the cells node components that describe its attributes
		Implement attributes such as :
				collides_with, changes_with, forces_applied, state_changes,
				dispersion, friction, bounce, lifetime, temperature,
				movement_directions(order), velocity_multiplier, 
		
		Create sequencer for movement
			-each node has a get that either gets appropriate child or gets self
			-methods: get, can, 
			-selector nodes for changing sequence procedurally
			
		Selector: choose one
		Sequence: run all in a given order
		Break/Cant: Sequence node that aborts the sequence (like break statement)
		Condition: return true or false based if condition is met
		Directive: runs some code
		
		Put cell variables in tilemap custom tiledata
	"""
	pass

func add_cell(pos : Vector2, type : int):
	var grid_pos : = tilemap.local_to_map(tilemap.to_local(pos))
	tilemap.set_cell(0, grid_pos, type, Vector2i(0,0))
	
func _input(event):
	if Input.is_action_pressed("left_click"):
		add_cell(get_global_mouse_position(), CELLS.SAND)
	if Input.is_action_pressed("right_click"):
		add_cell(get_global_mouse_position(), CELLS.WATER)
		
func _process(_delta):
	var cells : = tilemap.get_used_cells(0)
	for cell in cells:
		match tilemap.get_cell_source_id(0, cell):
			CELLS.SAND:	
				var movement_func : = get_node("Cells/Sand/MovementSelector")
#				var new_cell_pos : Vector2i = movement_func.run(cell)
				var new_cell_pos : Vector2i = movement_func.get_current_node(cell).run(cell)
				if cell != new_cell_pos:
					var old_tile : int = tilemap.get_cell_source_id(0, new_cell_pos)
					tilemap.set_cell(0, cell, old_tile)
					tilemap.set_cell(0, new_cell_pos, CELLS.SAND, Vector2i(0,0))				
			CELLS.WATER:
				var movement_func : = get_node("Cells/Water/MovementSelector")
				var new_cell_pos : Vector2i = movement_func.get_current_node(cell).run(cell)				
				if cell != new_cell_pos:
					var old_tile : int = tilemap.get_cell_source_id(0, new_cell_pos)
					tilemap.set_cell(0, cell, old_tile)
					tilemap.set_cell(0, new_cell_pos, CELLS.WATER, Vector2i(0,0))
			_:
				pass
	
	
	
