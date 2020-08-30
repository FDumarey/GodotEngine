extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.score == Global.highscore:
		$LineEdit.visible = true
		$Label2.visible = true
		$Button.visible = true
		$Timer.paused = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Timer_timeout():
	get_tree().change_scene(Global.start_screen)
	pass

func _on_Button_pressed():
	$AudioStreamPlayer2D.play()
	Global.highname = $LineEdit.text
	Global.save_score()
	get_tree().change_scene(Global.start_screen)
	pass # Replace with function body.
