extends RigidBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_LifeTimer_timeout():
	self.queue_free()


func _on_HitBox_area_entered(_area):
	self.queue_free()


func _on_HitBox_body_entered(_body):
	self.queue_free()
