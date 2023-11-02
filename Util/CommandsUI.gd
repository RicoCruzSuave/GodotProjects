extends FlowContainer

@export_node_path("Node2D") var commands_nodepath

@onready var commands_node : = get_node(commands_nodepath)

func _ready():
	for child in get_children():
		child.free()
	for child in commands_node.get_children():
		var new_button : = Button.new()
		new_button.add_theme_font_size_override("font", 30)
		new_button.text = child.name
		new_button.name = child.name
		add_child(new_button)
		if child.has_method("prepare"):
			new_button.connect("pressed", child.prepare)
	
