extends CanvasLayer

@onready var game_over_label = $GameOverLabel
@onready var restart_label = $RestartLabel

func _ready():
	hide()

func show_game_over(recipes_completed: int = 0):
	show()
	
	# Just show "GAME OVER" without the recipe count
	game_over_label.text = "GAME OVER"

func _input(event):
	if visible and event.is_action_pressed("ui_accept"):
		restart_game()

func restart_game():
	get_tree().reload_current_scene()
