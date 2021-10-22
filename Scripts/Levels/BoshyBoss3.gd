extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	$Solgryn.play()
	$BigBoshy/Tween.interpolate_property($BigBoshy, "position", null, Vector2(960,1080), 15, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$BigBoshy/Tween.start()


func start_boss_fight():
	pass


func _on_Tween_tween_all_completed():
	$BigBoshy.hide()
	get_parent().start_boshy_fight()
