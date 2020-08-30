extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreNotice.text = "High Score: " + str(Global.highscore) + "\nSpeler: " + Global.highname
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationPlayer.play("walk")
	$AnimationPlayer2.play("walk")
	pass

func _input(event):
	if event.is_action_pressed("ui_select"):
		Global.new_game()

