extends "res://Character/Character.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	can_move = false
	facing = moves.keys() [randi() % 4]
	yield(get_tree().create_timer(0.5), "timeout")
	can_move = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_move:
		if not move(facing) or randi() % 10 > 5:
			facing = moves.keys() [randi() % 4]
	pass
