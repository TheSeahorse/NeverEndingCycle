extends Area2D


signal play_level


func _on_AsylumToBoshy_body_entered(_body):
	emit_signal("play_level")
