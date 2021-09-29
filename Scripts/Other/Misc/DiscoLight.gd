extends Node2D


export var RAND_WAIT: float = 0.0
var rng


func _ready():
	$InitialRand.start(RAND_WAIT)


func set_seed():
	$ChangeColor.start()
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand1 = rng.randi() % 256
	var rand2 = rng.randi() % 256
	var rand3 = rng.randi() % 256
	var color = Color8(rand1, rand2, rand3)
	$Light2D.color = color



func _on_ChangeColor_timeout():
	var rand1 = rng.randi() % 256
	var rand2 = rng.randi() % 256
	var rand3 = rng.randi() % 256
	var new_color = Color8(rand1, rand2, rand3)
	$Tween.interpolate_property($Light2D, "color", null, new_color, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

