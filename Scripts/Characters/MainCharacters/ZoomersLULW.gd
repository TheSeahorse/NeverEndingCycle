extends RigidBody2D


var level = null
var paused = true


func _physics_process(_delta):
	if paused:
		linear_velocity = Vector2.ZERO


func pause():
	paused = true


func resume():
	paused = false
	linear_velocity = Vector2(300,-150)


func set_level(node):
	level = node


func attach_rope(rope_piece: Object):
	$C/J.node_a = self.get_path()
	$C/J.node_b = rope_piece.get_path()


func _on_CollectibleDetector_area_entered(area):
	level.collect_collectible(area)


func _on_ZoomersLULW_body_exited(body):
	if body is Creeper:
		apply_central_impulse(self.linear_velocity*200)
		body.explode()
	elif body is Blaze:
		apply_central_impulse(self.linear_velocity*30)
	elif body is EnderDragon:
		apply_central_impulse(self.linear_velocity*10)
