extends Node2D


const AlienPlsFall = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/AlienPlsFall.tscn")

var rng: RandomNumberGenerator
var alien_fall_vel = Vector2(0,100)


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	print("boshymap ready")


func _on_AlienFallTimer_timeout():
	var alien = AlienPlsFall.instance()
	if rng.randi() % 2 == 0:
		alien.position = Vector2(352, -200)
	else:
		alien.position = Vector2(960, -200)
	alien.linear_velocity = alien_fall_vel
	call_deferred("add_child", alien)


#called from game when dialog is finished
func start_boss_fight():
	$AlienFallTimer.start()
	$MegaLULBoss.start_boss_fight()


func phase_two_enabled():
	$AlienFallTimer.wait_time = 4
	alien_fall_vel = Vector2(0,200)


func _on_DeathZone_entered():
	pass # Replace with function body.
