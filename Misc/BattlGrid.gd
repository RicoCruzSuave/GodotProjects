@tool
extends VisualGrid2D

@export var trainer1_tex : Texture2D
@export var trainer2_tex : Texture2D

func build():
	super.build()
	draw_trainer_spots()
	
func draw_trainer_spots():
	var t_spot1 : = Sprite2D.new()
	var t_spot2 : = Sprite2D.new()
	
	var gradient:  = GradientTexture2D.new()
	gradient.width = spot_size.x
	gradient.height = spot_size.y
	gradient.fill = GradientTexture2D.FILL_RADIAL
	gradient.fill_from = Vector2.ONE / 2.0
	gradient.fill_to = Vector2.ONE
	
	gradient.gradient = Gradient.new()
	gradient.gradient.colors[0] = spot_color
	gradient.gradient.colors[1] = Color.TRANSPARENT
	gradient.gradient.offsets[0] = 0.5
	gradient.gradient.offsets[1] = 0.6
	gradient.gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	
	t_spot1.texture = gradient
	t_spot2.texture = gradient
	
	if get_node("TrainerSpots") == null:
		var t_spots_node : = Node2D.new()
		add_child(t_spots_node)
		t_spots_node.owner = get_tree().edited_scene_root
		t_spots_node.name = "TrainerSpots"
		
	var t_spots_node : = get_node("TrainerSpots")
	t_spots_node.add_child(t_spot1)
	t_spot1.owner = get_tree().edited_scene_root
	t_spot1.name = "TrainerSpot1"	
	t_spots_node.add_child(t_spot2)
	t_spot2.owner = get_tree().edited_scene_root
	t_spot2.name = "TrainerSpot2"	
	
	t_spot1.position.x = background_size.x / -2.0
	t_spot1.position.x += spot_size.x / 2
	t_spot2.position.x = background_size.x / 2.0
	t_spot2.position.x -= spot_size.x / 2
	
	var trainer_sprite_1 : = Sprite2D.new()
	t_spot1.add_child(trainer_sprite_1)
	trainer_sprite_1.owner = get_tree().edited_scene_root	
	trainer_sprite_1.name = "Trainer1"
	var trainer_sprite_2 : = Sprite2D.new()
	t_spot2.add_child(trainer_sprite_2)
	trainer_sprite_2.owner = get_tree().edited_scene_root	
	trainer_sprite_2.name = "Trainer2"
	
	trainer_sprite_1.texture = trainer1_tex
	trainer_sprite_2.texture = trainer2_tex
	trainer_sprite_1.offset = Vector2(0, -32)
	trainer_sprite_2.offset = Vector2(0, -32)
	
	
	
	
	
	
	
	
	
