extends Node2D

@export var min_x: float = 25.0
@export var max_x: float = 900.0
@export var y_position: float = 100.0

@onready var preview_sprite = $PreviewSprite

func _ready():
	position.y = y_position

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	global_position.x = clamp(mouse_pos.x, min_x, max_x)
	global_position.y = y_position

func update_preview(texture: Texture2D):
	preview_sprite.texture = texture
	preview_sprite.scale = Vector2(0.08, 0.08)
