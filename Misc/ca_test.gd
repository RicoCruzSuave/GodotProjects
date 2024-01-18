extends TileMap

@export var map_size : = Vector2i(1200/16, 720/16)
@export var iterations : = 5

enum TILE {
	CAVE_EMPTY,
	CAVE_WALL,
	LIFE_ALIVE,
	LIFE_DEAD,
	MAX
}

var neighborhood : = [
	Vector2i.LEFT, 
	Vector2i.RIGHT,
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT + Vector2i.UP,
	Vector2i.LEFT + Vector2i.DOWN,
	Vector2i.RIGHT + Vector2i.UP,
	Vector2i.RIGHT + Vector2i.DOWN,
]

func _ready():
	randomize_map()
	for _i in iterations:
		await get_tree().process_frame
		step()
	#await ges

#func _input(event):
	#if Input.is_action_just_pressed("ui_accept"):
		#step()
	#if Input.is_key_pressed(KEY_R):
		#randomize_map()
		
		
func step():
	for x in map_size.x:
		for y in map_size.y:
			var tile : = Vector2i(x,y)
			var count : = 0
			for dir in neighborhood:
				var neighbor : = get_cell_source_id(0, tile + dir)
				if neighbor == TILE.CAVE_WALL:
					count += 1
				
			match get_cell_source_id(0, tile):
				TILE.CAVE_EMPTY: 
					if count < 5:
						call_deferred("set_cell", 0, tile, TILE.CAVE_EMPTY, Vector2i.ZERO)
					else:
						call_deferred("set_cell", 0, tile, TILE.CAVE_WALL, Vector2i.ZERO)
				TILE.CAVE_WALL: 
					if count < 4:
						call_deferred("set_cell", 0, tile, TILE.CAVE_EMPTY, Vector2i.ZERO)
					else:
						call_deferred("set_cell", 0, tile, TILE.CAVE_WALL, Vector2i.ZERO)
			
			#count = 0
			#for dir in neighborhood:
				#var neighbor : = get_cell_source_id(1, tile + dir)
				#if neighbor == TILE.LIFE_ALIVE:
					#count += 1			
			#match get_cell_source_id(1, tile):			
				#TILE.LIFE_ALIVE:
					#if count != 2 or count != 3:
						#call_deferred("set_cell", 1, tile, TILE.LIFE_DEAD, Vector2i.ZERO)
				#TILE.LIFE_DEAD:
					#if count == 3:
						#call_deferred("set_cell", 1, tile, TILE.LIFE_ALIVE, Vector2i.ZERO)
			#
func randomize_map():
	for x in map_size.x:
		for y in map_size.y:
			var tile : = Vector2i(x,y)
			set_cell(0, tile, randi_range(TILE.CAVE_EMPTY, TILE.CAVE_WALL), Vector2i.ZERO)
			#set_cell(1, tile, randi_range(TILE.LIFE_ALIVE, TILE.LIFE_DEAD), Vector2i.ZERO)
