extends RigidBody

signal stopped

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func shoot(angle, power):
	var force = Vector3(0,0,-1).rotated(Vector3(0,1,0), angle)
	apply_impulse(Vector3(), force * power / 5)
	
func _integrate_forces(state):
	if state.linear_velocity.length() < 0.1:
		state.linear_velocity = Vector3()
		state.angular_velocity = Vector3()
		emit_signal("stopped")
