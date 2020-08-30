extends KinematicBody2D

export (int) var speed
export (int) var gravity

var velocity = Vector2()
var facing = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0
	velocity.y += gravity * delta
	velocity.x = facing * speed
	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == 'Player':
			collision.collider.hurt()
		if collision.normal.x != 0:
			facing = sign(collision.normal.x)
			velocity.y = -100
	
	if position.y > 1000:
		queue_free()

func take_damage():
	$AnimationPlayer.play("death")
	$Enemy_hit.play()
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'death':
		queue_free()
	pass # Replace with function body.
