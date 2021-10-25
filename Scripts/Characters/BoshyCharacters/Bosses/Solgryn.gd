extends KinematicBody2D

const WhiteBall = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/WhiteBall.tscn")
const GreenBall = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/GreenBall.tscn")

signal defeated
signal get_player
signal spawn_projectile
signal spawn_blue_beams
signal single_ball_spawned
signal final_position

var player: KinematicBody2D
var rng: RandomNumberGenerator
var health = 80
var path_follow
var on_path: bool
var path_speed: int = 0
var start_position = Vector2.ZERO
var spawned_beams = false
var on_top = false
var final_position = false
var final_offset = 0
var final_offset_increasing = true
var defeated = false


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	emit_signal("get_player")


func _physics_process(delta):
	if start_position == Vector2.ZERO:
		start_position = get_parent().position
	elif get_parent().position == start_position:
		if !spawned_beams:
			emit_signal("spawn_blue_beams")
			spawned_beams = true
			on_path = false
		elif on_top and !final_position:
			emit_signal("final_position")
			on_top = false
			on_path = false
			final_position = true
	if on_path:
		path_follow.set_offset(path_follow.get_offset() + path_speed * delta)


func return_player(p):
	player = p


func set_path(path):
	path_follow = path
	on_path = true


func start_boss_fight():
	path_speed = 1500


func start_on_top():
	start_position = Vector2.ZERO
	path_speed = 500
	on_path = true
	on_top = true
	var green_timer = Timer.new()
	add_child(green_timer)
	green_timer.connect("timeout", self, "spawn_green_fan")
	green_timer.autostart = true
	green_timer.wait_time = 1
	var white_timer = Timer.new()
	add_child(white_timer)
	white_timer.connect("timeout", self, "spawn_white_ball_top")
	white_timer.autostart = true
	white_timer.wait_time = 0.5
	# just restarting the timers didn't work for some reason, so I made new within code


func shoot_final():
	var final_timer = Timer.new()
	add_child(final_timer)
	final_timer.connect("timeout", self, "spawn_two_green_balls")
	final_timer.autostart = true
	final_timer.wait_time = 0.05


func shoot_green_single():
	$GreenSingle.start()


func spawn_white_ball():
	if !spawned_beams and !defeated:
		var ball = WhiteBall.instance()
		ball.position = get_parent().position
		if get_parent().position.x > 960:
			ball.linear_velocity = Vector2(-100, -20)
		else:
			ball.linear_velocity = Vector2(100, -20)
		emit_signal("spawn_projectile", ball)
		$WhiteTimer.start()


func spawn_white_ball_top():
	if on_top and !defeated:
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


func spawn_green_fan():
	if on_top and !defeated:
		for i in range(-6,6):
			spawn_green_ball(0.2*i)


func spawn_green_ball(phi):
	var direction = get_parent().position.direction_to(player.position)
	direction = direction.rotated(phi)
	var ball = GreenBall.instance()
	ball.linear_velocity = direction * 400
	ball.position = get_parent().position
	emit_signal("spawn_projectile", ball)


func spawn_two_green_balls():
	if !defeated:
		var ball1 = GreenBall.instance()
		var ball2 = GreenBall.instance()
		ball1.position = self.position + Vector2(0, 96 + final_offset)
		ball2.position = self.position - Vector2(0, 128 + final_offset)
		ball1.linear_velocity = Vector2(-500, 0)
		ball2.linear_velocity = Vector2(-500, 0)
		emit_signal("spawn_projectile", ball1)
		emit_signal("spawn_projectile", ball2)
		if final_offset_increasing:
			if final_offset > 128:
				final_offset_increasing = false
				final_offset -= 12
			else:
				final_offset += 12
		else:
			if final_offset < 0:
				final_offset_increasing = true
				final_offset += 12
			else:
				final_offset -= 12


func _on_Hurtbox_area_entered(_area):
	health -= 1
	$Health.value = health
	if health < 1:
		defeated = true
		emit_signal("defeated")
		self.queue_free()

