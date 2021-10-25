extends Area2D


func get_next_dialog(player: Node) -> String:
	if player.player_stats[4][0]:
		return "megalul_dead"
	else:
		return "have_you_seen_megalul"
