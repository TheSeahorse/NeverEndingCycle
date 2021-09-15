extends Node2D

const JumpKingIntro = preload("res://Scripts/Levels/JumpKingIntro.tscn")

var current_level
var player
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = JumpKingIntro.instance()
	player = load("res://Scripts/Characters/Player.tscn").instance()
	player.set_position(Vector2(100, -70))
	camera = load("res://Scripts/Camera.tscn").instance()
	add_child(current_level)
	add_child(player)
	add_child(camera)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
