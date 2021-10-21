extends KinematicBody2D

onready var path_follow = get_parent()

signal defeated
signal phase_two

var speed = 200
var health = 140


func _process(_delta):
	if health < 1:
		emit_signal("defeated")
		self.queue_free()


func _physics_process(delta):
	path_follow.set_offset(path_follow.get_offset() + speed * delta)


func _on_Hurtbox_area_entered(_area):
	health -= 1
	$Health.value = health
