extends RigidBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_LifeTimer_timeout():
	self.queue_free()


func _on_HitBox_area_entered(area):
	print("hit")
	self.queue_free()


func _on_HitBox_body_entered(body):
	print("hit")
	self.queue_free()
