extends Area2D


func get_next_dialog(_player: Node) -> String:
	$Key.hide()
	$NoKey.show()
	$CollisionShape2D.disabled = true
	return "ugandan_key"
