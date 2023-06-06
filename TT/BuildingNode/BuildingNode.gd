@tool
extends EditorPlugin

var main_screen
var interface 


func _enter_tree():
	main_screen = get_editor_interface().get_editor_main_screen()
	interface = preload("res://TT/BuildingNode/BuildingNodeInterface.tscn")
	
	main_screen.add_child(interface)

func _exit_tree():
	interface.free()
