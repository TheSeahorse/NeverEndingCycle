extends Node2D


func show_bitcoin(camera):
	$BitcoinMiner.show_miner()
	print(get_viewport().get_camera())
	var new_position = camera.get_camera_position()
	$BitcoinMiner.position = new_position
	get_tree().paused = true
