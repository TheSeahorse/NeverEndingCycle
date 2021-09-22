extends Area2D



func get_next_dialog(_player: Node, _stats: Array) -> String:
	return "hobo_sell_egg"


func hobo_poof():
	$Sprite.hide()
	$SmokeSprite.show()
	$SmokeSprite.play("smoke")
	$SmokeTimer.start()


func _on_SmokeTimer_timeout():
	self.queue_free()
