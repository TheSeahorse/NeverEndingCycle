extends StaticBody2D


export var type = "regular"


func get_next_dialog(_player: Node) -> String:
	if type == "regular":
		return "door_closed"
	else:
		return "exit_door_closed"
