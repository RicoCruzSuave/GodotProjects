extends Condition

@export_node_path("TileMap") var tilemap_path
@onready var tilemap : TileMap = get_node(tilemap_path)

func check(variant : Variant) -> bool:
	var pos : Vector2i = variant as Vector2i
	var cell_id : int = tilemap.get_cell_source_id(0, pos)
	for child in get_children():
		if child.check(cell_id):
			return false
	return true
