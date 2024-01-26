extends GJAnt
@onready var ant_scene : = preload("res://Misc/gj_ant.tscn")

@export_group("UnitCosts")
@export var digger_cost : = 10
@export var launcher_cost : = 100
@export var bridger_cost : = 50
@export var grabber_cost : = 20

#UI
@onready var energy_label : = $CanvasLayer/UI/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var energy_bar : = $CanvasLayer/UI/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar

@export_group("Energy")
@export var energy : = 100
@export var energy_timer : = 1.0
var current_timer : = 0.0

var previous_position : = Vector2.ZERO

func _process(delta):
	physics_movement(delta)
	velocity.x += get_user_input().x * 10
	move_and_slide()
	
	var direction_traveled : = velocity.normalized()
	direction_traveled.x = sign(direction_traveled.x)
	direction_traveled.y = 0
	#var direction_traveled : = global_position.direction_to(previous_position)
	if direction_traveled != Vector2.ZERO:
		dir = get_vec_dir(Vector2i(direction_traveled))
	#print(direction_traveled)
	#print(Vector2i(direction_traveled))
	#print(get_dir(dir))
	#print("------")
	
	#UI
	update_holding()
	energy_label.text = "Energy: " + str(energy)
	energy_bar.value = energy
	#Energy update
	current_timer += delta
	if current_timer > energy_timer:
		current_timer = 0.0
		energy += 1
		previous_position = global_position
	
	#Check for eated
	var current_coords : = tilemap.local_to_map(tilemap.to_local(global_position))
	if tilemap.is_trap(current_coords):
		world[current_coords.x][current_coords.y].content.energy += 1
		energy -= 1
		
	#Check for win
	if global_position.y < 0:
		print("You win")
		
	
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var current_coords : = tilemap.local_to_map(tilemap.to_local(global_position))
		if holding == null:
			pick_up(current_coords + get_dir(dir))
		else:
			if tilemap.is_space_empty(current_coords + Vector2i.UP):
				if is_on_floor():
					position.y -= 16.0
					place(current_coords)
	if Input.is_action_just_pressed("up"):
		#if is_on_floor():
		jump(45.0)
	if Input.is_action_just_pressed("down"):
		eat()
		
func eat():
	if holding != null and holding.id != 2:
		energy += holding.energy
	holding = null

func spawn_digger():
	if energy > digger_cost:
		var new_ant : = ant_scene.instantiate()
		new_ant.global_position = global_position
		new_ant.dir = dir
		new_ant.digger = true
		parent.add_child(new_ant)
		energy -= digger_cost
	
func spawn_launcher():
	if energy > launcher_cost:
		var new_ant : = ant_scene.instantiate()
		new_ant.global_position = global_position
		new_ant.dir = dir
		new_ant.launcher = true
		parent.add_child(new_ant)
		energy -= launcher_cost
	
func spawn_grabber():
	if energy > grabber_cost:
		var new_ant : = ant_scene.instantiate()
		new_ant.global_position = global_position
		new_ant.dir = dir
		new_ant.grabber = true
		parent.add_child(new_ant)
		energy -= grabber_cost
	
func spawn_bridger():
	if energy > bridger_cost:
		var new_ant : = ant_scene.instantiate()
		new_ant.global_position = global_position
		new_ant.dir = dir		
		new_ant.bridger = true
		parent.add_child(new_ant)
		energy -= bridger_cost

#func pick_up(pos : Vector2):
	#var coords : = tilemap.local_to_map(tilemap.to_local(pos))
	#if tilemap.is_wall(coords):
		#tilemap.delete_cell(coords)
		#dirt += 1
#
#func place(pos : Vector2):
	#var current_pos : = tilemap.local_to_map(tilemap.to_local(global_position))
	#var coords : = tilemap.local_to_map(tilemap.to_local(pos))
	#if current_pos == coords:
		#return
	#if dirt > 0 and tilemap.is_space_empty(coords):
		#tilemap.place_wall(coords)
		#dirt -= 1
	#
func get_user_input() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)


