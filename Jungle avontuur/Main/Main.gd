extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_num = str(GameState.current_level).pad_zeros(2)
	var path = 'res://Levels/Level%s.tscn' % level_num
	var map = load(path).instance()
	add_child(map)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
