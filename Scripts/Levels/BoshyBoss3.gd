extends Node2D

const Solgryn = preload("res://Scripts/Characters/BoshyCharacters/Bosses/Solgryn.tscn")
const BlueBeam = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/BlueBeam.tscn")

var big_boshy_first = true
var defeated = false
var solgryn
var player
var beams_spawned = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Solgryn.play()
	$BigBoshy/Tween.interpolate_property($BigBoshy, "position", null, Vector2(960,810), 5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$BigBoshy/Tween.start()


func _on_Tween_tween_all_completed():
	if big_boshy_first:
		big_boshy_first = false
		$BigBoshy/Tween.interpolate_property($BigBoshy, "position", null, Vector2(960,-900), 2, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		$BigBoshy/Tween.start()
	else:
		$BigBoshy.hide()
		get_parent().start_boshy_fight()


func start_boss_fight():
	player = get_parent().get_player()
	summon_solgryn()
	solgryn.start_boss_fight()


func summon_solgryn():
	solgryn = Solgryn.instance()
	solgryn.connect("defeated", self, "solgryn_defeated")
	solgryn.connect("spawn_projectile", self, "spawn_projectile")
	solgryn.connect("get_player", self, "give_solgryn_player")
	solgryn.connect("spawn_blue_beams", self, "spawn_blue_beams")
	solgryn.connect("single_ball_spawned", self, "top_path_start")
	$StartPath/PathFollow2D.call_deferred("add_child", solgryn)
	solgryn.set_path($StartPath/PathFollow2D)


func top_path_start():
	$StartPath/PathFollow2D.remove_child(solgryn)
	$TopPath/PathFollow2D.call_deferred("add_child", solgryn)
	solgryn.set_path($TopPath/PathFollow2D)
	solgryn.start_on_top()
	$HorsePath/PathFollow2D/Horse.start()


func solgryn_defeated():
	defeated = true
	$Solgryn.stop()
	for child in $Projectiles.get_children():
		child.call_deferred("queue_free")
	get_parent().get_player().boss_defeated(3)
	get_parent().beat_boshy_boss(3)


func spawn_projectile(projectile):
	if !defeated:
		$Projectiles.call_deferred("add_child", projectile)


func spawn_blue_beams():
	$BeamTimer.start()
	spawn_beam()


func give_solgryn_player():
	solgryn.return_player(player)


func spawn_beam():
	if beams_spawned > 2 or defeated:
		solgryn.shoot_green_single()
		return
	else:
		var beam = BlueBeam.instance()
		beam.position = Vector2(player.position.x, 0)
		$Projectiles.call_deferred("add_child", beam)
		beams_spawned += 1
		if beams_spawned == 2:
			$BeamTimer.start(0.7)
		else:
			$BeamTimer.start()
