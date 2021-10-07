extends RigidBody2D



func _ready():
	position = Vector2(900, -1000)


func attach_rope(rope_piece: Object):
	$C/J.node_a = self.get_path()
	$C/J.node_b = rope_piece.get_path()


