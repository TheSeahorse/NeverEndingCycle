extends KinematicBody2D

const Bullet = preload("res://Scripts/Other/Misc/Bullet.tscn")

signal dead

var GRAVITY = 5000
var WALK_SPEED = 500
var JUMPING_SPEED = Vector2(500,800)
enum {P_FROZEN, P_IDLE, P_WALKING, P_INAIR, P_DEAD} #PLAYER_STATE
var PLAYER_STATE = P_IDLE

var player_stats

var velocity = Vector2.ZERO
var on_floor = false
var floors = []
var on_roof = false
var roofs = []
var jump_start = OS.get_ticks_msec()
var holding_jump = false #if holding space
var has_double_jump = true
var dont_show_interaction_sprite = false



func _ready():
	print("boshy ready")
	player_stats = get_parent().stats
	if !player_stats[4][0]:
		play_dialog("boshy_tutorial")
	else:
		get_parent().start_boshy_fight()


func _physics_process(_delta):
	if PLAYER_STATE == P_FROZEN or PLAYER_STATE == P_DEAD:
		return
	var direction = get_direction()
	velocity = calculate_move_velocity(direction)
	decide_player_state()
	velocity = move_and_slide(velocity, Vector2.UP, true)


func _input(event):
	if PLAYER_STATE == P_FROZEN or PLAYER_STATE == P_DEAD:
		return
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_released("jump"):
		holding_jump = false


func start_boss_fight():
	PLAYER_STATE = P_IDLE


func get_direction():
	var x_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_dir = Input.get_action_strength("jump")
	var current_time = OS.get_ticks_msec()
	if y_dir == 1:
		if on_floor:
			play_sound("Jump1")
			holding_jump = true
			jump_start = current_time
		elif holding_jump and current_time - jump_start > 150:
			y_dir = 0
		elif holding_jump:
			pass
		elif has_double_jump:
			play_sound("Jump2")
			has_double_jump = false
			holding_jump = true
			jump_start = current_time
		elif not holding_jump:
			y_dir = 0
	return Vector2(x_dir, -1 * y_dir)


func calculate_move_velocity(direction: Vector2) -> Vector2:
	var new_velocity = velocity
	if direction.y == -1:
		new_velocity.y = -1 * JUMPING_SPEED.y
		if velocity.y > 0:
			new_velocity.y += velocity.y
	new_velocity.x = WALK_SPEED * direction.x
	new_velocity.y += GRAVITY * get_physics_process_delta_time()
	if new_velocity.y > GRAVITY/6:
		new_velocity.y = GRAVITY/6
	return new_velocity


func decide_player_state():
	if on_floor:
		if velocity.x == 0:
			PLAYER_STATE = P_IDLE
		else:
			PLAYER_STATE = P_WALKING
	else:
		PLAYER_STATE = P_INAIR
	decide_player_flip()


func decide_player_flip():
	if velocity.x > 0:
		$Sprite.flip_h = false
		$GunPosition.position.x = 32
	elif velocity.x < 0:
		$Sprite.flip_h = true
		$GunPosition.position.x = -32


func play_dialog(dialog_name: String):
	PLAYER_STATE = P_FROZEN
	var dialog = Dialogic.start(dialog_name)
	add_child(dialog)
	dialog.connect("timeline_end", self, "dialog_ended", [dialog])
	dialog.connect("dialogic_signal", self, "dialog_answer")


func dialog_ended(_timeline_name, dialog):
	PLAYER_STATE = P_IDLE
	dialog.queue_free()


func dialog_answer(answer: String):
	match answer:
		"start_boss_fight":
			get_parent().start_boshy_fight()
		"defeated_megalul":
			get_parent().play_level("boshy", Vector2.ZERO)
		"defeated_scamaz":
			get_parent().play_level("boshy", Vector2.ZERO)


func shoot():
	var bullet = Bullet.instance()
	bullet.position = $GunPosition.position + self.position
	if $Sprite.flip_h:
		bullet.linear_velocity.x = -1300
	else:
		bullet.linear_velocity.x = 1300
	get_parent().add_bullet(bullet)


func get_hit(_area):
	if PLAYER_STATE == P_DEAD:
		return
	PLAYER_STATE = P_DEAD
	$Sprite.hide()
	$Death.play()
	$DeathAnimation.show()
	$DeathAnimation.play("death")


#when deathsound finishes playing
func die():
	emit_signal("dead")


func boss_defeated(number: int):
	PLAYER_STATE = P_FROZEN
	play_dialog("boss_defeated_" + str(number))


func play_sound(sound: String):
	get_node(sound).play()


func _on_FloorDetector_body_entered(body):
	on_floor = true
	has_double_jump = true
	floors.append(body)


func _on_FloorDetector_body_exited(body):
	floors.erase(body)
	if floors.size() == 0:
		on_floor = false


func _on_RoofDetector_body_entered(body):
	jump_start = OS.get_ticks_msec() - 1000
	on_roof = true
	roofs.append(body)


func _on_RoofDetector_body_exited(body):
	roofs.erase(body)
	if roofs.size() == 0:
		on_roof = false
