extends StaticBody2D


export var type = "regular"


func get_next_dialog(player: Node) -> String:
	if type == "regular":
		return "door_closed"
	else:
		if player.player_stats[2][5]:
			return "break_free"
		else:
			return "exit_door_closed"
