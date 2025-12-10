extends CanvasLayer

@onready var recipe_name_label = $RightPanel/RecipeNameLabel
@onready var recipe_ingredients_container = $RightPanel/RecipeIngredientsContainer
@onready var ingredient_guide_container = $RightPanel/IngredientGuideContainer

var ingredient_chains = {
	0: ["milk", "steamed_milk", "creamer", "heavy_cream", "whipped_cream"],
	1: ["coffee_bean", "coffee", "espresso"],
	2: ["sugar", "caramel_syrup", "chocolate_syrup"]
}

func _ready():
	# Don't setup here - wait for base.gd to call it with textures
	pass

func update_recipe_display(recipe_name: String, recipe_requirements: Dictionary):
	if not recipe_name_label or not recipe_ingredients_container:
		return
	
	# Update recipe name
	recipe_name_label.text = recipe_name.capitalize()
	
	# Clear previous ingredients
	for child in recipe_ingredients_container.get_children():
		child.queue_free()
	
	# Add each required ingredient
	for ingredient in recipe_requirements:
		var amount = recipe_requirements[ingredient]
		var label = Label.new()
		label.text = "• " + ingredient.replace("_", " ").capitalize() + " x" + str(amount)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.add_theme_font_size_override("font_size", 16)
		recipe_ingredients_container.add_child(label)

func setup_ingredient_guide_with_icons(ingredient_textures: Dictionary):
	# Clear any existing guide
	for child in ingredient_guide_container.get_children():
		child.queue_free()
	
	var chain_names = ["Milk Chain", "Coffee Chain", "Sugar Chain"]
	
	for chain_id in ingredient_chains:
		# Chain title
		var title = Label.new()
		title.text = chain_names[chain_id] + ":"
		title.add_theme_font_size_override("font_size", 14)
		title.add_theme_color_override("font_color", Color(1, 0.8, 0.4))
		ingredient_guide_container.add_child(title)
		
		# Each ingredient with icon
		var chain = ingredient_chains[chain_id]
		for i in range(chain.size()):
			var ingredient_name = chain[i]
			
			# Create HBox for icon + text
			var hbox = HBoxContainer.new()
			
			# Add arrow for non-first items
			if i > 0:
				var arrow = Label.new()
				arrow.text = "  ↓  "
				hbox.add_child(arrow)
			else:
				var spacer = Label.new()
				spacer.text = "     "
				hbox.add_child(spacer)
			
			# Add ingredient icon
			var icon = TextureRect.new()
			icon.texture = ingredient_textures[ingredient_name]
			icon.custom_minimum_size = Vector2(35, 35)
			icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE  # Add this line!
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			hbox.add_child(icon)
			
			# Add ingredient name
			var label = Label.new()
			label.text = " " + ingredient_name.replace("_", " ").capitalize()
			label.add_theme_font_size_override("font_size", 12)
			hbox.add_child(label)
			
			ingredient_guide_container.add_child(hbox)
		
		# Smaller spacing
		var spacer = Control.new()
		spacer.custom_minimum_size = Vector2(0, 5)  # Only 5 pixels of space
		ingredient_guide_container.add_child(spacer)
