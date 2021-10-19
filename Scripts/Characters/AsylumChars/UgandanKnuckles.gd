extends Area2D


var open = false


func get_next_dialog(_player: Node) -> String:
	if open:
		return "wey_open"
	else:
		open = true
		return "i_know_da_wey"

