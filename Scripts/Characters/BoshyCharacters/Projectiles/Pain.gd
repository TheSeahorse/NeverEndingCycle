extends RigidBody2D


var velocity: Vector2


func _ready():
	velocity = self.linear_velocity


func _process(_delta):
	self.linear_velocity = velocity


func _on_DeathTimer_timeout():
	self.queue_free()
