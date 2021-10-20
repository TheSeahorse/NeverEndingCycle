extends KinematicBody2D

signal defeated
signal phase_two

var health = 140


func _process(_delta):
	if health < 1:
		emit_signal("defeated")
		self.queue_free()


func _on_Hurtbox_area_entered(_area):
	health -= 1
	$Health.value = health
