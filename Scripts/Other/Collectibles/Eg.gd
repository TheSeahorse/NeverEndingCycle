extends Area2D
class_name Eg


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func collected():
	self.queue_free()
