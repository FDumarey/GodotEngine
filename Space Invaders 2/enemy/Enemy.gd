extends Area2D

signal shoot
signal killed

export (PackedScene) var Bullet
export (int) var speed = 150
export (int) var health = 3

var follow
var target = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.frame = randi() % 3
	var path = $EnemyPaths.get_children() [randi() % $EnemyPaths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.loop = false #default is true - so will loop
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow.offset += speed * delta
	position = follow.global_position
	if follow.unit_offset > 1: #unit is from 0 to 1
		queue_free()
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	pass # Replace with function body.

func _on_GunTimer_timeout():
	shoot_pulse(3, 0.15)
	pass # Replace with function body.

func shoot():
	$ShootSound.play()
	var dir = target.global_position - global_position
	dir = dir.rotated(rand_range(-0.1, 0.1)).angle()
	emit_signal("shoot", Bullet, global_position, dir)

func shoot_pulse(n, delay):
	for i in range(n):
		shoot()
		yield(get_tree().create_timer(delay), 'timeout')

func take_damage(amount):
	health -= amount
	$AnimationPlayer.play("flash")
	emit_signal("killed", 5)
	if health <= 0:
		explode()
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("rotate")

func explode():
	$ExplodeSound.play()
	emit_signal("killed", 10)
	speed = 0
	$GunTimer.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.hide()
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	$ExplodeSound.play()

func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		body.shield -= 50
		explode()
	pass # Replace with function body.

