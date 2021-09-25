extends Area2D



func _on_Fog_body_entered(body):
	$AnimatedSprite.play("fade_out")


func _on_Fog_body_exited(body):
	$AnimatedSprite.play("fade_in")
