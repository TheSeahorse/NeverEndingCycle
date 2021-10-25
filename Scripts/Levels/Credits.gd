extends Node2D

var player
var playing = false

func _process(_delta):
	if player.player_stats[5] and !playing:
		$Completed.show()
		$HaruYoKoi.play()
		playing = true

func _ready():
	$Tween.interpolate_property($CreditsText, "rect_position", null, Vector2(11, -5800), 200, Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$Tween.start()


func set_player(p):
	player = p


