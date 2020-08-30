extends Area2D
const MOVE_SPEED = 150.0
const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shot_scene = preload("res://shot.tscn")
var explosion_scene = preload("res://explosion.tscn")
var can_shoot = true

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = 10
	position.y = SCREEN_HEIGHT/2
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_dir = Vector2()
	if Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0
	if Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0
	
	position += (delta * MOVE_SPEED) * input_dir
	
	if position.x < 8.0:
		position.x = 8.0
	if position.x > SCREEN_WIDTH-8:
		position.x = SCREEN_WIDTH-8
	if position.y < 8.0:
		position.y = 8.0
	if position.y > SCREEN_HEIGHT-8:
		position.y = SCREEN_HEIGHT-8
	
	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
		var stage_node = get_parent()
		var shot_instance = shot_scene.instance()
		shot_instance.position = position + Vector2(9,-5)
		stage_node.add_child(shot_instance)
		var shot_instance2 = shot_scene.instance()
		shot_instance2.position = position + Vector2(9,5)
		stage_node.add_child(shot_instance2)
		can_shoot = false
		get_node("reload_timer").start()
	pass

func _on_reload_timer_timeout():
	can_shoot = true
	pass # Replace with function body.

func _on_player_area_entered(area):
	if area.is_in_group("asteroid"):
		queue_free()
		var stage_node = get_parent()
		var explosion_instance = explosion_scene.instance()
		explosion_instance.position = position
		stage_node.add_child(explosion_instance)
		emit_signal("destroyed")
	pass # Replace with function body.
