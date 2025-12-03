extends Node2D

# Preload your fruit scene
const FRUIT_SCENE = preload("res://scenes/FRUIT_SCENE.tscn")
const MAX_FRUIT_TYPE = 6

# Preload all your fruit sprites
var fruit_textures = [
	preload("res://placeholders/cherryplace.png"),
	preload("res://placeholders/strawberryplace.png"),
	preload("res://placeholders/grapeplace.png"),
	preload("res://placeholders/appleplace.png"),
	preload("res://placeholders/orangeplace.png"),
	preload("res://placeholders/watermelon_place.png")]

@onready var cloud = $cloudspawner

var can_drop: bool = true
var cloud_position: Vector2
var current_fruit_type: int = 0

func _process(delta):
	# Update cloud_position every frame
	cloud_position = cloud.position

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if can_drop:
				drop_fruit()

func drop_fruit():
	var fruit = FRUIT_SCENE.instantiate()
	
	fruit.fruit_type = current_fruit_type
	fruit.position = Vector2(cloud.position.x, cloud.position.y + 20)
	
	add_child(fruit)
	
	update_fruit_appearance(fruit)
	
	current_fruit_type = int(round(randf_range(1, 4)))
	
	can_drop = false
	await get_tree().create_timer(1.0).timeout
	can_drop = true

func spawn_merged_fruit(new_type: int, spawn_position: Vector2):
	if new_type >= MAX_FRUIT_TYPE:
		print("Max fruit reached!")
		return
	
	var fruit = FRUIT_SCENE.instantiate()
	fruit.fruit_type = new_type
	fruit.position = spawn_position
	add_child(fruit)
	
	# Update sprite/size based on fruit_type
	update_fruit_appearance(fruit)

func update_fruit_appearance(fruit):
	# Set the texture based on fruit type
	if fruit.fruit_type < fruit_textures.size():
		fruit.get_node("Sprite2D").texture = fruit_textures[fruit.fruit_type]
		
	# Scale down - adjust these numbers to make fruits smaller
	var base_scale = 0.2  # Start smaller (was 1.0)
	var scale_increment = 0.1  # Grow less per type (was 0.2)
	var scale_factor = base_scale + (fruit.fruit_type * scale_increment)
	
	fruit.get_node("Sprite2D").scale = Vector2(scale_factor, scale_factor)
	fruit.get_node("CollisionShape2D").scale = Vector2(scale_factor * 1, scale_factor * 1)



# TO DO:
# make it so current 'fruit' is visible in cloud
# set lose condition
# set win condition
# make scenes for each
# DONT fix cloud - instead put a trash can there for circles player wants to discard
# export to exe
# start diner section
# make recipes section
## timer?
## randomly go through recipes to earn cash
# convert fruits demo into individual ingredients list
