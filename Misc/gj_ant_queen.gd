extends GJAnt

@onready var ant_scene : = preload("res://Misc/gj_ant.tscn")


@onready var camera : = $Camera2D
@onready var world_center : = $Marker2D
var camera_following : = true

var dirt : = 0

func _process(delta):
	physics_movement(delta)
	velocity.x += get_user_input().x * 10
	move_and_slide()
	
	dir = get_vec_dir(Vector2i())
	#Camera
	var tween : = get_tree().create_tween()
	tween.set_parallel(true)
	if camera_following:
		tween.tween_property(camera, "zoom", Vector2(2, 2), 0.5)
		tween.tween_property(camera, "global_position", global_position, 0.5)
	else:
		tween.tween_property(camera, "zoom", Vector2(0.5, 0.5), 0.5)	
		tween.tween_property(camera, "global_position", world_center.global_position, 0.5)			
	tween.play()

	
func _input(event):
	
	if Input.is_action_just_pressed("left_click"):
		var new_ant : = ant_scene.instantiate()
		new_ant.global_position = global_position
		parent.add_child(new_ant)
		#pick_up(global_position + get_user_input() * 16)
	if Input.is_action_just_pressed("right_click"):
		var new_ant : = ant_scene.instantiate()
		new_ant.global_position = global_position
		new_ant.digger = true
		parent.add_child(new_ant)
		#place(global_position + get_user_input() * 16)
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jump(40.0)
	if Input.is_action_just_pressed("tab"):
		camera_following = not camera_following

func pick_up(pos : Vector2):
	var coords : = tilemap.local_to_map(tilemap.to_local(pos))
	if tilemap.is_wall(coords):
		tilemap.delete_cell(coords)
		dirt += 1

func place(pos : Vector2):
	var current_pos : = tilemap.local_to_map(tilemap.to_local(global_position))
	var coords : = tilemap.local_to_map(tilemap.to_local(pos))
	if current_pos == coords:
		return
	if dirt > 0 and tilemap.is_space_empty(coords):
		tilemap.place_wall(coords)
		dirt -= 1
	
func get_user_input() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)


