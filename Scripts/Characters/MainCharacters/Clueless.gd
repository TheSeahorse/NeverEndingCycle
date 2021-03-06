extends KinematicBody2D

var GRAVITY = 3000
var WALK_SPEED = 400
var JUMPING_SPEED = Vector2(800,2000) # you can jump faster than you can walk
var MAX_JUMP_TIME = 600 # long you need to hold for max jump, in millisecs
var MIN_JUMP_TIME = 200
enum {P_FROZEN, P_IDLE, P_WALKING, P_CHARGE_JUMP, P_JUMPING, P_FALLING, P_WALLCRASHING, P_ROOFCRASHING, P_WALKOFF, P_FLOORCRASHED} #PLAYER_STATE
var PLAYER_STATE = P_IDLE

var on_floor = false
var floors = []
var on_wall = false
var walls = []
var on_roof = false
var roofs = []
var velocity = Vector2.ZERO
var player_should_crash = false
var holding_jump = false
var charge_jump_start = OS.get_ticks_msec()
var charge_jump_end = OS.get_ticks_msec()
var jump_dir = 0 # 1 = right, -1 = left, 0 = straight up
var dialog_area: Area2D = null
var next_dialog: String = ""
var player_stats: Array

func _ready():
	player_stats = get_parent().stats
	next_dialog = "clueless_easy"
	play_dialog()


func _physics_process(_delta):
	if PLAYER_STATE == P_FROZEN:
		return
	var direction = get_direction()
	velocity = calculate_move_velocity(direction)
	decide_player_state()
	velocity = move_and_slide(velocity, Vector2.UP, true)


func _process(_delta):
	if Input.get_action_strength("jump") > 0:
		holding_jump = true
	else:
		holding_jump = false
	animate_player()


func _input(event):
	if event.is_action_pressed("interact") and dialog_area != null and PLAYER_STATE != P_FROZEN:
		play_dialog()


# [stat to be added, amount to be added]
func add_stats(stat, amount):
	get_parent().add_stats(stat, amount)


func play_dialog():
	if is_instance_valid(dialog_area):
		next_dialog = dialog_area.get_next_dialog(self, player_stats)
	$InteractSprite.hide()
	PLAYER_STATE = P_FROZEN
	var dialog = Dialogic.start(next_dialog)
	add_child(dialog)
	dialog.connect("timeline_end", self, "dialog_ended", [dialog])
	dialog.connect("dialogic_signal", self, "dialog_answer")


func dialog_ended(_timeline_name, dialog):
	PLAYER_STATE = P_IDLE
	dialog.queue_free()
	if next_dialog == "copesen_its_ironic" or next_dialog == "clueless_easy":
		$InteractSprite.hide()
		next_dialog = ""
	else:
		$InteractSprite.show()


func dialog_answer(answer: String):
	match answer:
		"one_eg":
			add_stats(1, 1)
		"nine_egs":
			dialog_area.remove_crown()
			add_stats(1, 9)
		"hobo_eg":
			$eg_pickup.play()
			add_stats(0, 1)
			dialog_area.hobo_poof()
			$InteractSprite.hide()
			next_dialog = ""
			dialog_area = null
		"copesen_ironic":
			dialog_area.copesen_free()
			dialog_area = null
			$InteractSprite.hide()


func calculate_move_velocity(direction: Vector2) -> Vector2:
	var new_velocity = velocity
	if direction.y == -1: #jump was triggered
		play_sound("jk_jump")
		new_velocity.y = calculate_jump_velocity()
	elif on_floor:
		if (PLAYER_STATE == P_IDLE or PLAYER_STATE == P_WALKING or PLAYER_STATE == P_FLOORCRASHED):
			new_velocity.x = WALK_SPEED * direction.x
		else:
			new_velocity.x = 0
	elif PLAYER_STATE == P_JUMPING or PLAYER_STATE == P_FALLING:
		new_velocity.x = JUMPING_SPEED.x * jump_dir
	elif PLAYER_STATE == P_WALLCRASHING or PLAYER_STATE == P_ROOFCRASHING:
		new_velocity.x = WALK_SPEED * jump_dir
	new_velocity.y += GRAVITY * get_physics_process_delta_time()
	if new_velocity.y > GRAVITY:
		player_should_crash = true
		new_velocity.y = GRAVITY
	return new_velocity


func calculate_jump_velocity() -> int:
	var jump_power = charge_jump_end - charge_jump_start
	if jump_power > MAX_JUMP_TIME:
		jump_power = MAX_JUMP_TIME
	if jump_power < MIN_JUMP_TIME:
		jump_power = MIN_JUMP_TIME
	return -1 * (JUMPING_SPEED.y * jump_power/MAX_JUMP_TIME)


