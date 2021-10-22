extends KinematicBody2D


onready var path_follow = get_parent()

var speed = 1000
var go = false

func _physics_process(delta):
	if go:
		path_follow.set_offset(path_follow.get_offset() + speed * delta)


func start():
	go = true
