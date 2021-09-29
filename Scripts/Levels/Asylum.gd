extends Node2D


func _ready():
	var stats = get_parent().get_stats()
	var unlocked_doors = stats[2]
	var door = 1
	print(unlocked_doors)
	for unlocked in unlocked_doors:
		if unlocked:
			unlock_door(door)
			if door != 2: #door 2 has no key
				get_node("Keys/DoorKey" + str(door)).queue_free()
			else:
				$Interactables/PileOfClothes.found_key()
		door += 1



func show_bitcoin(camera):
	$BitcoinMiner.show_miner()
	var new_position = camera.get_camera_screen_center()
	$BitcoinMiner.position = new_position
	get_tree().paused = true


func unlock_door(number: int):
	get_parent().unlock_door(number)
	get_node("Doors/AsylumDoor" + str(number)).queue_free()
