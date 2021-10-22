extends Node2D


const AlienPlsFall = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/AlienPlsFall.tscn")

var rng: RandomNumberGenerator
var alien_fall_vel = Vector2(0,100)
var phase_two = false
var defeated = false


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	print("boshymap ready")


func _on_AlienFallTimer_timeout():
	if defeated:
		return
	var alien = AlienPlsFall.instance()
	if phase_two:
		var alien2 = AlienPlsFall.instance()
		alien.position = Vector2(352, -200)
		alien2.position = Vector2(960, -200)
		alien.linear_velocity = alien_fall_vel
		alien2.linear_velocity = alien_fall_vel
		$Enemies.call_deferred("add_child", alien)
		$Enemies.call_deferred("add_child", alien2)
		return
	if rng.randi() % 2 == 0:
		alien.position = Vector2(352, -200)
	else:
		alien.position = Vector2(960, -200)
	alien.linear_velocity = alien_fall_vel
	$Enemies.call_deferred("add_child", alien)


func spawn_alien(alien):
	$Enemies.call_deferred("add_child", alien)


#called from game when dialog is finished
func start_boss_fight():
	$Music.play()
	$AlienFallTimer.start()
	$Path2D/PathFollow2D/MegaLULBoss.start_boss_fight()


func phase_two_enabled():
	phase_two = true
	$AlienFallTimer.wait_time = 4
	alien_fall_vel = Vector2(0,200)


func boss_defeated():
	defeated = true
	$Music.stop()
	for child in $Enemies.get_children():
		child.call_deferred("queue_free")
	get_parent().get_player().boss_defeated(1)
	get_parent().beat_boshy_boss(1)

