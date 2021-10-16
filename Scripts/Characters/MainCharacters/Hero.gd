extends KinematicBody2D

var GRAVITY = 5000
var WALK_SPEED = 500
var JUMPING_SPEED = Vector2(500,1000)
enum {P_FROZEN, P_IDLE, P_WALKING, P_JUMPING, P_FALLING, P_LANDED} #PLAYER_STATE
var PLAYER_STATE = P_IDLE

var player_stats

var velocity = Vector2.ZERO
var on_floor = false
var floors = []
var landing = false
var jumping = false
var holding = false
var jump_start = OS.get_ticks_msec()
var dialog_area = null
var next_dialog: String = ""
var dont_show_interaction_sprite = false


func _ready():
	player_stats = get_parent().stats
	if self.position == Vector2(6000, -220):
		dont_show_interaction_sprite = true
		next_dialog = "ended_stream"
		play_dialog()


func _physics_process(_delta):
	if PLAYER_STATE == P_FROZEN:
		return
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
	if event.is_action_pressed("interact") and is_instance_valid(dialog_area) and PLAYER_STATE != P_FROZEN:
		play_dialog()


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
				jump_start = current_time
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
		P_FROZEN:
			$AnimatedSprite.play("idle")
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
		$InteractSprite.position = Vector2(100, -100)
	elif direction.x < 0:
		$AnimatedSprite.flip_h = true
		$InteractSprite.position = Vector2(-100, -100)


func play_dialog():
	if is_instance_valid(dialog_area):
		next_dialog = dialog_area.get_next_dialog(self)
	$InteractSprite.hide()
	PLAYER_STATE = P_FROZEN
	var dialog = Dialogic.start(next_dialog)
	add_child(dialog)
	dialog.connect("timeline_end", self, "dialog_ended", [dialog])
	dialog.connect("dialogic_signal", self, "dialog_answer")


func dialog_ended(_timeline_name, dialog):
	PLAYER_STATE = P_IDLE
	dialog.queue_free()
	if dont_show_interaction_sprite:
		$InteractSprite.hide()
		dont_show_interaction_sprite = false
	else:
		$InteractSprite.show()


func dialog_answer(answer: String):
	match answer:
		"open_one":
			var level = get_parent().get_level()
			level.unlock_door(1)
		"open_two":
			var level = get_parent().get_level()
			level.unlock_door(2)
		"open_bog":
			var level = get_parent().get_level()
			level.open_hidden_door(1)
		"open_four":
			var level = get_parent().get_level()
			level.unlock_door(4)
		"fors_crown":
			dialog_area.equip_crown()


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


func _on_InteractionDetector_area_entered(area):
	dialog_area = area
	$InteractSprite.show()


func _on_InteractionDetector_area_exited(_area):
	$InteractSprite.hide()
	dialog_area = null
	next_dialog = ""


func _on_CollectibleDetector_area_entered(area):
	if area is DoorKey:
		dont_show_interaction_sprite = true
		var door = area.pickup_key()
		next_dialog = "unlocked_door" + str(door)
		var level = get_parent().get_level()
		level.unlock_door(door)
		area.queue_free()
		play_dialog()


func _on_CollectibleDetector_area_exited(_area):
	pass # Replace with function body.
