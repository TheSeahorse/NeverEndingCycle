extends Area2D


func _ready():
	$Crown/Tween.interpolate_property($Crown, "position", null, Vector2(70, -370), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Crown/Tween.start()


func get_next_dialog(player: Node) -> String:
	if player.player_stats[1] > 9:
		if player.player_stats[2][3]:
			return "real_forsen_king"
		else:
			return "real_forsen_key"
	else:
		return "real_forsen_crown"


func equip_crown():
	$Crown.show()


func _on_Tween_tween_completed(_object, _key):
	if $Crown.position.x == 0:
		$Crown/Tween.interpolate_property($Crown, "position", null, Vector2(70, -370), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Crown/Tween.start()
	else:
		$Crown/Tween.interpolate_property($Crown, "position", null, Vector2(0, -370), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Crown/Tween.start()
