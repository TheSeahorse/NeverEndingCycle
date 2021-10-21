extends Area2D


func get_next_dialog(player: Node) -> String:
	if player.player_stats[3]:
		return "you_mad"
	else:
		return "maze_intro"
