extends Node2D
@export var min_x: float = 470.0
@export var max_x: float = 775.0
@export var y_position: float = 100.0

func _ready():
	position.y = y_position

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	
	var clamped_x = clamp(mouse_pos.x, min_x, max_x)
	
	global_position.x = clamped_x
	global_position.y = y_position
