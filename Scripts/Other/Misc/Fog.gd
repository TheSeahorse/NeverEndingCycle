extends Area2D



func _on_Fog_body_entered(_body):
	$Fader.interpolate_property($Fog, "modulate", null, Color(1,1,1,0),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Fader.start()


func _on_Fog_body_exited(_body):
	$Fader.interpolate_property($Fog, "modulate", null, Color(1,1,1,1),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Fader.start()
