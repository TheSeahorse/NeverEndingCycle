extends Node2D

const MainMenu = preload("res://Scripts/Menues/MainMenu.tscn")
const Asylum = preload("res://Scripts/Levels/Asylum.tscn")
const JumpKing = preload("res://Scripts/Levels/JumpKing.tscn")
const MinecraftLevel = preload("res://Scripts/Levels/Minecraft/MinecraftLevel.tscn")
const BoshyLevel = preload("res://Scripts/Levels/BoshyMap.tscn")

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
			$SameThreeStones.play()
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
		"minecraft":
			play_minecraft()
		"boshy":
			play_boshy(spawn_pos)


func play_asylum(spawn_pos: Vector2):
	current_level = Asylum.instance()
	call_deferred("add_child", current_level)
	player = load("res://Scripts/Characters/MainCharacters/Hero.tscn").instance()
	player.set_position(spawn_pos)
	call_deferred("add_child", player)
	camera = load("res://Scripts/Other/Cameras/AsylumCamera.tscn").instance()
	player.call_deferred("add_child", camera)
	camera.make_current()


func play_jump_king(spawn_pos: Vector2):
	current_level = JumpKing.instance()
	call_deferred("add_child", current_level)
	player = load("res://Scripts/Characters/MainCharacters/Clueless.tscn").instance()
	player.set_position(spawn_pos)
	call_deferred("add_child", player)
	camera = load("res://Scripts/Other/Cameras/JumpKingCamera.tscn").instance()
	call_deferred("add_child", camera)
	camera.make_current()


func play_minecraft():
	current_level = MinecraftLevel.instance()
	call_deferred("add_child", current_level)
	player = load("res://Scripts/Characters/MainCharacters/ZoomersLULW.tscn").instance()
	call_deferred("add_child", player)
	current_level.set_player(player)
	player.set_level(current_level)
	camera = load("res://Scripts/Other/Cameras/MinecraftCamera.tscn").instance()
	call_deferred("add_child", camera)
	camera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func play_boshy(spawn_pos: Vector2):
	current_level = BoshyLevel.instance()
	call_deferred("add_child", current_level)
	player = load("res://Scripts/Characters/MainCharacters/Boshy.tscn").instance()
	player.set_position(spawn_pos)
	call_deferred("add_child", player)
	camera = load("res://Scripts/Other/Cameras/BoshyCamera.tscn").instance()
	call_deferred("add_child", camera)
	camera.make_current()


func free_old_level():
	if is_instance_valid(current_level):
		current_level.queue_free()
	if is_instance_valid(camera):
		camera.queue_free()
	if is_instance_valid(player):
		player.queue_free()
	if is_instance_valid(menu):
		menu.queue_free()


func unlock_door(number: int):
	stats[2][number-1] = true


func add_stats(stat: int, amount: int):
	stats[stat] += amount


func reset_jump_king_stats():
	stats[0] = 0
	stats[1] = 0


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
