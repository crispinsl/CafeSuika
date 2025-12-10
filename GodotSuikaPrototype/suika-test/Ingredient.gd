extends RigidBody2D

var ingredient_chain: int = 0  # Which chain: 0=milk, 1=coffee, 2=sugar
var ingredient_level: int = 0  # Level in the chain: 0=base, 1=first upgrade, etc.
var is_merging: bool = false

func _ready():
	add_to_group("ingredients")
	
	await get_tree().create_timer(0.1).timeout
	contact_monitor = true
	max_contacts_reported = 10
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	# Check if it's an ingredient
	if body.is_in_group("ingredients") and not is_merging:
		# Can only merge with same chain AND same level
		if body.ingredient_chain == ingredient_chain and body.ingredient_level == ingredient_level:
			# Only let one ingredient handle the merge
			if get_instance_id() < body.get_instance_id():
				merge_with(body)

func merge_with(other_ingredient):
	if is_merging or other_ingredient.is_merging:
		return
	
	is_merging = true
	other_ingredient.is_merging = true
	
	var spawn_pos = (position + other_ingredient.position) / 2
	
	# Merge to next level in the same chain
	get_parent().spawn_merged_ingredient(ingredient_chain, ingredient_level + 1, spawn_pos)
	
	other_ingredient.queue_free()
	queue_free()
