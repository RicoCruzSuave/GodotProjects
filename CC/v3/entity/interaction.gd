extends Node2D

@onready var raycast: RayCast2D = $RayCast2D

@export var component_target : CharacterBody2D

func can_interact() -> bool:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is TileMapLayer:
			var collision_point : = raycast.get_collision_point() 
			collision_point -= raycast.get_collision_normal()
			var tilemap : = collider as TileMapLayer
			var tile_coords : = tilemap.local_to_map(tilemap.to_local(collision_point))
			if tilemap.get_cell_source_id(tile_coords) != -1:
				return true
	return false
	
func grab() -> Object:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is TileMapLayer:
			var collision_point : = raycast.get_collision_point() 
			collision_point -= raycast.get_collision_normal() * 8
			var tilemap : = collider as TileMapLayer
			var tile_coords : = tilemap.local_to_map(tilemap.to_local(collision_point))
			if tilemap.get_cell_source_id(tile_coords) != -1:
				
				var new_object : = StaticBody2D.new()
				var new_object_collision : = CollisionShape2D.new()
				new_object_collision.shape = RectangleShape2D.new()
				new_object_collision.shape.extents = tilemap.tile_set.tile_size / 2.0
				var new_object_sprite : = Sprite2D.new()
				new_object_sprite.texture = get_cell_texture(tilemap, tile_coords)
				new_object.add_child(new_object_collision)
				new_object.add_child(new_object_sprite)
				
				tilemap.set_cell(tile_coords)
				return new_object
	return null

func get_cell_texture(tilemap : TileMapLayer, coord : Vector2i) -> Texture:
	var source_id := tilemap.get_cell_source_id(coord)
	if source_id == -1:
		pass
	var source:TileSetAtlasSource = tilemap.tile_set.get_source(source_id) as TileSetAtlasSource
	var altas_coord := tilemap.get_cell_atlas_coords(coord)
	var rect := source.get_tile_texture_region(altas_coord)
	var image:Image = source.texture.get_image()
	var tile_image := image.get_region(rect)
	return ImageTexture.create_from_image(tile_image)

func place(item : Object) -> bool:
	if can_interact():
		return false
	var item_parent  = item.get_parent()
	if item_parent != null:
		item_parent.remove_child(item)
	component_target.add_sibling(item)
	item.global_position = (global_position + raycast.target_position.rotated(global_rotation)).snapped(Vector2(16,16))
	return true
	##if item is Tile:
	#if raycast.is_colliding():
		#var collider = raycast.get_collider()
		#if collider is TileMapLayer:
			#var collision_point : = raycast.get_collision_point() 
			#collision_point -= raycast.get_collision_normal()
			#var tilemap : = collider as TileMapLayer
			#var tile_coords : = tilemap.local_to_map(collision_point)
			#if tilemap.get_cell_source_id(tile_coords) != -1:
				#return false
	#
	#return true
				
				
				
				
				
				
