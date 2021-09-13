extends KinematicBody2D

var GRAVITY = 3000
var WALK_SPEED = 400
var JUMPING_SPEED = Vector2(800,2000) # you can jump faster than you can walk
var MAX_JUMP_TIME = 600 # only effects how long you need to hold for max jump
var MIN_JUMP_TIME = 200
enum {P_IDLE, P_WALKING, P_CHARGE_JUMP, P_JUMPING, P_MIDAIR, P_FALLING} #PLAYER_STATE
var PLAYER_STATE = P_IDLE

var velocity = Vector2.ZERO
var charge_jump = false
var charge_jump_start = OS.get_ticks_msec()
var charge_jump_end = OS.get_ticks_msec()
var charge_jump_dir = 0 # 1 = right, -1 = left, 0 = straight up


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	#print("PLAYER_STATE: " + str(PLAYER_STATE))
	var direction = get_direction()
	velocity = calculate_move_velocity(direction)
	decide_player_state(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)


func _process(delta):
	animate_player()


func calculate_move_velocity(direction: Vector2) -> Vector2:
	var new_velocity = velocity
	if direction.y == -1: #jump was triggered
		new_velocity.y = calculate_jump_velocity()
	elif self.is_on_floor():
		new_velocity.x = WALK_SPEED * direction.x
	else:
		new_velocity.x = JUMPING_SPEED.x * charge_jump_dir
	new_velocity.y += GRAVITY * get_physics_process_delta_time()
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
	if charge_jump:
		x_dir = 0
		if (Input.is_action_just_released("jump") and self.is_on_floor()) or OS.get_ticks_msec() - charge_jump_start > 800:
			charge_jump_end = OS.get_ticks_msec()
			charge_jump = false
			charge_jump_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
			y_dir = -1
	else:
		if Input.is_action_just_pressed("jump") and self.is_on_floor():
			charge_jump_start = OS.get_ticks_msec()
			charge_jump = true
	return Vector2(x_dir, y_dir)


func decide_player_state(direction):
	print("Direction: " + str(direction))
	if charge_jump:
		PLAYER_STATE = P_CHARGE_JUMP
	elif self.is_on_floor():
		if direction.x == 0:
			PLAYER_STATE = P_IDLE
		else:
			PLAYER_STATE = P_WALKING
	else:
		if direction.y > 400:
			PLAYER_STATE = P_FALLING
		elif direction.y <= -400:
			PLAYER_STATE = P_JUMPING
		else:
			PLAYER_STATE = P_MIDAIR
	decide_player_flip(direction)


func decide_player_flip(direction: Vector2):
	if direction.x > 0:
		$AnimatedSprite.flip_h = false
	elif direction.x < 0:
		$AnimatedSprite.flip_h = true


func animate_player():
	match PLAYER_STATE:
		P_IDLE:
			$AnimatedSprite.play("idle")
		P_WALKING:
			$AnimatedSprite.play("walk")
		P_JUMPING:
			$AnimatedSprite.play("jump")
		P_MIDAIR:
			$AnimatedSprite.play("midair")
		P_FALLING:
			$AnimatedSprite.play("fall")
		P_CHARGE_JUMP:
			$AnimatedSprite.play("charge_jump")
