extends Atom
class_name AtomSand


func update(neighbors : Dictionary) -> bool:
	if neighbors.get(Vector2i.DOWN) != null and neighbors.get(Vector2i.DOWN).content == null:
		neighbors[Vector2i.ZERO].content = neighbors[Vector2i.DOWN].content
		neighbors[Vector2i.DOWN].content = self
		return true
	return false
