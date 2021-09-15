extends Camera2D


var player: Node


# Called when the node enters the scene tree for the first time.
func _ready():
	player = self.get_parent().get_children()[self.get_parent().get_children().find(self) - 1]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_position = Vector2(960,0)
	var screen: int = int(player.get_position().y - 1180) / int(1080)
	new_position.y = screen * 1080 + 540
	self.set_position(new_position)

