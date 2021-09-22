extends Area2D

var saved_player = null
var self_started = false


func get_next_dialog(player: Node, _stats: Array) -> String:
	if self_started:
		return "copesen_its_ironic"
	else:
		saved_player = player
		self_started = true
		$Timer.start()
		return "copesen_its_ironic"


func copesen_free():
	self.queue_free()


func _on_Timer_timeout():
	saved_player.play_dialog()
