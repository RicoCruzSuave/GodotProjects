@tool
extends HBoxContainer

@onready var line_edit: LineEdit = $AnimationName/LineEdit
@onready var animated_display: TextureRect = $"Animated Display"
@onready var sprite_frames: HBoxContainer = $SpriteFrames
@onready var timer: Timer = $Timer
var display_frame_counter : = 0

func _ready() -> void:
	timer.timeout.connect(display_next_frame)

func add_frame(tex : Image):
	var new_rect : = TextureRect.new()
	var new_image_texture : = ImageTexture.create_from_image(tex)
	new_rect.texture = new_image_texture
	sprite_frames.add_child(new_rect)
	
func display_next_frame():
	if sprite_frames.get_child_count():
		display_frame_counter = wrapi(display_frame_counter + 1, 0, sprite_frames.get_child_count())
		animated_display.texture = (sprite_frames.get_child(display_frame_counter) as TextureRect).texture

func get_animation_frames():
	return {"name" : line_edit.text, "frames" : sprite_frames.get_children().map(func(child): return child.texture)}

func fill_name(last_name : String):
	line_edit.text = last_name
