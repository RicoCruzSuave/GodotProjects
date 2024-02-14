extends Control

@onready var click_radius : = $ClickRadius
@onready var spell_book : = $SpellBook

var mouse_over_control : = false
var selected_object = null :
	set = set_selected_object

@onready var bottom_bar : = $BottomBar
@onready var spell_label : = $BottomBar/PanelContainer/MarginContainer/HBoxContainer3/HBoxContainer/VBoxContainer/Label
@onready var spell_option : = $BottomBar/PanelContainer/MarginContainer/HBoxContainer3/HBoxContainer/VBoxContainer/OptionButton
@onready var power_slider : = $BottomBar/PanelContainer/MarginContainer/HBoxContainer3/HBoxContainer/VBoxContainer2/HSlider
@onready var power_label : = $BottomBar/PanelContainer/MarginContainer/HBoxContainer3/HBoxContainer/VBoxContainer2/Label2
@onready var angle_label : = $BottomBar/PanelContainer/MarginContainer/HBoxContainer3/HBoxContainer/VBoxContainer3/HBoxContainer/VBoxContainer2/Label
@onready var angle_button : = $BottomBar/PanelContainer/MarginContainer/HBoxContainer3/HBoxContainer/VBoxContainer3/HBoxContainer/VBoxContainer2/TextureButton

var aiming : = false

func _ready():
	angle_button.pressed.connect(func(): aiming = true)
	#Add spells to the UI
	for spell in spell_book.get_children():
		spell_option.add_icon_item(spell.icon, spell.name)
	
func _process(delta):
	var control_rect : = Rect2(bottom_bar.global_position, bottom_bar.size)
	if control_rect.has_point(get_global_mouse_position()):
		mouse_over_control = true
	else:
		mouse_over_control = false
	
	if selected_object is SSPlayer:
		selected_object.spell_index = spell_option.selected
		selected_object.drawing = aiming
		if aiming:
			var dir_vec : Vector2 = selected_object.global_position.direction_to(get_global_mouse_position())
			selected_object.angle = dir_vec.angle()
			angle_label.text = str(-snapped(rad_to_deg(selected_object.angle), 0.01))
		
	elif selected_object is RigidBody2D:
		power_label.text = str(selected_object.energy)
		power_slider.value = selected_object.energy

func _input(event):
	#On click
	if event is InputEventMouseButton and event.is_pressed():
		if not mouse_over_control:
			#Stop drawing angle line
			if aiming:
				aiming = false
				selected_object.queue_redraw()
			#Move object selector
			click_radius.global_position = get_global_mouse_position()
			await get_tree().physics_frame
			await get_tree().physics_frame
			if click_radius.has_overlapping_bodies():
				for object in click_radius.get_overlapping_bodies():
					if object is StaticBody2D:
						continue
					selected_object = object
					break
			else:
				selected_object = null
			
			
func set_selected_object(new_object):
	selected_object = new_object
	if selected_object is SSPlayer:
		spell_label.text = selected_object.name
		spell_option.select(selected_object.spell_index)
	elif selected_object is RigidBody2D:
		spell_label.text = "Spell: " + selected_object.name	
