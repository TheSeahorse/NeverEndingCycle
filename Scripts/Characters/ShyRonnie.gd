extends Area2D

var played_intro = 0

func get_next_dialog(_player: Node, stats: Array) -> String:
	if played_intro < 2:
		played_intro += 1
		return "advice_intro"
	elif stats[1] == 0:
		return "advice_okayeg"
	elif stats[0] < 9:
		return "advice_god"
	elif stats[0] == 9:
		return "advice_hobo"
	else:
		return "advice_none"
