extends Camera2D

var player
var sneaky_snitch = false

func _ready():
	player = get_parent()


func _process(_delta):
	if player.position.x < 3000 and player.position.y < -2048 and player.position.x > -1675:
		if !sneaky_snitch:
			$SneakySnitch.play()
			sneaky_snitch = true
	else:
		$SneakySnitch.stop()
		sneaky_snitch = false
	var offset = 40
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
	elif player.position.x < -1675:
		limit_left = -3648
		limit_right = -1664
		limit_top = -4480
		limit_bottom = -3392
	elif player.position.x < 3000:
		limit_left = -1792
		limit_right = 3072
		limit_top = -3968
		limit_bottom = -2048
	else:
		limit_left = 0
		limit_right = 6400
		limit_top = -3200
		limit_bottom = -2048
