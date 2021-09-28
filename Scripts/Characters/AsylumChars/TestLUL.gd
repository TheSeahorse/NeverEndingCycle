extends AnimatedSprite

export var play: String
var show_text

func _ready():
	if play == "lulw":
		play("lulw")
		flip_h = true
		get_node(play).show()
		show_text = true
	elif play == "lule":
		play("lule")
		flip_h = false
		show_text = false



func _on_Timer_timeout():
	if show_text:
		get_node(play).hide()
		show_text = false
	else:
		get_node(play).show()
		show_text = true
