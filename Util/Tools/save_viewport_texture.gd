@tool
extends Sprite2D

@export_tool_button("Save Texture") var st_var : = _save_texture

func _save_texture():
	var vp_path : = (texture as ViewportTexture).viewport_path
	var new_tex_vp : Viewport = get_tree().edited_scene_root.get_node(vp_path)
	var new_tex : = new_tex_vp.get_texture()
	var new_tex_path = get_script().get_path().get_base_dir()
	var error : = new_tex.get_image().save_png("{0}/{1}.png".format([new_tex_path, name]))
	print(error)
	#var new_tex_image : = load()
	#texture = ImageTexture.create_from_image()
