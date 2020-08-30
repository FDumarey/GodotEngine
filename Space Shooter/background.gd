extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SCREEN_WIDTH = 320
var scroll_speed = 30.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(-scroll_speed * delta, 0.0)
	if position.x <= -SCREEN_WIDTH:
		position.x += SCREEN_WIDTH
	pass
