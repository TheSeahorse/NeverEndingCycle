extends Node


func _on_Jump_King_pressed():
	get_parent().play_level("jump_king", Vector2(100, -70))


func _on_Overworld_pressed():
	get_parent().stop_all_music()
	$IntroCredits.show()
	$IntroCredits/FadeIn.interpolate_property($IntroCredits, "modulate", Color(1,1,1,0), Color(1,1,1,1),1,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$IntroCredits/FadeIn.start()


func _on_FadeIn_tween_all_completed():
	$ColorRect.show()
	$Menu.hide()
	$Background.hide()
	$IntroCredits/Timer.start()


func _on_Timer_timeout():
	$IntroCredits/FadeOut.interpolate_property($IntroCredits, "modulate", null, Color(1,1,1,0),2,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$IntroCredits/FadeOut.start()


func _on_FadeOut_tween_all_completed():
	get_parent().play_level("asylum", Vector2(6000, -220))


func _on_Settings_pressed():
	$Menu.hide()
	$Settings.show()


func _on_Quit_pressed():
	get_parent().quit_game()


func _on_Boshy_pressed():
	get_parent().play_level("boshy", Vector2.ZERO)


func _on_Minecraft_pressed():
	get_parent().generate_god_seed()


func _on_Credits_pressed():
	get_parent().play_level("credits", Vector2.ZERO)


func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	ProjectSettings.set_setting("display/window/size/fullscreen", button_pressed)


func _on_Borderless_toggled(button_pressed):
	OS.window_borderless = button_pressed
	ProjectSettings.set_setting("display/window/size/borderless", button_pressed)


func _on_BackMenu_pressed():
	$Settings.hide()
	$Menu.show()


func _on_DeleteSave_pressed():
	get_parent().delete_save()
