extends RigidBody2D
class_name EnderDragon


var first = true
var dead = false


func _physics_process(_delta):
	if dead:
		linear_velocity = Vector2.ZERO
	elif linear_velocity.x < 0:
		$Sprite.flip_h = false
		$CollisionPolygon2D.scale = Vector2(1,1)
	else:
		$Sprite.flip_h = true
		$CollisionPolygon2D.scale = Vector2(-1,1)


func _on_GravityTimer_timeout():
	gravity_scale = gravity_scale * -1
	if first:
		$GravityTimer.wait_time = 2
		$GravityTimer.start()
		first = false


func _on_BoostTimer_timeout():
	if linear_velocity.x < 0:
		apply_impulse(Vector2.ZERO, Vector2(-500000, 0))
	else:
		apply_impulse(Vector2.ZERO, Vector2(500000, 0))


func die():
	dead = true
	$Sprite.hide()
	$Death.show()
	$Death.play("death")


func _on_Death_animation_finished():
	get_parent().get_parent().dragon_dead()


func get_class(): return "EnderDragon"



