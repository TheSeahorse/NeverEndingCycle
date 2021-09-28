extends Camera2D


func _process(delta):
	var offset = 40
	var player = get_parent()
	if player.position.y > -1024 - offset:
		limit_top = -1152
		limit_bottom = 0
	elif player.position.y > -2048 - offset:
		limit_top = -2176
		limit_bottom = -1024
	else:
		limit_top = -3200
		limit_bottom = -2048
