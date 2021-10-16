extends Camera2D


var player: Node


func _ready():
	player = self.get_parent().get_children()[self.get_parent().get_children().find(self) - 1]


func _process(_delta):
	var new_position = Vector2(960,0)
	var screen = int(player.get_position().y - 1180) / int(1080)
	var row = int(player.get_position().x / int(1900))
	if player.get_position().x < 0:
		row -= 1
	new_position.y = screen * 1080 + 540
	new_position.x = row * 1920 + 960
	self.set_position(new_position)

	if player.player_stats[0] > 0:
		$Egs.show()
		$Egs.text = "EGS: " + str(player.player_stats[0] - player.player_stats[1])

