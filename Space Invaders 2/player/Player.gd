extends RigidBody2D

signal shoot
signal lives_changed
signal dead
signal shield_changed

enum {INIT, ALIVE, INVULNERABLE, DEAD}
var state = INIT
export (int) var engine_power
export (int) var spin_power
export (PackedScene) var Bullet
export (float) var fire_rate
export (int) var max_shield
export (float) var shield_regen

var thrust = Vector2()
var rotation_dir = 0
var screensize = Vector2()
var can_shoot = true
var lives = 0 setget set_lives #call function whenever the variable changes
var shield = 0 setget set_shield

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$GunTimer.wait_time = fire_rate
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	self.shield += shield_regen * delta
	pass

func change_state(new_state):
	match new_state:
		INIT:
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite.modulate.a = 0.5 # set alpha channel of sprite, transparancy
		ALIVE:
			$CollisionShape2D.set_deferred("disabled", false)
			$Sprite.modulate.a = 1.0
		INVULNERABLE:
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite.modulate.a = 0.5
			$InvulnerabilityTimer.start()
		DEAD:
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite.hide()
			$EngineSound.stop()
			linear_velocity = Vector2()
			emit_signal("dead")
	state = new_state

func get_input():
	$Exhaust.emitting = false
	thrust = Vector2()
	rotation_dir = 0
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed("thrust"):
		$Exhaust.emitting = true
		thrust = Vector2(engine_power,0)
		if not $EngineSound.playing:
			$EngineSound.play()
	else:
		$EngineSound.stop()
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func _integrate_forces(physics_state):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(spin_power * rotation_dir)
	var xform = physics_state.get_transform()
	if xform.origin.x > screensize.x:
		xform.origin.x = 0
	if xform.origin.x < 0:
		xform.origin.x = screensize.x
	if xform.origin.y > screensize.y:
		xform.origin.y = 0
	if xform.origin.y < 0:
		xform.origin.y = screensize.y
	physics_state.set_transform(xform)

func shoot():
	if state == INVULNERABLE:
		return
	emit_signal("shoot", Bullet, $Muzzle.global_position, rotation)
	can_shoot = false
	$LaserSound.play()
	$GunTimer.start()

func _on_GunTimer_timeout():
	can_shoot = true
	pass # Replace with function body.

func set_lives(value):
	lives = value
	self.shield = max_shield
	emit_signal("lives_changed", lives)

func start():
	$Sprite.show()
	self.lives = 3 #the self keyword disables the call of set_lives
	self.shield = max_shield
	change_state(ALIVE)

func _on_InvulnerabilityTimer_timeout():
	change_state(ALIVE)
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	$Explosion.hide()
	pass # Replace with function body.


func _on_Player_body_entered(body):
	if body.is_in_group('rocks'):
		body.explode()
		$Explosion.show()
		$Explosion/AnimationPlayer.play("explosion")
		self.shield -= body.size * 25
		self.lives -= 1
		if lives <= 0:
			change_state(DEAD)
		else:
			change_state(INVULNERABLE)
	pass # Replace with function body.

func set_shield(value):
	if value > max_shield:
		value = max_shield
	shield = value
	emit_signal("shield_changed", shield/max_shield * 100)
	if shield <= 0:
		self.lives -= 1

