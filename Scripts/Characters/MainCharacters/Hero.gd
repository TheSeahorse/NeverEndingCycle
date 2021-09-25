extends KinematicBody2D

var GRAVITY = 4000
var WALK_SPEED = 400
var JUMPING_SPEED = Vector2(400,700) # you can jump faster than you can walk
enum {P_IDLE, P_WALKING, P_JUMPING, P_FALLING, P_LANDED} #PLAYER_STATE
var PLAYER_STATE = P_IDLE

var player_stats

var velocity = Vector2.ZERO
var on_floor = false
var floors = []
var landing = false
var jumping = false
var holding = false
var jump_start = OS.get_ticks_msec()



func _ready():
	player_stats = get_parent().stats


func _physics_process(_delta):
	var direction = get_direction()
	velocity = calculate_move_velocity(direction)
	decide_player_state()
	velocity = move_and_slide(velocity, Vector2.UP, true)


func _process(_delta):
	#print("jumps: " + str(jumps))
	animate_player()


func _input(event):
	if event.is_action_released("jump"):
		holding = false


func get_direction():
	var x_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_dir = Input.get_action_strength("jump")
	var current_time = OS.get_ticks_msec()
	if y_dir == 1:
		if not jumping and on_floor:
			if holding:
				y_dir = 0
			else:
				holding = true
				jumping = true
				jump_start = OS.get_ticks_msec()
		elif not jumping:
			y_dir = 0
		elif jumping and current_time - jump_start > 250:
			jumping = false
			y_dir = 0
		else:
			pass
	elif jumping:
		jumping = false
	return Vector2(x_dir, -1 * y_dir)


func calculate_move_velocity(direction: Vector2) -> Vector2:
	var new_velocity = velocity
	if direction.y == -1: #jump was triggered
		new_velocity.y = -1 * JUMPING_SPEED.y
	new_velocity.x = WALK_SPEED * direction.x
	new_velocity.y += GRAVITY * get_physics_process_delta_time()
	if new_velocity.y > GRAVITY/3:
		new_velocity.y = GRAVITY/3
	return new_velocity


func decide_player_state():
	if PLAYER_STATE == P_LANDED and landing:
		pass
	elif on_floor:
		if PLAYER_STATE == P_FALLING:
			PLAYER_STATE = P_LANDED
			landing = true
			$LandTimer.start()
		elif velocity.x == 0:
			PLAYER_STATE = P_IDLE
		else:
			PLAYER_STATE = P_WALKING
	elif velocity.y < 0:
		PLAYER_STATE = P_JUMPING
	elif velocity.y >= 0:
		PLAYER_STATE = P_FALLING
	decide_player_flip(velocity)

func animate_player():
	match PLAYER_STATE:
		P_IDLE:
			$AnimatedSprite.play("idle")
		P_WALKING:
			$AnimatedSprite.play("walking")
		P_JUMPING:
			$AnimatedSprite.play("jump")
		P_FALLING:
			$AnimatedSprite.play("fall")
		P_LANDED:
			$AnimatedSprite.play("land")


func decide_player_flip(direction: Vector2):
	if direction.x > 0:
		$AnimatedSprite.flip_h = false
	elif direction.x < 0:
		$AnimatedSprite.flip_h = true


func _on_FloorDetector_body_entered(body):
	on_floor = true
	jumping = false
	floors.append(body)


func _on_FloorDetector_body_exited(body):
	landing = false
	floors.erase(body)
	if floors.size() == 0:
		on_floor = false


func _on_LandTimer_timeout():
	landing = false
