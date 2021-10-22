extends RigidBody2D


var player: KinematicBody2D
var speed = 0
var fixed_velocity = Vector2.ZERO
var chasing = true


func _ready():
	$SpriteTween.interpolate_property($Sprite, "scale", null, Vector2(1, 1), $ChaseTimer.wait_time, Tween.TRANS_LINEAR)
	$SpriteTween.start()
	$CollisionTween.interpolate_property($CollisionShape2D, "scale", null, Vector2(1, 1), $ChaseTimer.wait_time, Tween.TRANS_LINEAR)
	$CollisionTween.start()

func _physics_process(_delta):
	if chasing:
		var global_position = self.position + get_parent().position
		var direction = global_position.direction_to(player.position)
		self.linear_velocity = direction * speed
	else:
		self.linear_velocity = fixed_velocity


func _on_DeathTimer_timeout():
	self.queue_free()


func _on_ChaseTimer_timeout():
	chasing = false
	fixed_velocity = self.linear_velocity
