extends Node2D

const JumpKingIntro = preload("res://Scripts/Levels/JumpKingIntro.tscn")

var current_level
var player
var camera

var stats = [0, 0] #[Egs, given egs]

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = JumpKingIntro.instance()
	player = load("res://Scripts/Characters/Player.tscn").instance()
	player.set_position(Vector2(1100, -8070))
	camera = load("res://Scripts/Camera.tscn").instance()
	add_child(current_level)
	add_child(player)
	add_child(camera)


func add_stats(stat: int, amount: int):
	stats[stat] += amount


func get_stats(stat: int) -> int:
	return stats[stat]

