extends Camera2D


func _process(_delta):
	var offset = 40
	var player = get_parent()
	if player.position.y > -1024 - offset:
		limit_left = 0
		limit_right = 6400
		limit_top = -1152
		limit_bottom = 0
	elif player.position.y > -2048 - offset:
		limit_left = 0
		limit_right = 6400
		limit_top = -2176
		limit_bottom = -1024
	elif player.position.x < 2944:
		limit_left = -1792
		limit_right = 3072
		limit_top = -3968
		limit_bottom = -2048
	else:
		limit_left = 0
		limit_right = 6400
		limit_top = -3200
		limit_bottom = -2048
