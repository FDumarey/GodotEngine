extends Node2D

signal score_changed

onready var pickups = $Pickups
var score
var Collectible = preload("res://Collectibles/Collectible.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	emit_signal("score_changed", score)
	pickups.hide()
	$Player.start($PlayerSpawn.position)
	$Theme.play()
	set_camera_limits()
	spawn_pickups()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.cell_size
	$Player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x

func spawn_pickups():
	for cell in pickups.get_used_cells():
		var id = pickups.get_cellv(cell) #get unique id to the tile
		var type = pickups.tile_set.tile_get_name(id) #get the name of the tile in the tileset
		if type in ['gem', 'cherry']:
			var c = Collectible.instance()
			var pos = pickups.map_to_world(cell)
			c.init(type, pos + pickups.cell_size/2)
			add_child(c)
			c.connect('pickup', self, '_on_Collectible_pickup')

func _on_Collectible_pickup():
	score += 1
	$Pickup.play()
	emit_signal("score_changed", score)

func _on_Player_dead():
	$Theme.stop()
	GameState.restart()
	pass

func _on_Door_body_entered(body):
	$Theme.stop()
	GameState.next_level()
	pass # Replace with function body.

func _on_Ladder_body_entered(body):
	if body.name == "Player":
		body.is_on_ladder = true
	pass # Replace with function body.

func _on_Ladder_body_exited(body):
	if body.name == "Player":
		body.is_on_ladder = false
	pass # Replace with function body.
