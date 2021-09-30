extends Area2D

signal play_asylum


func _on_JumpKingToAsylum_body_entered(body):
	body.PLAYER_STATE = 0
	var dialog
	if body.player_stats[1] > 9:
		dialog = Dialogic.start("want_to_leave")
	else:
		dialog = Dialogic.start("warning_to_leave")
	add_child(dialog)
	dialog.connect("timeline_end", self, "dialog_ended", [dialog, body])
	dialog.connect("dialogic_signal", self, "dialog_answer")


func dialog_ended(_timeline_name, dialog, body):
	body.PLAYER_STATE = 1
	dialog.queue_free()



func dialog_answer(_answer):
	emit_signal("play_asylum")
