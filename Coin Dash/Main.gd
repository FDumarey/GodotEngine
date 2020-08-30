extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var Coin
export (PackedScene) var Powerup
export (int) var playtime

var level
var score
var time_left
var screensize
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$PowerupTimer.wait_time = rand_range(5, 10)
		$PowerupTimer.start()
	pass

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	$CactusTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func spawn_coins():
	$LevelSound.play()
	for i in range(4 + level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()
	pass # Replace with function body.

func _on_Player_pickup(type):
	match type:
		"coin":
			score += 1
			$CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$PowerupSound.play()
			$HUD.update_timer(time_left)
	pass # Replace with function body.

func _on_Player_hurt():
	game_over()
	pass # Replace with function body.

func game_over():
	playing = false
	$EndSound.play()
	$GameTimer.stop()
	$CactusTimer.stop()
	$Cactus.position = Vector2(250, 220)
	$PowerupTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()

func _on_PowerupTimer_timeout():
	var p = Powerup.instance()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
	pass # Replace with function body.

func _on_CactusTimer_timeout():
	$Cactus.position = Vector2(rand_range(40, screensize.x-40), rand_range(50, screensize.y-50))
	$CactusTimer.start()
	pass # Replace with function body.
