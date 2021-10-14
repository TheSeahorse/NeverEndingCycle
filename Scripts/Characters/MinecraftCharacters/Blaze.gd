extends RigidBody2D
class_name Blaze

var first = true

func _on_TurnGravity_timeout():
	gravity_scale =  gravity_scale * -1
	if first:
		$TurnGravity.wait_time = 1
		$TurnGravity.start()
		first = false


func get_class(): return "Blaze"
