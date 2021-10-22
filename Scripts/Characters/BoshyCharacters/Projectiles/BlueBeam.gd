extends Area2D


func _ready():
	$SpriteTween.interpolate_property($Sprite, "scale", Vector2(1, 1), Vector2(1, 104), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$SpriteTween.start()


func _on_DeathTimer_timeout():
	self.queue_free()


func _on_SpriteTween_tween_all_completed():
	$CollisionShape2D.scale = Vector2(1,1)
