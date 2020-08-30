extends Node

var num_levels = 1
var current_level = 1

var game_scene = 'res://Main/Main.tscn'
var title_screen = 'res://Ui/Title.tscn'

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func restart():
	get_tree().change_scene(title_screen)

func next_level():
	current_level += 1
	if current_level <= num_levels:
		get_tree().reload_current_scene()
	else:
		current_level = 1
		get_tree().change_scene(title_screen)
