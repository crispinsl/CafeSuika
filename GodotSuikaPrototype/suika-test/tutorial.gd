extends Node
@onready var tutorial_character = $TutorialCharacter
@onready var dialogue_text = $DialogueText
@onready var speech_bubble = $SpeechBubble

var tutorial_step = 0
var tutorial_messages = [
	"Hi, I'm Cappy! Welcome to Cafe Suika!",
	"Here, we use a special recipe: we have to match the ingredients first.",
	"Merge ingredients together to complete recipes. For our first one, let's make a cappuchino!",
	"If you have an ingredient you don't need, toss it in the garbage on the left.",
	"Finish the recipe before the timer runs out. Good luck!"
]

# Preload your 4 character sprites
var character_sprites = [
	preload("res://placeholders/cappy_1.png"),
	preload("res://placeholders/cappy_2.png"),
	preload("res://placeholders/cappy_3.png"),
	preload("res://placeholders/cappy_4.png")
]

var current_sprite_index = 0
var is_talking = false

func _ready():
	call_deferred("show_tutorial_message")

func show_tutorial_message():
	if tutorial_step < tutorial_messages.size():
		dialogue_text.set_text(tutorial_messages[tutorial_step])
		tutorial_character.visible = true
		dialogue_text.visible = true
		speech_bubble.visible = true
		
		# Start animating the character
		is_talking = true
		animate_character()
		
		# Auto-advance after 3 seconds
		await get_tree().create_timer(3.0).timeout
		is_talking = false
		advance_tutorial()
	else:
		# Stop talking animation
		is_talking = false
		dialogue_text.visible = false
		speech_bubble.visible = false

func animate_character():
	while is_talking:
		# Cycle through sprites
		tutorial_character.texture = character_sprites[current_sprite_index]
		current_sprite_index = (current_sprite_index + 1) % character_sprites.size()
		
		# Wait before changing to next sprite (adjust speed here)
		await get_tree().create_timer(3).timeout  # Change sprite every 0.2 seconds

func advance_tutorial():
	tutorial_step += 1
	show_tutorial_message()
