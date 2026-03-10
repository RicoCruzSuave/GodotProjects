@tool
extends EditorScript

var file_dialog : EditorFileDialog = null
#var options_dialog : Editor
var options_popup 
var options_popup_scene : = preload("uid://0si838m8w0f5")

const SAVE_PATH := "user://sprite_importer_data.tres"


func _run():
	if not EditorInterface.get_selection().get_top_selected_nodes()[0] is AnimatedSprite2D:
		print_debug("Wrong node")
		return
	
	file_dialog = EditorFileDialog.new()
	
	# 2. Configure the dialog properties
	file_dialog.title = "Select a File"
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILES # or use other modes like OPEN_DIR, SAVE_FILE, etc.
	file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM # access the host filesystem
	file_dialog.clear_filters()
	file_dialog.add_filter("*.png; Image Files")
	file_dialog.add_filter("*.* ; All Files")

	#file_dialog.connect("file_selected", Callable(self, "_on_file_selected"), CONNECT_DEFERRED)
	file_dialog.files_selected.connect(_on_file_selected)
	
	file_dialog.set_meta("_created_by", self) 

	EditorInterface.popup_dialog_centered_clamped(file_dialog, Vector2(800, 600))

func _on_file_selected(paths: PackedStringArray):
	if options_popup == null:
		options_popup = options_popup_scene.instantiate()
	
	if file_dialog:
		file_dialog.queue_free()
		file_dialog = null
		
	EditorInterface.popup_dialog_centered_clamped(options_popup, Vector2(800, 600))
	options_popup.animations_loaded.connect(add_animations)
	
	options_popup.set_meta("_created_by", self) 
	
	for path in paths:
		print("Selected file path: ", path)
		options_popup.load_file(path)	
		#sprite_frames.add_animation()
	
	if ResourceLoader.exists(SAVE_PATH):
		var loaded_data : = load(SAVE_PATH)
		print(loaded_data.last_used_names)
		if loaded_data != null and loaded_data.last_used_names != []:
			options_popup.populate_last_used_names(loaded_data.last_used_names)

func add_animations(animations : Array):
	if options_popup:
		options_popup.queue_free()
		options_popup = null
	
	var sprite : AnimatedSprite2D = EditorInterface.get_selection().get_top_selected_nodes()[0]
	var sprite_frames : = sprite.sprite_frames
	for anim in animations:
		sprite_frames.add_animation(anim["name"])
		for frame in anim["frames"]:
			sprite_frames.add_frame(anim["name"], frame)
	
	save_data({"last_used_names": animations.map(func(anim): return anim["name"])})
	
func save_data(data : Dictionary):
	var new_save_data : = SaveData.new()
	if data.has("last_used_names"):
		new_save_data.last_used_names = data["last_used_names"]
		
	var error = ResourceSaver.save(new_save_data, SAVE_PATH)
	if error == OK:
		print("Editor data saved successfully to ", SAVE_PATH)
	else:
		print("Error saving editor data: ", error)
	
	
	
class SaveData extends Resource:
	var last_used_names : = [] 
	
	
	
	
	
	
