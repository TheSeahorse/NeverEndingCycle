extends RigidBody2D


var vel: Vector2


func _ready():
	vel = self.linear_velocity


func _physics_process(_delta):
	self.linear_velocity = vel


func _on_DeathTimer_timeout():
	self.queue_free()
