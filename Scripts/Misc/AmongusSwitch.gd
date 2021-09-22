extends Area2D


var player_y = 0


func _on_AmongusSwitch_body_entered(body):
	player_y = body.position.y



func _on_AmongusSwitch_body_exited(body):
	if abs(body.position.y-player_y) > 100:
		body.among_us_costume(not body.get_among_us_costume_visibility())
	else:
		pass
