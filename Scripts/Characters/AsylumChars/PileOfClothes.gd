extends Area2D


func get_next_dialog(player: Node) -> String:
	if player.player_stats[2][1]:
		return "do_laundry"
	else:
		return "unlocked_door2"


