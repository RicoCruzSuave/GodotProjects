@tool
extends Node2D

@export var tracked_objects : Array[Node] = []
@export_tool_button("Test populate") var tp_var : = populate

@onready var tree: Tree = $CanvasLayer/PanelContainer/Tree


func populate():
	var tree_root : = tree.create_item()
	tree_root.set_text(0,"Debug")
	for obj in tracked_objects:
		var obj_item : = tree.create_item(tree_root)
		obj_item.set_text(0, obj.name)
		for method in obj.get_method_list():
			var method_item : = tree.create_item(obj_item)
			method_item.set_text(0, method["name"])
		
