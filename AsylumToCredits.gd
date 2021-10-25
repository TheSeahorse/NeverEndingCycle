extends Area2D

signal play_credits

func _on_AsylumToCredits_body_entered(_body):
	emit_signal("play_credits")
