extends KinematicBody2D

onready var path_follow = get_parent()

const Pain = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/Pain.tscn")
const MindControl = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/MindControl.tscn")

signal defeated
signal phase_two
signal get_player
signal spawn_projectile

var rng: RandomNumberGenerator
var speed = 0
var pain_speed = 600
var control_speed = 250
var health = 1
var hard_mode = false
var pain_time = 4
var pain_separation = 0.4
var control_time = 8
var player: KinematicBody2D


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	emit_signal("get_player")


func _process(_delta):
	if health < 51 and !hard_mode:
		start_hard_mode()
	if health < 1:
		emit_signal("defeated")
		self.queue_free()


func _physics_process(delta):
	path_follow.set_offset(path_follow.get_offset() + speed * delta)


func return_player(p):
	player = p


func start_boss_fight():
	speed = -200
	$PainTimer.start()


func start_hard_mode():
	hard_mode = true
	speed = 300
	pain_speed = 700
	pain_time = 3
	pain_separation = 0.3
	$MindControlTimer.start()
	emit_signal("phase_two")


func spawn_pain(phi: float):
	var global_position = self.position + get_parent().position
	var pain_direction = global_position.direction_to(player.position)
	pain_direction = pain_direction.rotated(phi)
	var pain = Pain.instance()
	pain.linear_velocity = pain_direction * pain_speed
	pain.position = global_position
	emit_signal("spawn_projectile", pain)


func spawn_control():
	var control = MindControl.instance()
	control.player = player
	control.speed = control_speed
	control.position = self.position + get_parent().position
	emit_signal("spawn_projectile", control)


func _on_Hurtbox_area_entered(_area):
	health -= 1
	$Health.value = health


func _on_PainTimer_timeout():
	for i in range(-6,6):
		spawn_pain(pain_separation*i)
	$PainTimer.start(pain_time + rng.randf_range(0.0,pain_time/2))


func _on_MindControlTimer_timeout():
	spawn_control()
	$MindControlTimer.start(control_time + rng.randf_range(0, control_time/2))
