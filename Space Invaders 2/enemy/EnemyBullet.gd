extends Area2D

export (int) var speed

var velocity = Vector2()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta
	pass

func _on_EnemyBullet_body_entered(body):
	if body.name == 'Player':
		body.shield -= 15
	queue_free()
	pass # Replace with function body.

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.

func start(_position, _direction):
	position = _position
	velocity = Vector2(speed,0).rotated(_direction)
	rotation = _direction

