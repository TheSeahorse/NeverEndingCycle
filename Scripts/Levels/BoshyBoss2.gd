extends Node2D

const Rope = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/BurningRope.tscn")

var rope_vel = Vector2(250,0)
var rope_base_wait = 8
var rng: RandomNumberGenerator
var defeated = false


func _ready():
	get_parent().start_boshy_fight()
	rng = RandomNumberGenerator.new()
	rng.randomize()


func start_boss_fight():
	$Scamaz.play()
	$RopeTimer.start()
	$AmazPath/PathFollow2D/AmazBoss.start_boss_fight()


func spawn_rope():
	if defeated:
		return
	var rope = Rope.instance()
	rope.position = Vector2(-300,545)
	rope.linear_velocity = rope_vel
	$Projectiles.call_deferred("add_child", rope)


func boss_defeated():
	defeated = true
	$Scamaz.stop()
	for child in $Projectiles.get_children():
		child.call_deferred("queue_free")
	get_parent().get_player().boss_defeated(2)
	get_parent().beat_boshy_boss(2)


func _on_RopeTimer_timeout():
	spawn_rope()
	$RopeTimer.wait_time = rope_base_wait + rng.randf_range(0.0,rope_base_wait/2)
	$RopeTimer.start()


func _on_AmazBoss_get_player():
	$AmazPath/PathFollow2D/AmazBoss.return_player(get_parent().get_player())


func _on_AmazBoss_spawn_projectile(projectile):
	$Projectiles.call_deferred("add_child", projectile)


func _on_AmazBoss_phase_two():
	rope_base_wait = 6
