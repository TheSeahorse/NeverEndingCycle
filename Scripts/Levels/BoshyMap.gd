extends Node2D


func _ready():
	$Tween.interpolate_property($Sprite, "position", null, Vector2(-500, -1050), 30, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
