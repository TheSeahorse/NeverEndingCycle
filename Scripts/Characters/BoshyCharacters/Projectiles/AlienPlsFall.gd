extends RigidBody2D



func _on_DeathTimer_timeout():
	self.queue_free()
