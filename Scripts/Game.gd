extends Node2D

const MainMenu = preload("res://Scripts/Menues/MainMenu.tscn")
const Asylum = preload("res://Scripts/Levels/Asylum.tscn")
const Credits = preload("res://Scripts/Levels/Credits.tscn")
const JumpKing = preload("res://Scripts/Levels/JumpKing.tscn")
const MinecraftLevel = preload("res://Scripts/Levels/Minecraft/MinecraftLevel.tscn")
const BoshyBoss1 = preload("res://Scripts/Levels/BoshyBoss1.tscn")
const BoshyBoss2 = preload("res://Scripts/Levels/BoshyBoss2.tscn")
const BoshyBoss3 = preload("res://Scripts/Levels/BoshyBoss3.tscn")
const MinecraftCamera = preload("res://Scripts/Other/Cameras/MinecraftCamera.tscn")
const GodSeed = preload("res://Scripts/Other/Misc/GeneratingGodSeed.tscn")


var current_level
var player
var camera
var menu
var god_seed
var next_song = 0
var stopping_music = false

#[Egs, given egs, unlocked_doors, beaten_minecraft_record, beaten_boshy_bosses, beat_game, solgryn_intro]
var stats


func _ready():
	load_game()
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
			play_boshy()
		"credits":
			play_credits()


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


func play_credits():
	current_level = Credits.instance()
	call_deferred("add_child", current_level)
	player = load("res://Scripts/Characters/MainCharacters/Hero.tscn").instance()
	player.set_position(Vector2(1600, 1000))
	call_deferred("add_child", player)
	current_level.set_player(player)
	camera = load("res://Scripts/Other/Cameras/BoshyCamera.tscn").instance()
	call_deferred("add_child", camera)
	camera.make_current()


func play_boshy():
	if !stats[4][0]:
		current_level = BoshyBoss1.instance()
	elif !stats[4][1]:
		current_level = BoshyBoss2.instance()
	else:
		current_level = BoshyBoss3.instance()
	call_deferred("add_child", current_level)
	player = load("res://Scripts/Characters/MainCharacters/Boshy.tscn").instance()
	if !stats[4][0]:
		player.set_position(Vector2(64,900))
	elif !stats[4][1]:
		player.set_position(Vector2(960, 760))
	else:
		player.set_position(Vector2(960, 800))
	player.connect("dead", self, "boshy_died")
	call_deferred("add_child", player)
	camera = load("res://Scripts/Other/Cameras/BoshyCamera.tscn").instance()
	call_deferred("add_child", camera)
	camera.make_current()


func add_bullet(bullet: RigidBody2D):
	if $Bullets.get_children().size() < 5:
		player.play_sound("Shoot")
		$Bullets.call_deferred("add_child", bullet)


func start_boshy_fight():
	player.start_boss_fight()
	current_level.start_boss_fight()


func boshy_died():
	play_level("boshy", Vector2(64,800))


func free_old_level():
	if is_instance_valid(current_level):
		current_level.queue_free()
	if is_instance_valid(camera):
		camera.queue_free()
	if is_instance_valid(player):
		player.queue_free()
	if is_instance_valid(menu):
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
	save_game()


func beat_minecraft_record():
	stats[3] = true
	save_game()


func beat_boshy_boss(number: int):
	stats[4][number-1] = true
	save_game()


func add_stats(stat: int, amount: int):
	stats[stat] += amount
	save_game()


func reset_jump_king_stats():
	stats[0] = 0
	stats[1] = 0
	save_game()


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


#[Egs, given egs, unlocked_doors, beaten_minecraft_record, beaten_boshy_bosses, beat_game]
func save_game():
	var save_data = {
		"egs" : stats[0],
		"given_egs" : stats[1],
		"unlocked_doors" : stats[2],
		"beat_minecraft" : stats[3],
		"beaten_boshy_bosses" : stats[4],
		"beat_game" : stats[5],
		"solgryn_intro": stats[6]
	}
	var save_game = File.new()
	save_game.open("user://never_ending_cycle.save", File.WRITE)
	save_game.store_line(to_json(save_data))
	save_game.close()


func load_game():
	var load_game = File.new()
	if not load_game.file_exists("user://never_ending_cycle.save"):
		stats = [0, 0, [false,false,false,false,false,false], false, [false,false,false], false, false]
	else:
		load_game.open("user://never_ending_cycle.save", File.READ)
		var save_state = parse_json(load_game.get_line())
		load_game.close()
		stats = [save_state.egs,save_state.given_egs,save_state.unlocked_doors,save_state.beat_minecraft,save_state.beaten_boshy_bosses,save_state.beat_game, save_state.solgryn_intro]


func delete_save():
	stats = [0, 0, [false,false,false,false,false,false], false, [false,false,false], false, false]
	save_game()


func quit_game():
	save_game()
	get_tree().quit()
