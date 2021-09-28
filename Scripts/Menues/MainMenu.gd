extends Node


func _ready():
	pass # Replace with function body.


func _on_Jump_King_pressed():
	get_parent().play_level("jump_king")


func _on_Overworld_pressed():
	get_parent().play_level("asylum")


func _on_Quit_pressed():
	get_parent().quit_game()
