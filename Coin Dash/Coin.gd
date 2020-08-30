extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screensize = Vector2()

func pickup():
	monitoring = false # disables the area_enter collisions detection signal
	$Tween.start()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($AnimatedSprite, "scale", $AnimatedSprite.scale, $AnimatedSprite.scale * 3, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Timer.wait_time = rand_range(3, 8)
	$Timer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Tween_tween_completed(object, key):
	queue_free() #set this node in the garbage collection which runs at the end of the current frame
	pass # Replace with function body.

func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()
	pass # Replace with function body.

func _on_Coin_area_entered(area):
	if area.is_in_group("obstacles"):
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
	pass # Replace with function body.
