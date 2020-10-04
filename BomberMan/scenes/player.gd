extends KinematicBody2D

const WALK_SPEED = 200
var dead = false
var direction = Vector2()
var current_animation = "idle"
var can_drop_bombs = true
onready var tilemap = get_node("/root/Arena/TileMap")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		return
	if Input.is_action_just_pressed("ui_select") and can_drop_bombs:
		dropbomb(tilemap.centered_world_pos(position))
		can_drop_bombs = false
		drop_bomb_cooldown.start()

sync func dropbomb(pos):
	var bomb = bomb_scene.instance()
	bomb.position = pos
	bomb.owner = self
	get_node("/root/Arena").add_child(bomb)

func _on_DropBombCooldown_timeout():
	can_drop_bombs = true

func _physics_process(delta):
	if dead:
		return
	if (Input.is_action_pressed("ui_up")):
		direction.y = - WALK_SPEED
	elif (Input.is_action_pressed("ui_down")):
		direction.y = WALK_SPEED
	else:
		direction.y = 0
	if (Input.is_action_pressed("ui_left")):
		direction.x = - WALK_SPEED
	elif (Input.is_action_pressed("ui_right")):
		direction.x = WALK_SPEED
	else:
		direction.x = 0
	move_and_slide(direction)
	rotation = atan2(direction.y, direction.x)
	var new_animation = "idle"
	if direction:
		new_animation = "walking"
	if new_animation != current_animation:
		$AnimationPlayer.play(new_animation)
		current_animation = new_animation
	