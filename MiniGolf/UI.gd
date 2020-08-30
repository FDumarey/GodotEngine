extends CanvasLayer

var bar_red = preload("res://assets/bar_red.png")
var bar_green = preload("res://assets/bar_green.png")
var bar_yellow = preload("res://assets/bar_yellow.png")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_shots(value):
	$Margin/Container/Shots.text = 'Shots: %s' % value

func update_powerbar(value):
	$Margin/Container/PowerBar.texture_progress = bar_green
	if value > 40:
		$Margin/Container/PowerBar.texture_progress = bar_yellow
	if value > 70:
		$Margin/Container/PowerBar.texture_progress = bar_red
	$Margin/Container/PowerBar.value = value