func get_direction() -> Vector2:
	var x_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_dir = 0
	if PLAYER_STATE == P_CHARGE_JUMP:
		x_dir = 0
		if not on_floor:
			PLAYER_STATE = P_WALKOFF
		elif Input.is_action_just_released("jump") or OS.get_ticks_msec() - charge_jump_start > 800:
			charge_jump_end = OS.get_ticks_msec()
			PLAYER_STATE = P_IDLE
			jump_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
			y_dir = -1
	elif holding_jump and on_floor and PLAYER_STATE != P_FLOORCRASHED and PLAYER_STATE != P_FALLING and PLAYER_STATE != P_ROOFCRASHING and PLAYER_STATE != P_WALKOFF and PLAYER_STATE != P_WALLCRASHING:
			charge_jump_start = OS.get_ticks_msec()
			PLAYER_STATE = P_CHARGE_JUMP
	return Vector2(x_dir, y_dir)


func player_crash(is_wall: bool):
	play_sound("jk_bounce")
	if is_wall:
		PLAYER_STATE = P_WALLCRASHING
		jump_dir *= -1
	else:
		PLAYER_STATE = P_ROOFCRASHING


func decide_player_state():
	if PLAYER_STATE == P_CHARGE_JUMP: #gets set in get_direction
		pass
	elif PLAYER_STATE == P_WALLCRASHING and not on_floor:
		decide_player_flip(Vector2(-1 * velocity.x, -1 * velocity.y))
		return
	elif PLAYER_STATE == P_ROOFCRASHING and not on_floor:
		pass
	elif PLAYER_STATE == P_WALKOFF and not on_floor:
		pass
	elif on_floor:
		if player_should_crash:
			player_should_crash = false
			play_sound("jk_crash")
			PLAYER_STATE = P_FLOORCRASHED
		else:
			if PLAYER_STATE != P_IDLE and PLAYER_STATE != P_WALKING and PLAYER_STATE != P_FLOORCRASHED:
				play_sound("jk_land")
			if velocity.x == 0:
				if PLAYER_STATE == P_FLOORCRASHED:
					PLAYER_STATE = P_FLOORCRASHED
				else:
					PLAYER_STATE = P_IDLE
			else:
				PLAYER_STATE = P_WALKING
	else:
		if velocity.y > 0:
			if PLAYER_STATE == P_WALKING:
				if velocity.x > 0:
					jump_dir = 1
				elif velocity.x < 0:
					jump_dir = -1
				else:
					jump_dir = 0
				PLAYER_STATE = P_WALKOFF
			else:
				PLAYER_STATE = P_FALLING
		else:
			PLAYER_STATE = P_JUMPING
	decide_player_flip(velocity)


func decide_player_flip(direction: Vector2):
	if direction.x > 0:
		$InteractSprite.set_position(Vector2(80, -140))
		$AnimatedSprite.flip_h = false
		$AmongusRed.flip_h = false
	elif direction.x < 0:
		$InteractSprite.set_position(Vector2(-80, -140))
		$AnimatedSprite.flip_h = true
		$AmongusRed.flip_h = true


func animate_player():
	match PLAYER_STATE:
		P_FROZEN:
			$AnimatedSprite.play("idle")
		P_IDLE:
			$AnimatedSprite.play("idle")
		P_WALKING:
			$AnimatedSprite.play("walk")
		P_JUMPING:
			$AnimatedSprite.play("jump")
		P_FALLING:
			$AnimatedSprite.play("fall")
		P_CHARGE_JUMP:
			$AnimatedSprite.play("charge_jump")
		P_WALLCRASHING:
			$AnimatedSprite.play("crash")
		P_ROOFCRASHING:
			$AnimatedSprite.play("crash")
		P_FLOORCRASHED:
			$AnimatedSprite.play("floor_crash")
		P_WALKOFF:
			$AnimatedSprite.play("crash")


func play_sound(sound: String):
	$jk_jump.play()
	get_node(sound).play()


func get_among_us_costume_visibility() -> bool:
	return $AmongusRed.visible


func among_us_costume(status: bool):
	$AmongusRed.visible = status
	$AnimatedSprite.visible = not status


func _on_WallDetector_body_entered(body):
	if on_wall == false and not on_floor:
		player_crash(true)
	on_wall = true
	walls.append(body)



func _on_WallDetector_body_exited(body):
	walls.erase(body)
	if walls.size() == 0:
		on_wall = false



func _on_FloorDetector_body_entered(body):
	on_floor = true
	floors.append(body)


func _on_FloorDetector_body_exited(body):
	floors.erase(body)
	if floors.size() == 0:
		on_floor = false


func _on_RoofDetector_body_entered(body):
	if on_roof == false and not on_floor:
		player_crash(false)
	on_roof = true
	roofs.append(body)


func _on_RoofDetector_body_exited(body):
	roofs.erase(body)
	if roofs.size() == 0:
		on_roof = false


func _on_InteractionDetector_area_entered(area):
	if area.get_collision_layer_bit(2):
		next_dialog = area.get_next_dialog(self, player_stats)
		dialog_area = area
		$InteractSprite.show()
	elif area.get_collision_layer_bit(3):
		if area is Eg:
			$eg_pickup.play()
			add_stats(0,1)
			area.collected()


func _on_InteractionDetector_area_exited(area):
	if area.get_collision_layer_bit(2):
		$InteractSprite.hide()
		dialog_area = null
		next_dialog = ""
