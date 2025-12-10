extends Node2D

const INGREDIENT_SCENE = preload("res://scenes/Ingredient.tscn")
const MAX_INGREDIENT_LEVEL = 10

@onready var recipe_label = $RecipeLabel
@onready var timer_label = $TimerLabel
@onready var cloud = $cloudspawner
@onready var jar = $Jar
@onready var recipe_ui = $UI
@onready var game_over_screen = $GameOverScreen
@onready var win_screen = $WinScreen

var can_drop: bool = true
var current_ingredient_type: int = 0
var current_recipe_name: String = ""
var time_remaining: float = 60.0  # 60 seconds per recipe
var is_game_over: bool = false
var recipes_completed: int = 0

# Ingredient progression paths
var ingredient_chains = {
	0: ["milk", "steamed_milk", "creamer", "heavy_cream", "whipped_cream"],
	1: ["coffee_bean", "coffee", "espresso"],
	2: ["sugar", "caramel_syrup", "chocolate_syrup"]
}

# Textures for each ingredient (organized by chain)
var ingredient_textures = {
	"milk": preload("res://placeholders/milk.png"),
	"steamed_milk": preload("res://placeholders/steamed_milk.png"),
	"creamer": preload("res://placeholders/creamer.png"),
	"heavy_cream": preload("res://placeholders/heavy_cream.png"),
	"whipped_cream": preload("res://placeholders/whipped_cream.png"),
	
	"coffee_bean": preload("res://placeholders/coffee_beans.png"),
	"coffee": preload("res://placeholders/coffee.png"),
	"espresso": preload("res://placeholders/espresso.png"),
	
	"sugar": preload("res://placeholders/sugar.png"),
	"caramel_syrup": preload("res://placeholders/caramel_syrup.png"),
	"chocolate_syrup": preload("res://placeholders/chocolate_syrup.png")
}

# Recipe definitions
var recipes = {
	"cappuccino": {
		"espresso": 1,
		"steamed_milk": 1
	},
	"latte": {
		"creamer": 1,
		"espresso": 1,
		"sugar": 1
	},
	"mocha": {
		"creamer": 1,
		"coffee": 1,
		"chocolate_syrup": 1
	}
}

func _ready():
	randomize_next_ingredient()
	update_cloud_preview()
	assign_random_recipe()
	
	# Setup ingredient guide with icons
	if recipe_ui:
		recipe_ui.setup_ingredient_guide_with_icons(ingredient_textures)

func _process(delta):
	if not is_game_over:
		# Count down timer
		time_remaining -= delta
		
		# Update timer display (we'll add this UI element next)
		update_timer_display()
		
		# Check for time out
		if time_remaining <= 0:
			game_over()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if can_drop and not is_game_over:
				drop_ingredient()

func assign_random_recipe():
	var recipe_names = recipes.keys()
	current_recipe_name = recipe_names[randi() % recipe_names.size()]
	print("New recipe: ", current_recipe_name)
	print("Required ingredients: ", recipes[current_recipe_name])
	
	# Update UI display
	if recipe_ui:
		recipe_ui.update_recipe_display(current_recipe_name, recipes[current_recipe_name])
	
	# Update recipe display
	if recipe_label:
		var recipe_text = "Make a " + current_recipe_name.capitalize() + "\n"
		for ingredient in recipes[current_recipe_name]:
			var amount = recipes[current_recipe_name][ingredient]
			recipe_text += ingredient.replace("_", " ").capitalize() + " x" + str(amount) + "\n"
		recipe_label.text = recipe_text

func randomize_next_ingredient():
	current_ingredient_type = randi() % 3

func drop_ingredient():
	var ingredient = INGREDIENT_SCENE.instantiate()
	
	ingredient.ingredient_chain = current_ingredient_type
	ingredient.ingredient_level = 0
	ingredient.position = Vector2(cloud.position.x, cloud.position.y + 20)
	
	add_child(ingredient)
	update_ingredient_appearance(ingredient)
	
	randomize_next_ingredient()
	update_cloud_preview()
	
	can_drop = false
	await get_tree().create_timer(1.0).timeout
	can_drop = true

