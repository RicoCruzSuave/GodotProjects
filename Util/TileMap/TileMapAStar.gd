@tool
extends Node2D

@export_node_path("TileMap") var tilemap_path
@onready var tilemap : TileMap = get_node(tilemap_path)

@export var debug_draw : = false : 
	set = set_debug_draw
		
@export var generate_pathfinding : = false : 
	set(new_bool) : _generate_pathfinding()

enum TILES {
	WALL,
	OPEN
}

var astar : = AStar2D.new()

func _ready():
	_generate_pathfinding()

func _generate_pathfinding():
	var map : TileMap 
	if Engine.is_editor_hint():
		map = get_node(tilemap_path)
	else:
		map = tilemap
		
	astar.clear()
		
	for cell in map.get_used_cells_by_id(0, TILES.OPEN, Vector2i.ZERO):
		var id : = astar.get_available_point_id()
		astar.add_point(id, map.map_to_local(cell))
	
	for cell in map.get_used_cells_by_id(0, TILES.OPEN, Vector2i.ZERO):
		var current_point : = astar.get_closest_point(map.map_to_local(cell))
		var left_point : = astar.get_closest_point(map.map_to_local(cell + Vector2i.LEFT))
		var up_point : = astar.get_closest_point(map.map_to_local(cell + Vector2i.UP))
		for neighbor in [left_point,up_point]:
			if current_point != neighbor:
				var current_point_position : = astar.get_point_position(current_point)
				var neighbor_point_position : = astar.get_point_position(neighbor)
				var distance_to_neighbor : = map.tile_set.tile_size.length()
				if current_point_position.distance_to(neighbor_point_position) <= distance_to_neighbor:
						astar.connect_points(current_point, neighbor)
						
	debug_draw = debug_draw
		
func set_debug_draw(is_on : bool):
	debug_draw = is_on
	
	for child in get_children():
		child.free()
	
	if debug_draw:
		for point in astar.get_point_ids():
			var debug_sprite : = Sprite2D.new()
			debug_sprite.texture = PlaceholderTexture2D.new()
			debug_sprite.position = astar.get_point_position(point)
			debug_sprite.texture.size = Vector2.ONE * 8		
			add_child(debug_sprite)
			debug_sprite.owner = owner

