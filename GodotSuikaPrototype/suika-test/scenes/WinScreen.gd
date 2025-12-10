extends CanvasLayer

@onready var win_label = $WinLabel

func _ready():
	hide()

func show_win(recipe_name: String):
	show()
	win_label.text = "RECIPE COMPLETE!" 

func _input(event):
	if visible and event.is_action_pressed("ui_accept"):
		hide()
	get_tree().paused = false
