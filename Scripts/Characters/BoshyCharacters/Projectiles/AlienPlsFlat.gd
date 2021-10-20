extends RigidBody2D


var speed: Vector2


func _ready():
	speed = linear_velocity

func _physics_process(_delta):
	linear_velocity = speed

func _on_DeathTimer_timeout():
	self.queue_free()
