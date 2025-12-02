extends RigidBody2D

var fruit_type: int = 0
var is_merging: bool = false

func _ready():
	z_index = 1  # Put fruits in front
	add_to_group("fruits")
	add_to_group("fruits")
	print("Fruit created with type: ", fruit_type)
	
	# Wait a tiny bit before enabling collision detection
	await get_tree().create_timer(0.1).timeout
	contact_monitor = true
	max_contacts_reported = 10
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	print("Collision! My type: ", fruit_type, " Other: ", body.name)
	
	if body.is_in_group("fruits"):
		print("Other fruit type: ", body.fruit_type)
		if body.fruit_type == fruit_type:
			# Only merge if this fruit has a lower instance ID (prevents both from merging)
			if fruit_type >= get_parent().MAX_FRUIT_TYPE - 1:
				print("Already max fruit! Can't merge further")
				return
			if get_instance_id() < body.get_instance_id():
				print("MERGING!")
				merge_with(body)
			else:
				print("Other fruit will handle the merge")
		else:
			print("Types don't match")
	else:
		print("Not a fruit (probably wall/jar)")

func merge_with(other_fruit):
	if is_merging or other_fruit.is_merging:
		print("Already merging, skipping")
		return
	
	print("MERGE HAPPENING!")
	is_merging = true
	other_fruit.is_merging = true
	
	var spawn_pos = (position + other_fruit.position) / 2
	
	get_parent().spawn_merged_fruit(fruit_type + 1, spawn_pos)
	
	other_fruit.queue_free()
	queue_free()
