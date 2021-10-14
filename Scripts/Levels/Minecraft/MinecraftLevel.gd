extends Node2D

var Rope = preload("res://Scripts/Levels/Minecraft/Rope.tscn")
var Collectible = preload("res://Scripts/Other/Collectibles/MinecraftObjective.tscn")
var Villager = preload("res://Scripts/Characters/MinecraftCharacters/Villager.tscn")
var Horse = preload("res://Scripts/Characters/MinecraftCharacters/Horse.tscn")
var ZombiePiglin = preload("res://Scripts/Characters/MinecraftCharacters/ZombiePiglin.tscn")
var Piglin = preload("res://Scripts/Characters/MinecraftCharacters/Piglin.tscn")
var Creeper = preload("res://Scripts/Characters/MinecraftCharacters/Creeper.tscn")
var Zombie = preload("res://Scripts/Characters/MinecraftCharacters/Zombie.tscn")
var Blaze = preload("res://Scripts/Characters/MinecraftCharacters/Blaze.tscn")

var player # gets set from game

var rng = RandomNumberGenerator.new()
var phase = "field" #field, village, nether, bastion, fortress, night, stronghold, end
var game_over = false
var attached_rope = null
var ropes_spawned = 0
var level = 1


func _ready():
	update_tilemap()
	spawn_collectible(Vector2.ZERO)


func _process(delta):
	print($Enemies.get_children().size())


func _input(event):
	if game_over:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and !event.is_pressed():
			detach_rope()
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			if ropes_spawned < 2:
				spawn_rope()


func spawn_rope():
	ropes_spawned += 1
	var mouse_pos = get_global_mouse_position()
	var player_pos = player.position
	if game_over:
		return
	if player_pos.distance_to(mouse_pos) > 320:
		var angle = mouse_pos.angle_to_point(player_pos)
		mouse_pos = player_pos + Vector2(cos(angle) * 320, sin(angle) * 320)
	attached_rope = Rope.instance()
	if player_pos.distance_to(mouse_pos) < 60:
		var angle = mouse_pos.angle_to_point(player_pos)
		mouse_pos = player_pos + Vector2(cos(angle) * 60, sin(angle) * 60)
	add_child(attached_rope)
	attached_rope.spawn_rope(mouse_pos, player_pos, player)


#called from rope
func despawn_rope(rope: Node2D):
	ropes_spawned -= 1
	if rope == attached_rope:
		attached_rope = null
	remove_child(rope)
	rope.queue_free()


func detach_rope():
	if is_instance_valid(attached_rope):
		attached_rope.detach_rope()
		attached_rope = null
		give_player_boost()


func give_player_boost():
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


func spawn_collectible(prev_pos: Vector2):
	var collectible = Collectible.instance()
	var new_pos = prev_pos
	while abs(new_pos.x - prev_pos.x) < 200 and abs(new_pos.y - prev_pos.y) < 200:
		new_pos = Vector2(rng.randi_range(160, 1760) , rng.randi_range(-160, -920))
	call_deferred("add_child", collectible)
	collectible.set_position(new_pos)
	collectible.show_texture(level)


func collect_collectible(area: Area2D):
	var prev_pos = area.position
	remove_child(area)
	area.queue_free()
	level += 1
	update_background()
	update_tilemap()
	spawn_collectible(prev_pos)


func update_background():
	match level:
		3:
			phase = "village"
			delete_all_enemies()
			$Backgrounds/Village.show()
		9:
			phase = "field"
			delete_all_enemies()
			$Backgrounds/Field2.show()
		11:
			phase = "nether"
			delete_all_enemies()
			$Backgrounds/Nether.show()
		12:
			phase = "bastion"
			$EnemyTimer.wait_time = 2
			$EnemyTimer.start()
			delete_all_enemies()
			$Backgrounds/Bastion.show()
		17:
			$EnemyTimer.wait_time = 5
			$EnemyTimer.start()
			phase = "fortress"
			delete_all_enemies()
			$Backgrounds/Fortress.show()
		22:
			$EnemyTimer.wait_time = 3
			$EnemyTimer.start()
			phase = "night"
			delete_all_enemies()
			$Backgrounds/FieldNight.show()
		26:
			phase = "stronghold"
			delete_all_enemies()
			$Backgrounds/Stronghold.show()
		29:
			phase = "end"
			delete_all_enemies()
			$Backgrounds/TheEnd.show()
		_:
			pass



func update_tilemap():
	match level:
		1:
			change_tilemap_walls(2)
		11:
			change_tilemap_walls(3)
		22:
			change_tilemap_walls(2)
		26:
			change_tilemap_walls(1)
		29:
			change_tilemap_walls(4)
		_:
			pass


func change_tilemap_walls(texture: int):
	for y in range(-17,0):
		$MinecraftTilemap.set_cell(0, y, texture)
		$MinecraftTilemap.set_cell(29, y, texture)


func spawn_enemy():
	var enemy = decide_enemy()
	enemy.rotation_degrees = rng.randi_range(0, 360)
	if enemy.get_class() == "Blaze":
		enemy.position = Vector2(rng.randi_range(200, 1720), rng.randi_range(-200, -880))
	elif rng.randi() % 2 == 0:
		enemy.gravity_scale = -1
		enemy.position = Vector2(rng.randi_range(200, 1720), 160)
	else:
		enemy.gravity_scale = 1
		enemy.position = Vector2(rng.randi_range(200, 1720), -1240)
	get_node("Enemies").call_deferred("add_child", enemy)



func decide_enemy() -> RigidBody2D:
	match phase:
		"field":
			return Horse.instance()
		"village":
			return Villager.instance()
		"nether":
			return ZombiePiglin.instance()
		"bastion":
			if rng.randi() % 4 == 0:
				return ZombiePiglin.instance()
			else:
				return Piglin.instance()
		"fortress":
			return Blaze.instance()
		"night":
			return Zombie.instance()
		"stronghold":
			return Creeper.instance()
	return Villager.instance()


func delete_all_enemies():
	for enemy in $Enemies.get_children():
		enemy.queue_free()
