extends Area2D
class_name Okayeg

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_next_dialog(player: Node, stats: Array) -> String:
	print("egs: " + str(stats[0]) + " given egs: " + str(stats[1]))
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

