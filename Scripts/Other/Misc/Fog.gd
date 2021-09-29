extends Area2D



func _on_Fog_body_entered(_body):
	$AnimatedSprite.play("fade_out")


func _on_Fog_body_exited(_body):
	$AnimatedSprite.play("fade_in")
