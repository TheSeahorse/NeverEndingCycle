extends Area2D


var key_found = false


func found_key():
	key_found = true


func get_next_dialog(_player: Node) -> String:
	if key_found:
		return "do_laundry"
	else:
		key_found = true
		return "unlocked_door2"


