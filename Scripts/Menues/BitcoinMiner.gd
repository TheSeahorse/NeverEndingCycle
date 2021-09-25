extends Node2D


func show_miner():
	self.show()

	$Timer.start()


func _on_TextureButton_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	self.queue_free()


func _on_Timer_timeout():
	$notification.play()
	$Sprite.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
