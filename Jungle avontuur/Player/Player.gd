extends KinematicBody2D

signal life_changed
signal dead

export (int) var run_speed
export (int) var jump_speed
export (int) var gravity
export (int) var climb_speed

enum {IDLE, RUN, JUMP, HURT, DEAD, CROUCH, CLIMB}

var life
var state
var anim
var new_anim
var velocity = Vector2()
var max_jumps = 2
var jump_count = 0
var is_on_ladder = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(IDLE)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			new_anim = 'idle'
		RUN:
			new_anim = 'run'
		HURT:
			new_anim = 'hurt'
			$Hurt.play()
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			emit_signal("life_changed", life)
			yield(get_tree().create_timer(0.5), "timeout")
			change_state(IDLE)
			if life <= 0:
				change_state(DEAD)
		JUMP:
			new_anim = 'jump_up'
			jump_count = 1
		DEAD:
			emit_signal("dead")
			hide()
		CROUCH:
			new_anim = 'crouch'
		CLIMB:
			new_anim = 'climb'

func _physics_process(delta):
	if state != CLIMB:
		velocity.y += gravity * delta
	get_input()
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)
	
	#move the player
	velocity = move_and_slide(velocity, Vector2(0,-1)) #2nd argument = normal vector of the ground
	if state == HURT:
		return
	
	#check collisions
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == 'Danger':
			hurt()
		if collision.collider.is_in_group('enemies'):
			var player_feet = (position + $CollisionShape2D.shape.extents).y
			if player_feet < collision.collider.position.y:
				collision.collider.take_damage()
				velocity.y = -200
			else:
				hurt()
		
	#jump ends
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		$Dust.emitting = true
	if state == JUMP and velocity.y > 0:
		new_anim = 'jump_down'
	
	#infinite fall
	if position.y > 1000:
		change_state(DEAD)

func get_input():
	if state == HURT:
		return # no movement during hurt state
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	var down = Input.is_action_pressed("crouch")
	var climb = Input.is_action_pressed("climb")
	
	#calculate movement for left,right
	velocity.x = 0
	if right:
		velocity.x += run_speed
		$Sprite.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite.flip_h = true
	
	#double jump
	if jump and state == JUMP and jump_count < max_jumps:
		new_anim = 'jump_up'
		velocity.y = jump_speed / 1.5
		jump_count += 1
	
	#calculate movement for jumping
	if jump and is_on_floor():
		change_state(JUMP)
		$Jump.play()
		velocity.y = jump_speed
	
	#IDLE to run state change when moving
	if state in [IDLE, CROUCH] and velocity.x != 0:
		change_state(RUN)
	
	#RUN to idle when stopping to move
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	
	#when falling from an edge, go to JUMP state
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	
	#crouch
	if down and is_on_floor():
		change_state(CROUCH)
	if !down and state == CROUCH:
		change_state(IDLE)
	
	#climb on ladder
	if climb and state != CLIMB and is_on_ladder:
		change_state(CLIMB)
	if state == CLIMB:
		if climb:
			velocity.y = -climb_speed
		elif down:
			velocity.y = climb_speed
		else:
			velocity.y = 0
			$AnimationPlayer.play("climb")
	if state == CLIMB and not is_on_ladder:
		change_state(IDLE)

func start(pos):
	position = pos
	show()
	change_state(IDLE)
	life = 3
	emit_signal("life_changed", life)

func hurt():
	if state != HURT:
		change_state(HURT)
