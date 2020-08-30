extends Node2D

export (PackedScene) var Rock
export (PackedScene) var Enemy
var screensize = Vector2()
var level = 0
var score = 0
var playing = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not playing:
		return
	if $Rocks.get_child_count() == 0:
		new_level()
	pass

func _on_Player_shoot(bullet, pos, dir):
	var b = bullet.instance()
	b.start(pos, dir)
	add_child(b)
	pass # Replace with function body.

func spawn_rock(size, pos=null, vel=null):
	if !pos:
		$RockPath/RockSpawn.set_offset(randi())
		pos=$RockPath/RockSpawn.position
	if !vel:
		vel = Vector2(1,0).rotated(rand_range(0, 2*PI)) * rand_range(100, 150)
	var r = Rock.instance()
	r.screensize = screensize
	r.start(pos, vel, size)
	#$Rocks.add_child (r)
	$Rocks.call_deferred("add_child", r)
	r.connect('exploded', self, '_on_Rock_exploded')
	
func _on_Rock_exploded(size, radius, pos, vel):
	$ExplodeSound.play()
	score += 10
	$HUD.update_score(score)
	if size <= 1:
		return
	for offset in [-1,1]: #do twice
		var dir = (pos - $Player.position).normalized().tangent()*offset #normalized 90° to direction of Player
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1
		spawn_rock(size-1, newpos, newvel)

func new_game():
	$Music.play()
	for rock in $Rocks.get_children():
		rock.queue_free()
	level = 0
	score = 0
	$HUD.update_score(score)
	$Player.start()
	new_level()
	$HUD.show_message("Get Ready")
	yield($HUD/MessageTimer, "timeout")
	$HUD/TweenLabel.interpolate_property($HUD/LblCopyright, "margin_top", -14, 0, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$HUD/TweenLabel.start()
	playing = true

func new_level():
	$LevelUpSound.play()
	$EnemyTimer.wait_time = rand_range(5,10)
	$EnemyTimer.start()
	level += 1
	$HUD.show_message("Wave %s" % level)
	for i in range(level):
		spawn_rock(3)

func game_over():
	$Music.stop()
	playing = false
	$HUD.game_over()

func _input(event):
	if event.is_action_pressed("pause"):
		if not playing:
			return
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			$HUD/MessageLabel.text = "Paused"
			$HUD/MessageLabel.show()
		else:
			$HUD/MessageLabel.text = ""
			$HUD/MessageLabel.hide()

func _on_EnemyTimer_timeout():
	var e = Enemy.instance()
	add_child(e)
	e.target = $Player
	e.connect('shoot', self, '_on_Player_shoot')
	e.connect('killed', self, '_on_Enemy_killed')
	$EnemyTimer.wait_time = rand_range(20,40)
	$EnemyTimer.start()
	pass # Replace with function body.

func _on_Enemy_killed(value):
	score += value
	$HUD.update_score(score)
