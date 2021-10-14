extends Area2D


func _on_EnemyDeleter_body_entered(body):
	body.queue_free()
