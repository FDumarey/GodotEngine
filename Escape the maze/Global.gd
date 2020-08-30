extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var levels = ['res://Levels/Level1.tscn', 'res://Levels/Level2.tscn']
var current_level
var start_screen = 'res://Levels/StartScreen.tscn'
var end_screen = 'res://Levels/EndScreen.tscn'
var score
var highscore = 0
var highname = "AAA"
var score_file = "user://highscore.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func new_game():
	current_level = -1
	next_level()
	score = 0

func game_over():
	if score > highscore:
		highscore = score
		save_score()
	get_tree().change_scene(end_screen)

func next_level():
	current_level += 1
	if current_level >= Global.levels.size():
		#no more levels to load
		game_over()
	else:
		get_tree().change_scene(levels[current_level])

func setup():
	var f = File.new()
	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		var loaded_data = {}
		loaded_data = f.get_var(true) # import a variant with the full object definition = dictionary
		highscore = int(loaded_data["score"])
		highname = loaded_data["name"]
		f.close()

func save_score():
	var _user_data = {} #prepare dictionary
	_user_data["score"] = str(highscore) # set dictionary keys with values
	_user_data["name"] = highname
	var f = File.new()
	f.open(score_file, File.WRITE)
	f.store_var(_user_data,true) # store a variant type with the full object description (true)
	f.close()
