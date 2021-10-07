extends Node2D

var Rope = preload("res://Scripts/Levels/Minecraft/Rope.tscn")
var player # gets set from game


var rng = RandomNumberGenerator.new()
var game_over = false
var current_rope = null
var can_spawn_rope = true


func _input(event):
	if game_over:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and !event.is_pressed():
			despawn_rope()
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			if can_spawn_rope:
				spawn_rope()


func spawn_rope():
	var mouse_pos = get_global_mouse_position()
	var player_pos = player.position
	if game_over:
		return
	if player_pos.distance_to(mouse_pos) > 320:
		var angle = mouse_pos.angle_to_point(player_pos)
		mouse_pos = player_pos + Vector2(cos(angle) * 320, sin(angle) * 320)
	current_rope = Rope.instance()
	if player_pos.distance_to(mouse_pos) < 60:
		var angle = mouse_pos.angle_to_point(player_pos)
		mouse_pos = player_pos + Vector2(cos(angle) * 60, sin(angle) * 60)
	add_child(current_rope)
	current_rope.spawn_rope(mouse_pos, player_pos, player)
	#start_rope_recharge_timer()


func despawn_rope():
	if current_rope != null:
		remove_child(current_rope)
		current_rope.free()
		current_rope = null
		give_player_boost()


func give_player_boost():
	if not is_instance_valid(player):
		return
	if game_over:
		return
	var max_boost = 4000
	var boost = Vector2(0,0)
	var velocity = player.linear_velocity
	boost = velocity*10
	if boost.x > max_boost:
		boost.x = max_boost
	if boost.y > max_boost:
		boost.y = max_boost
	player.apply_impulse(Vector2.ZERO, boost)


func set_player(p: RigidBody2D):
	player = p
