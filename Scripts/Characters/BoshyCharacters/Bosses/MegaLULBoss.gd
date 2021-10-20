extends KinematicBody2D

const AlienPlsBounce = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/AlienPlsBounce.tscn")
const AlienPlsFlat = preload("res://Scripts/Characters/BoshyCharacters/Projectiles/AlienPlsFlat.tscn")

signal defeated
signal phase_two

var start_pos: Vector2
var move_direction = Vector2(0,-1)
var move_speed = Vector2(100,100)
var health = 100
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
	if !hard and health < 51:
		hard_mode()
		hard = true
	if health < 1:
		emit_signal("defeated")
		self.queue_free()


func _physics_process(_delta):
	if !started:
		return
	move_and_slide(move_direction*move_speed,Vector2.ZERO)


func start_boss_fight():
	$AttackTimer.start()
	$MoveTimer.start()
	$Sprite.show()
	$Health.show()
	started = true


func hard_mode():
	emit_signal("phase_two")
	$AttackTimer.wait_time = 1.5
	$MoveTimer.wait_time = 2.5
	alien_bounce_vel = Vector2(-700,-400)
	alien_flat_vel = Vector2(-400,0)


func _on_Hurtbox_area_entered(_area):
	health -= 1
	$Health.value = health


func _on_MoveTimer_timeout():
	if hard:
		move_speed = Vector2(200,200)
	move_direction.y *= -1


func _on_AttackTimer_timeout():
	var alien
	if rng.randi() % 2 == 0:
		alien = AlienPlsBounce.instance()
		alien.linear_velocity = alien_bounce_vel
	else:
		alien = AlienPlsFlat.instance()
		alien.linear_velocity = alien_flat_vel
	alien.position = self.position
	get_parent().call_deferred("add_child", alien)
