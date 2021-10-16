extends Node


func _ready():
	$Camera2D.make_current()

func _on_GeneratingGodSeed_finished():
	get_parent().generated_dream_seed()
