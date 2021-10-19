extends Node2D

const MainMenu = preload("res://Scripts/Menues/MainMenu.tscn")
const Asylum = preload("res://Scripts/Levels/Asylum.tscn")
const JumpKing = preload("res://Scripts/Levels/JumpKing.tscn")
const MinecraftLevel = preload("res://Scripts/Levels/Minecraft/MinecraftLevel.tscn")
const BoshyLevel = preload("res://Scripts/Levels/BoshyMap.tscn")
const MinecraftCamera = preload("res://Scripts/Other/Cameras/MinecraftCamera.tscn")
const GodSeed = preload("res://Scripts/Other/Misc/GeneratingGodSeed.tscn")


var current_level
var player
var camera
var menu
var god_seed
var next_song = 0
var stopping_music = false

var stats = [0, 0, [false,false,false,false,false,false], false] #[Egs, given egs, unlocked_doors, beaten_record]


func _ready():
	$Music/SameThreeStones.play()
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
			stop_all_music()
			$Music/SameThreeStones.play()
		else:
			quit_game()


func generate_god_seed():
	stop_all_music()
	$Music/GeneratingGodSeed.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	free_old_level()
	god_seed = GodSeed.instance()
	call_deferred("add_child", god_seed)


func generated_dream_seed():
	if is_instance_valid(god_seed):
		god_seed.queue_free()
	play_level("minecraft", Vector2(900,-1000))


func play_level(level: String, spawn_pos: Vector2):
	if level != "minecraft":
		stop_all_music()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	free_old_level()
	match level:
		"jump_king":
			play_jump_king(spawn_pos)
		"asylum":
			play_asylum(spawn_pos)
		"minecraft":
			play_minecraft(spawn_pos)
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


func play_minecraft(spawn_pos: Vector2):
	current_level = MinecraftLevel.instance()
	call_deferred("add_child", current_level)
	player = load("res://Scripts/Characters/MainCharacters/ZoomersLULW.tscn").instance()
	player.set_position(spawn_pos)
	call_deferred("add_child", player)
	current_level.set_player(player)
	player.set_level(current_level)
	camera = MinecraftCamera.instance()
	call_deferred("add_child", camera)
	camera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	playlist_play_next(false)


func play_boshy(spawn_pos: Vector2):
	print("inside boshy")
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
		print("level freed")
		current_level.queue_free()
	if is_instance_valid(camera):
		print("camera freed")
		camera.queue_free()
	if is_instance_valid(player):
		print("player freed")
		player.queue_free()
	if is_instance_valid(menu):
		print("menu freed")
		menu.queue_free()


func stop_all_music():
	stopping_music = true
	for song in $Music.get_children():
		song.stop()
	for song in $MinecraftPlaylist.get_children():
		song.stop()


#false for within code, true for songs calling from their finished() signal
func playlist_play_next(finished: bool):
	if stopping_music and finished:
		return
	stopping_music = false
	$MinecraftPlaylist.get_children()[next_song].play()
	next_song += 1
	if next_song >= $MinecraftPlaylist.get_children().size():
		next_song = 0


func unlock_door(number: int):
	stats[2][number-1] = true


func beat_minecraft_record():
	stats[3] = true


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
