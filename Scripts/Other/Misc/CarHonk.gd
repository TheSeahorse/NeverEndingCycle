extends Area2D

func _on_CarHonk_body_entered(_body):
	$ProfCar.play()
