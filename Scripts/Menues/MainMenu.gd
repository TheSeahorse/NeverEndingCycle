extends Node


func _ready():
	pass # Replace with function body.


func _on_Jump_King_pressed():
	get_parent().play_level("jump_king", Vector2(100, -70))


func _on_Overworld_pressed():
	get_parent().play_level("asylum", Vector2(5800, -220))


func _on_Quit_pressed():
	get_parent().quit_game()