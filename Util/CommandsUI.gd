extends FlowContainer

@export_node_path("Node2D") var commands_nodepath

@onready var commands_node : = get_node(commands_nodepath)

func _ready():
	for child in get_children():
		child.free()
	for child in commands_node.get_children():
		add_button(child, "prepare")
	
func add_button(node : Object, method : String):
	var new_button : = Button.new()
	new_button.add_theme_font_size_override("font", 30)
	new_button.text = node.name
	new_button.name = node.name
	add_child(new_button)
	
	new_button.connect("pressed", node.call.bind(method))
