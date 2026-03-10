@tool
extends Window

@onready var button: Button = $Control/Button
@onready var animation_list: VBoxContainer = $Control/AnimationListScroll/AnimationList
const ANIMATION_IMPORT_LINE = preload("uid://cj4ntna3bwmvf")
var sprite_size : = Vector2(32,32)
var files : = []
var max_rows : = 0

signal animations_loaded

func _ready():
	button.pressed.connect(_on_ok_button_pressed)

func _on_ok_button_pressed():
	var all_animations : = []
	for child in animation_list.get_children():
		all_animations.append(child.get_animation_frames())
	animations_loaded.emit(all_animations)
	hide() 
	
func load_file(file):
	## Load and check for empty
	var image : = Image.load_from_file(file)
	if image.is_empty():
		print("Failed to load image from path: ", file)
		return
	## Get number of rows
	var tex_rows : int = image.get_height() / sprite_size.y
	max_rows = max(max_rows, tex_rows)
	for y in range(tex_rows):
		## Add the row control 
		var row : = ANIMATION_IMPORT_LINE.instantiate()
		animation_list.add_child(row)
		
		var tex_cols : int = image.get_width() / sprite_size.x
		for x in range(tex_cols):
			var full_slice_image : = image.get_region(Rect2i(
				x * sprite_size.x, 
				y * sprite_size.y, 
				sprite_size.x, 
				sprite_size.y
			))
			row.add_frame(full_slice_image)
			
func populate_last_used_names(last_used_names : Array):
	for i in animation_list.get_child_count():
		animation_list.get_child(i).fill_name(last_used_names[i])
	
	
	
	
	
	
	
	
	
	
	
