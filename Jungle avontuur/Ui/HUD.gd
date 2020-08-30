extends MarginContainer

onready var life_counter = [$HBoxContainer/LifeCounter/L1, $HBoxContainer/LifeCounter/L2, $HBoxContainer/LifeCounter/L3, $HBoxContainer/LifeCounter/L4, $HBoxContainer/LifeCounter/L5]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Player_life_changed(value):
	for heart in range(life_counter.size()):
		life_counter[heart].visible = value > heart

func _on_score_changed(value):
	$Tween.interpolate_property($HBoxContainer/ScoreLabel, "rect_scale", $HBoxContainer/ScoreLabel.rect_scale, $HBoxContainer/ScoreLabel.rect_scale / 2 , 0.1, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	$Tween.start()
	$HBoxContainer/ScoreLabel.text = str(value)
	$Tween.interpolate_property($HBoxContainer/ScoreLabel, "rect_scale", $HBoxContainer/ScoreLabel.rect_scale / 2, $HBoxContainer/ScoreLabel.rect_scale , 0.1, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	$Tween.start()
