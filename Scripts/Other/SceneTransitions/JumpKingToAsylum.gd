extends Area2D

signal play_asylum

func _on_JumpKingToAsylum_body_entered(_body):
	emit_signal("play_asylum")
