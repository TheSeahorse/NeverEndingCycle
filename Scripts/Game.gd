extends Node2D

const MainMenu = preload("res://Scripts/Menues/MainMenu.tscn")

var current_level
var player
var camera
var menu

var stats = [0, 0] #[Egs, given egs]


func _ready():
	#$SameThreeStones.play()
	menu = MainMenu.instance()
	add_child(menu)

func _process(_delta):
	print(menu)

func _input(event):
	if event.is_action_pressed("quit"):
		if is_instance_valid(player):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			free_old_level()
			menu = MainMenu.instance()
			add_child(menu)
		else:
			quit_game()


func play_level(level: String):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	free_old_level()
	match level:
		"jump_king":
			play_jump_king()
		"overworld":
			play_overworld()


func free_old_level():
	if is_instance_valid(current_level):
		current_level.queue_free()
	if is_instance_valid(player):
		player.queue_free()
	if is_instance_valid(camera):
		camera.queue_free()
	if is_instance_valid(menu):
		menu.queue_free()


func play_overworld():
	current_level = load("res://Scripts/Levels/Assylum.tscn").instance()
	player = load("res://Scripts/Characters/MainCharacters/Hero.tscn").instance()
	player.set_position(Vector2(5800, -220))
	camera = load("res://Scripts/Other/Cameras/AssylumCamera.tscn").instance()
	add_child(current_level)
	add_child(player)
	player.add_child(camera)
	camera.make_current()


func play_jump_king():
	current_level = load("res://Scripts/Levels/JumpKing.tscn").instance()
	player = load("res://Scripts/Characters/MainCharacters/Clueless.tscn").instance()
	player.set_position(Vector2(100, -70))
	camera = load("res://Scripts/Other/Cameras/JumpKingCamera.tscn").instance()
	add_child(current_level)
	add_child(player)
	add_child(camera)
	camera.make_current()



func add_stats(stat: int, amount: int):
	stats[stat] += amount


func get_stats(stat: int) -> int:
	return stats[stat]


func quit_game():
	get_tree().quit()
