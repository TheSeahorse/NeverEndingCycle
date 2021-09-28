extends Node2D


func show_bitcoin(camera):
	$BitcoinMiner.show_miner()
	var new_position = camera.get_camera_screen_center()
	$BitcoinMiner.position = new_position
	get_tree().paused = true
