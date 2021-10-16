extends Area2D


func get_next_dialog(player: Node) -> String:
	if player.player_stats[3]:
		return "minecraft_record"
	else:
		return "minecraft_dream"
