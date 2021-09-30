extends Node2D


func play_level(level: String, spawn_pos: Vector2):
	get_parent().play_level(level, spawn_pos)
