extends Area2D

export (int) var speed

var tile_size = 64
var can_move = true
var facing = 'right'
var moves = {'right': Vector2(1,0), 'left': Vector2(-1,0), 'up': Vector2(0,-1), 'down': Vector2(0,1)} #dictionary
onready var raycasts = {'right': $RayCastRight, 'left': $RayCastLeft, 'up': $RayCastUp, 'down': $RayCastDown} #onready is needed for referencing other nodes

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move(dir):
	$AnimationPlayer.playback_speed = speed
	facing = dir
	if raycasts[facing].is_colliding():
		return
	can_move = false
	$AnimationPlayer.play(facing)
	$MoveTween.interpolate_property(self, "position", position, position + moves[facing] * tile_size, 1.0 / speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()
	return true

func _on_MoveTween_tween_completed(object, key):
	can_move = true
	pass # Replace with function body.
