extends KinematicBody2D

const WhiteBall = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/WhiteBall.tscn")
const GreenBall = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/GreenBall.tscn")

#signal defeated
signal get_player
signal spawn_projectile
signal spawn_blue_beams
signal single_ball_spawned

var player: KinematicBody2D
var rng: RandomNumberGenerator
var health = 100
var path_follow
var on_path: bool
var path_speed: int = 0
var start_position = Vector2.ZERO
var spawned_beams = false
var on_top = false



func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	emit_signal("get_player")


func _physics_process(delta):
	if start_position == Vector2.ZERO:
		start_position = get_parent().position
	elif get_parent().position == start_position and !spawned_beams:
		emit_signal("spawn_blue_beams")
		spawned_beams = true
		on_path = false
	if on_path:
		path_follow.set_offset(path_follow.get_offset() + path_speed * delta)


func start_boss_fight():
	path_speed = 1500


func start_on_top():
	start_position = Vector2.ZERO
	path_speed = 500
	on_path = true
	on_top = true
	var green_timer = Timer.new()
	add_child(green_timer)
	green_timer.connect("timeout", self, "_on_GreenFan_timeout")
	green_timer.autostart = true
	green_timer.wait_time = 1
	var white_timer = Timer.new()
	add_child(white_timer)
	white_timer.connect("timeout", self, "spawn_white_ball_top")
	white_timer.autostart = true
	white_timer.wait_time = 0.5



func return_player(p):
	player = p


func set_path(path):
	path_follow = path
	on_path = true


func shoot_green_single():
	$GreenSingle.start()


func spawn_white_ball():
	if spawned_beams and !on_top:
		return
	else:
		var ball = WhiteBall.instance()
		ball.position = get_parent().position
		if get_parent().position.x > 960:
			ball.linear_velocity = Vector2(-100, -20)
		else:
			ball.linear_velocity = Vector2(100, -20)
		emit_signal("spawn_projectile", ball)
		$WhiteTimer.start()


func spawn_white_ball_top():
	if on_top:
		var ball = WhiteBall.instance()
		ball.position = get_parent().position
		if get_parent().position.x > 960:
			ball.linear_velocity = Vector2(-100, -100)
		else:
			ball.linear_velocity = Vector2(100, -100)
		emit_signal("spawn_projectile", ball)


func spawn_green_ball_single():
	var ball = GreenBall.instance()
	ball.position = get_parent().position
	ball.linear_velocity = get_parent().position.direction_to(player.position) * 2500
	emit_signal("spawn_projectile", ball)
	emit_signal("single_ball_spawned")


func spawn_green_ball(phi):
	var direction = get_parent().position.direction_to(player.position)
	direction = direction.rotated(phi)
	var ball = GreenBall.instance()
	ball.linear_velocity = direction * 400
	ball.position = get_parent().position
	emit_signal("spawn_projectile", ball)


func _on_Hurtbox_area_entered(_area):
	health -= 1
	$Health.value = health


func _on_GreenFan_timeout():
	print("inside_green")
	if !on_top:
		return
	else:
		for i in range(-6,6):
			spawn_green_ball(0.2*i)
