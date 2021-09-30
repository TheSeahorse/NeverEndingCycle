extends Node2D

const MainMenu = preload("res://Scripts/Menues/MainMenu.tscn")
const Asylum = preload("res://Scripts/Levels/Asylum.tscn")
const JumpKing = preload("res://Scripts/Levels/JumpKing.tscn")

var current_level
var player
var camera
var menu

var stats = [0, 0, [false,false,false,false,false, false]] #[Egs, given egs, unlocked_doors]


func _ready():
	$SameThreeStones.play()
	menu = MainMenu.instance()
	add_child(menu)

func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("quit"):
		if is_instance_valid(player):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			free_old_level()
			menu = MainMenu.instance()
			add_child(menu)
		else:
			quit_game()


func play_level(level: String, spawn_pos: Vector2):
	$SameThreeStones.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	free_old_level()
	match level:
		"jump_king":
			play_jump_king(spawn_pos)
		"asylum":
			play_asylum(spawn_pos)


func free_old_level():
	if is_instance_valid(current_level):
		current_level.queue_free()
	if is_instance_valid(player):
		player.queue_free()
	if is_instance_valid(camera):
		camera.queue_free()
	if is_instance_valid(menu):
		menu.queue_free()


func play_asylum(spawn_pos: Vector2):
	current_level = Asylum.instance()
	player = load("res://Scripts/Characters/MainCharacters/Hero.tscn").instance()
	player.set_position(spawn_pos)
	camera = load("res://Scripts/Other/Cameras/AsylumCamera.tscn").instance()
	call_deferred("add_child", current_level)
	call_deferred("add_child", player)
	player.call_deferred("add_child", camera)
	camera.make_current()


func play_jump_king(spawn_pos: Vector2):
	current_level = JumpKing.instance()
	player = load("res://Scripts/Characters/MainCharacters/Clueless.tscn").instance()
	player.set_position(spawn_pos)
	camera = load("res://Scripts/Other/Cameras/JumpKingCamera.tscn").instance()
	call_deferred("add_child", current_level)
	call_deferred("add_child", player)
	call_deferred("add_child", camera)
	camera.make_current()


func unlock_door(number: int):
	stats[2][number-1] = true


func add_stats(stat: int, amount: int):
	stats[stat] += amount


func get_stats() -> int:
	return stats


func get_level() -> Node2D:
	if is_instance_valid(current_level):
		return current_level
	else:
		return null


func get_player() -> KinematicBody2D:
	if is_instance_valid(player):
		return player
	else:
		return null


func quit_game():
	get_tree().quit()
