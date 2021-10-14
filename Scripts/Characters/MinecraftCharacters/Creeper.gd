extends RigidBody2D
class_name Creeper


func explode():
	$Default.hide()
	$Explosion.show()
	gravity_scale = 0
	linear_velocity = Vector2.ZERO
	set_collision_layer(0)
	set_collision_mask(0)
	$ExplosionSound.play()
	$FreeTimer.start()


func _on_FreeTimer_timeout():
	self.queue_free()