func update_cloud_preview():
	var ingredient_name = ingredient_chains[current_ingredient_type][0]
	var texture = ingredient_textures[ingredient_name]
	cloud.update_preview(texture)

func spawn_merged_ingredient(ingredient_chain: int, new_level: int, spawn_position: Vector2):
	if new_level >= ingredient_chains[ingredient_chain].size():
		print("Max ingredient level reached for chain ", ingredient_chain)
		return
	
	var ingredient = INGREDIENT_SCENE.instantiate()
	ingredient.ingredient_chain = ingredient_chain
	ingredient.ingredient_level = new_level
	ingredient.position = spawn_position
	add_child(ingredient)
	
	update_ingredient_appearance(ingredient)
	
	# Check if recipe is complete after each merge
	check_recipe_completion()

func update_ingredient_appearance(ingredient):
	var ingredient_name = ingredient_chains[ingredient.ingredient_chain][ingredient.ingredient_level]
	var texture = ingredient_textures[ingredient_name]
	
	ingredient.get_node("Sprite2D").texture = texture
	
	var scale_factor = 0.15 + (ingredient.ingredient_level * 0.05)
	ingredient.get_node("Sprite2D").scale = Vector2(scale_factor, scale_factor)
	ingredient.get_node("CollisionShape2D").scale = Vector2(scale_factor, scale_factor)

func check_recipe_completion():
	# Count all ingredients currently in the jar
	var ingredient_count = {}
	
	for node in get_tree().get_nodes_in_group("ingredients"):
		var ingredient_name = ingredient_chains[node.ingredient_chain][node.ingredient_level]
		
		if ingredient_name in ingredient_count:
			ingredient_count[ingredient_name] += 1
		else:
			ingredient_count[ingredient_name] = 1
	
	print("Current ingredients in jar: ", ingredient_count)
	print("Recipe requires: ", recipes[current_recipe_name])
	
	# Check if it matches the current recipe
	var recipe_requirements = recipes[current_recipe_name]
	var recipe_complete = true
	
	# Check if we have AT LEAST what the recipe needs (extras are OK!)
	for required_ingredient in recipe_requirements:
		var required_amount = recipe_requirements[required_ingredient]
		var current_amount = ingredient_count.get(required_ingredient, 0)
		
		print("Checking ", required_ingredient, ": need ", required_amount, ", have ", current_amount)
		
		# Changed from != to < (we need at least the required amount)
		if current_amount < required_amount:
			recipe_complete = false
			print("  -> NOT ENOUGH!")
			break
	
	# REMOVED the check for extra ingredients - extras are now allowed!
	
	print("Recipe complete? ", recipe_complete)
	
	if recipe_complete:
		print("CALLING recipe_completed()!")
		recipe_completed()

func recipe_completed():
	print("Recipe completed: ", current_recipe_name, "!")
	
	# Increment the counter
	recipes_completed += 1
	
	# Show win screen
	if win_screen:
		win_screen.show_win(current_recipe_name)
	
	# Clear all ingredients
	for node in get_tree().get_nodes_in_group("ingredients"):
		node.queue_free()
	
	# Reset timer
	time_remaining = 60.0
	
	# Assign new recipe
	assign_random_recipe()

func game_over():
	is_game_over = true
	print("GAME OVER! Time ran out!")
	
	# Show the game over screen
	if game_over_screen:
		game_over_screen.show_game_over(recipes_completed)
	
	# Freeze all ingredients (optional - stops physics)
	for node in get_tree().get_nodes_in_group("ingredients"):
		if node is RigidBody2D:
			node.freeze = true

func update_timer_display():
	if timer_label:
		timer_label.text = "Time: " + str(int(time_remaining)) + "s"
		
		# Change color when time is running out
		if time_remaining <= 10:
			timer_label.modulate = Color(1, 0, 0)  # Red
		elif time_remaining <= 20:
			timer_label.modulate = Color(1, 1, 0)  # Yellow
		else:
			timer_label.modulate = Color(1, 1, 1)  # White



# TO DO:
# set lose condition
# set win condition
# make scenes for each
# export to exe
# start diner section
# make recipes section
## timer?
## randomly go through recipes to earn cash
# convert fruits demo into individual ingredients list
