extends Node

var shots = 0
var state
var power = 0
var power_change = 1
var power_speed = 100
var angle_change = 1
var angle_speed = 1.1
enum {SET_ANGLE, SET_POWER, SHOOT, WIN}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Arrow.hide()
	$Ball.transform.origin = $Tee.transform.origin #move ball to Tee placeholder
	change_state(SET_ANGLE)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GimbalOut.transform.origin = $Ball.transform.origin
	match state:
		SET_POWER:
			animate_power_bar(delta)
		SHOOT:
			pass
	pass

func change_state(new_state):
	state = new_state
	match state:
		SET_ANGLE:
			$Arrow.transform.origin = $Ball.transform.origin #place arrow at ball
			$Arrow.show()
		SET_POWER:
			pass
		SHOOT:
			$Arrow.hide()
			$AudioSwing.play()
			$Ball.shoot($Arrow.rotation.y, power)
			shots += 1
			$UI.update_shots(shots)
			power = 0
			$UI.update_powerbar(power)
		WIN:
			$Ball.hide()
			$Arrow.hide()

func _input(event):
	if event is InputEventMouseMotion:
		if state == SET_ANGLE:
			$Arrow.rotation.y -= event.relative.x / 150
	if event.is_action_pressed("click"):
		match state:
			SET_ANGLE:
				change_state(SET_POWER)
			SET_POWER:
				change_state(SHOOT)

func animate_power_bar(delta):
	power += power_speed * power_change * delta
	if power >= 100:
		power_change = -1
	if power <= 0:
		power_change = 1
	$UI.update_powerbar(power)

func animate_angle(delta):
	$Arrow.rotation.y += angle_speed * angle_change * delta
	if $Arrow.rotation.y > PI/2:
		angle_change = -1
	if $Arrow.rotation.y < -PI/2:
		angle_change = 1

func _on_Hole_body_entered(body):
	$AudioPut.play()
	$UI/Win.show()
	change_state(WIN)
	pass # Replace with function body.

func _on_Ball_stopped():
	if state == WIN:
		pass
	else:
		change_state(SET_ANGLE)
	pass # Replace with function body.
