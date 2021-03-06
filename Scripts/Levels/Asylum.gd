extends Node2D


const RealForsen = preload("res://Scripts/Characters/AsylumChars/RealForsenEnd.tscn")

func _ready():
	var stats = get_parent().get_stats()
	var unlocked_doors = stats[2]
	var door = 1
	for unlocked in unlocked_doors:
		if unlocked:
			unlock_door(door)
			if door == 3: #door 3 has a key
				get_node("Keys/DoorKey" + str(door)).queue_free()
		door += 1
	if stats[2][3]:
		$Interactables/RealForsen.equip_crown()
	if stats[3]:
		$CosmeticSprites/LidlBoardRecord.show()
		$CosmeticSprites/AlienDance.queue_free()
		$CosmeticSprites/AlienPls.queue_free()
		$Interactables/TelescopeLUL.queue_free()


func show_bitcoin(camera):
	$BitcoinMiner.show_miner()
	var new_position = camera.get_camera_screen_center()
	$BitcoinMiner.position = new_position
	get_tree().paused = true


func unlock_door(number: int):
	get_parent().unlock_door(number)
	get_node("Doors/AsylumDoor" + str(number)).queue_free()


func open_hidden_door(number: int):
	$Doors/DoorOpener.interpolate_property(get_node("Doors/HiddenDoor" + str(number)), "scale", null, Vector2(1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Doors/DoorOpener.start()


func _on_DoorOpener_completed(object, _key):
	object.queue_free()


func generate_god_seed():
	get_parent().generate_god_seed()


func play_level(level: String, spawn_pos: Vector2):
	get_parent().play_level(level, spawn_pos)


func spawn_real_forsen():
	$Interactables/RealForsen.queue_free()
	var real = RealForsen.instance()
	real.position = Vector2(3750, -2176)
	call_deferred("add_child", real)


func _on_AsylumToCredits_play_credits():
	get_parent().stats[5] = true
	get_parent().play_level("credits", Vector2.ZERO)
