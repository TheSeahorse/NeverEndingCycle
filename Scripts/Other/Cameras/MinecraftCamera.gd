extends Camera2D

var start_time

func _ready():
	start_time = OS.get_ticks_msec()


func _process(_delta):
	var time = (OS.get_ticks_msec() - start_time) * 2
	var hundreds = int(time/10 % 100)
	var seconds = int(time/1000 % 60)
	var minutes = int(time/60000)
	if hundreds < 10:
		hundreds = "0" + str(hundreds)
	else:
		hundreds = str(hundreds)
	if seconds < 10:
		seconds = "0" + str(seconds)
	else:
		seconds = str(seconds)
	if minutes < 10:
		minutes = "0" + str(minutes)
	else:
		minutes = str(minutes)

	$Node2D/Label.text = minutes + ":" + seconds + "." + hundreds
