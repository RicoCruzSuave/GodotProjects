extends RigidBody2D

enum TRAVEL_TYPE {
	BALL,
	ARROW,
	PATH,
	AREA
}

@export var icon : Texture2D

@export var travel_type : TRAVEL_TYPE = TRAVEL_TYPE.BALL
@export var friction : = 0.0
@export var gravity : = 98.0
@export var speed : = 10.0
@export var energy : = 10.0
@export var angle : = 0.0
