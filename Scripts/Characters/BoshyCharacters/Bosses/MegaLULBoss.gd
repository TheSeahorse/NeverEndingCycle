extends KinematicBody2D

onready var path_follow = get_parent()

const AlienPlsBounce = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/AlienPlsBounce.tscn")
const AlienPlsFlat = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/AlienPlsFlat.tscn")

signal defeated
signal spawn_alien
signal phase_two

var start_pos: Vector2
var move_direction = Vector2(0,-1)
var speed = 100
var health = 2
var rng: RandomNumberGenerator
var started = false
var hard = false

var alien_bounce_vel = Vector2(-500,-500)
var alien_flat_vel = Vector2(-250,0)

func _ready():
	start_pos = self.position
	rng = RandomNumberGenerator.new()
	rng.randomize()


func _process(_delta):
	if !started:
		return
	if !hard and health < 61:
		hard_mode()
		hard = true
	if health < 1:
		emit_signal("defeated")
		self.queue_free()


func _physics_process(delta):
	if !started:
		return
	path_follow.set_offset(path_follow.get_offset() + speed * delta)


func start_boss_fight():
	$AttackTimer.start()
	$Sprite.show()
	$Health.show()
	started = true


func hard_mode():
	emit_signal("phase_two")
	$AttackTimer.wait_time = 1.5
	speed *= 2
	alien_bounce_vel = Vector2(-700,-400)
	alien_flat_vel = Vector2(-400,0)


func _on_Hurtbox_area_entered(_area):
	health -= 1
	$Health.value = health



func _on_AttackTimer_timeout():
	var alien
	if rng.randi() % 2 == 0:
		alien = AlienPlsBounce.instance()
		alien.linear_velocity = alien_bounce_vel + Vector2(rng.randi_range(-50,50),0)
	else:
		alien = AlienPlsFlat.instance()
		alien.linear_velocity = alien_flat_vel
	alien.position = self.position + get_parent().position
	emit_signal("spawn_alien", alien)
