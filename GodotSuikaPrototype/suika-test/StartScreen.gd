extends Control

@onready var start_button = $StartButton

func _ready():
	# Connect the button press signal
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	# Fade out
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	# Load the main game scene
	get_tree().change_scene_to_file("res://scenes/base.tscn")  # Adjust path to your main game scene
