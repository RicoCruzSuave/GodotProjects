extends Atom
class_name AtomSand



func update(neighbors : Dictionary) -> bool:
	#Freefalling
	#Spread
	var direction : = Vector2.DOWN
	var spread : = TAU / 4.0
	var dispersion : = 3
	var velocity : = 1
	var possible_moves : = []
	var depth : = 0
	
	for i in range(velocity, 0, -1):
		if neighbors.get(Vector2i(direction * i)) != null \
		and neighbors.get(Vector2i(direction * i)).content == null:
			neighbors[Vector2i.ZERO].content = neighbors[Vector2i(direction * i)].content
			neighbors[Vector2i(direction * i)].content = self
			return true
			
	var left_dir : = direction.rotated(-spread).round()
	var right_dir : = direction.rotated(spread).round()
	for i in range(dispersion, 0, -1):
		if neighbors.get(Vector2i(direction + (left_dir * i))) != null \
		and neighbors.get(Vector2i(direction + (left_dir * i))).content == null:
			neighbors[Vector2i.ZERO].content = neighbors[Vector2i(direction + (left_dir * i))].content
			neighbors[Vector2i(direction + (left_dir * i))].content = self
			return true
		if neighbors.get(Vector2i(direction + (right_dir * i))) != null \
		and neighbors.get(Vector2i(direction + (right_dir * i))).content == null:
			neighbors[Vector2i.ZERO].content = neighbors[Vector2i(direction + (right_dir * i))].content
			neighbors[Vector2i(direction + (right_dir * i))].content = self
			return true
		#var current_direction : = direction * i
		#possible_moves.append(Vector2i(current_direction))
		#possible_moves.append(Vector2i(current_direction.rotated(spread).round()))
		#possible_moves.append(Vector2i(current_direction.rotated(-spread).round()))
	#for move in possible_moves:
		#if neighbors.get(move) != null and neighbors.get(move).content == null:
			#neighbors[Vector2i.ZERO].content = neighbors[move].content
			#neighbors[move].content = self
			#return true
	return false
	
	#if neighbors.get(Vector2i.DOWN) != null and neighbors.get(Vector2i.DOWN).content == null:
		#neighbors[Vector2i.ZERO].content = neighbors[Vector2i.DOWN].content
		#neighbors[Vector2i.DOWN].content = self
		#return true
	#elif neighbors.get(Vector2i.DOWN + Vector2i.RIGHT) != null \
		#and neighbors.get(Vector2i.DOWN + Vector2i.RIGHT).content == null:
		#neighbors[Vector2i.ZERO].content = neighbors[Vector2i.DOWN + Vector2i.RIGHT].content
		#neighbors[Vector2i.DOWN + Vector2i.RIGHT].content = self
		#return true
	#elif neighbors.get(Vector2i.DOWN + Vector2i.LEFT) != null \
		#and neighbors.get(Vector2i.DOWN + Vector2i.LEFT).content == null:
		#neighbors[Vector2i.ZERO].content = neighbors[Vector2i.DOWN + Vector2i.LEFT].content
		#neighbors[Vector2i.DOWN + Vector2i.LEFT].content = self
		#return true
	#return false
