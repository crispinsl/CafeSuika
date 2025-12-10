extends Area2D

@onready var sprite = $Sprite2D  # If you added a trash sprite

func _ready():
	body_entered.connect(_on_body_entered)
	# Optional: detect when ingredient is hovering over trash
	body_entered.connect(_on_hover_start)
	body_exited.connect(_on_hover_end)

func _on_body_entered(body):
	if body.is_in_group("ingredients"):
		print("Ingredient trashed: Chain ", body.ingredient_chain, " Level ", body.ingredient_level)
		body.queue_free()

func _on_hover_start(body):
	if body.is_in_group("ingredients"):
		# Make trash glow or change color when ingredient is over it
		if sprite:
			sprite.modulate = Color(1.5, 1.5, 1.5)  # Brighten

func _on_hover_end(body):
	if body.is_in_group("ingredients"):
		# Return to normal
		if sprite:
			sprite.modulate = Color(1, 1, 1)
