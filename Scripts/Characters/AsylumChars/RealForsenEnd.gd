extends Area2D
class_name RealForsenEnd




func _on_RealForsenEnd_body_entered(_body):
	$CollisionShape2D.call_deferred("set_disabled", true)
