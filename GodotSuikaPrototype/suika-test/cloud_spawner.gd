extends Node2D

@export var min_x: float = 50.0  # Minimum x position
@export var max_x: float = 2000.0  # Maximum x position
@export var y_position: float = 100.0  # Fixed y position for the cloud

func _ready():
	# Set the initial y position
	position.y = y_position

func _process(_delta):
	# Get the mouse position in the viewport
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Update the x position to follow the mouse
	global_position.x = clamp(mouse_pos.x, min_x, max_x)
	
	# Keep y position fixed
	global_position.y = y_position
	
	# Debug: print the cloud's position
	
