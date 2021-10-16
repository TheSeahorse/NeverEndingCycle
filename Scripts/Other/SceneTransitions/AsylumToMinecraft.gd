extends Area2D


signal generate_god_seed


func _on_AsylumToMinecraft_body_entered(_body):
	emit_signal("generate_god_seed")
