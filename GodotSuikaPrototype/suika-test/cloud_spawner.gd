extends Node2D
@export var min_x: float = 470.0
@export var max_x: float = 775.0
@export var y_position: float = 100.0

func _ready():
	position.y = y_position

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	
	print("Mouse X: ", mouse_pos.x)
	print("Before clamp - cloud X: ", global_position.x)
	
	var clamped_x = clamp(mouse_pos.x, min_x, max_x)
	print("After clamp: ", clamped_x)
	print("Min: ", min_x, " Max: ", max_x)
	print("---")
	
	global_position.x = clamped_x
	global_position.y = y_position
	
# TO DO:
# -> make new fruits past orange that dont spawn but merge
