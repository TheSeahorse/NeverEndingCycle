extends Node2D

const JumpKingIntro = preload("res://Scripts/Levels/JumpKingLevel.tscn")
const Overworld = preload("res://Scripts/Levels/Overworld.tscn")

var current_level
var player
var camera

var stats = [0, 0] #[Egs, given egs]

# Called when the node enters the scene tree for the first time.
func _ready():
	if true:
		current_level = Overworld.instance()
		player = load("res://Scripts/MainCharacters/Hero.tscn").instance()
		player.set_position(Vector2(100, -64))
		camera = load("res://Scripts/Cameras/OverworldCamera.tscn").instance()
		add_child(current_level)
		add_child(player)
		player.add_child(camera)
	else:
		current_level = JumpKingIntro.instance()
		player = load("res://Scripts/MainCharacters/Clueless.tscn").instance()
		player.set_position(Vector2(100, -70))
		camera = load("res://Scripts/Cameras/JumpKingCamera.tscn").instance()
		add_child(current_level)
		add_child(player)
		add_child(camera)
	camera.make_current()


func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()


func add_stats(stat: int, amount: int):
	stats[stat] += amount


func get_stats(stat: int) -> int:
	return stats[stat]

