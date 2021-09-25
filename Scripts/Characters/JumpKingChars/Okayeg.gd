extends Area2D
class_name Okayeg


func get_next_dialog(_player: Node, stats: Array) -> String:
	if stats[0] == 0:
		return "okayeg_no_eg"
	elif stats[0] > 0 and stats[0] < 10:
		if stats[1] == 0:
			return "okayeg_give_one_eg"
		else:
			return "okayeg_one_eg"
	elif stats[0] > 9:
		if stats[1] < 10:
			return "okayeg_give_nine_egs"
		else:
			return "okayeg_given_all_egs"
	else:
		return "okayeg_broken"


func remove_crown():
	$AnimatedSprite.play("no_crown")
