extends Area2D

func get_next_dialog(player: Node) -> String:
	if player.player_stats[3] and !player.player_stats[2][0]:
		return "unlocked_door1"
	else:
		return "game_for_ants"
