extends Area2D


func _on_BitcoinConnector_body_entered(body):
	get_parent().show_bitcoin(body.get_children()[body.get_children().size()-1])
	self.queue_free()
