extends Sprite2D

@onready var tutorial_character = $Root/Base/TutorialCharacter
@onready var dialogue_text = $DialogueText

var tutorial_step = 0
var tutorial_messages = [
	"Welcome! Click to drop fruit into the jar.",
	"Match two fruits of the same type to merge them!",
	"Bigger fruits give more points. Try to make the watermelon!",
	"Don't let the fruits overflow the jar. Good luck!"
]

func _ready():
	show_tutorial_message()

func show_tutorial_message():
	if tutorial_step < tutorial_messages.size():
		dialogue_text.text = tutorial_messages[tutorial_step]
		tutorial_character.visible = true
		dialogue_text.visible = true
		
		# Auto-advance after 3 seconds
		#await get_tree().create_timer(3.0).timeout
		#advance_tutorial()
	#else:
		#tutorial_character.visible = false
		#dialogue_text.visible = false

#func advance_tutorial():
	#tutorial_step += 1
	#show_tutorial_message()
