extends RigidBody2D

@export_node_path("Sprite2D") var world_sprite_path
@onready var world_sprite : Texture2D = get_node(world_sprite_path).texture

@onready var sensor : = $Sensor
@onready var movement : = $Movement

var knowledge : Dictionary = {
	"treasure": {
		"direction": Vector2.RIGHT,
		"distance": 10
	},
	"wall": {
		"direction": Vector2.RIGHT,
		"distance": 10
	},
	"entity": {
		"direction": Vector2.RIGHT,
		"distance": 10
	},
	"camp": {
		"direction": Vector2.RIGHT,
		"distance": 10,
		"treasure": 1
	},
}

func _process(delta):
	#Use sensor to detect things around you then update sensor
	var results : Dictionary = sensor.detect()
	sensor.update()
	#if results are different from knowledge, update
	if results:
		#update knowledge
		pass
	#Get desired direction from knowledge and move in that direction
	movement.move()







