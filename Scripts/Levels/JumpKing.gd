extends Node2D


func _ready():
	var egs_collected = get_parent().stats[0] + get_parent().stats[1]
	if egs_collected == 0:
		return
	elif egs_collected > 10:
		egs_collected = 10
	for i in range(1,egs_collected+1):
		if i == 7:
			$Hobo.queue_free()
		else:
			get_node("Eg" + str(i)).queue_free()



func play_level(level: String, spawn_pos: Vector2):
	get_parent().play_level(level, spawn_pos)


func reset_stats():
	get_parent().reset_jump_king_stats()

