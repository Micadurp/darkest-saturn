extends State

class_name AirState

@export var double_jump_velocity: float = -100
@export var landing_state: State

var has_double_jumped = false


func state_process(delta, direction):
	if character.is_on_floor():
		character.local_velocity.y = 0
		next_state = landing_state
		playback.travel("idle")
	else:
		character.local_velocity.y += character.gravity * delta
		if direction.x * character.local_velocity.x < 0:
			# flips your current velocity so you can change direction on a dime
			character.local_velocity.x *= -1
			# cuts your current velocity by 3/4 so that it's not super jarring
			character.local_velocity.x /= 4
		# apply normal momentum rules
		character.local_velocity.x = move_toward(
			character.local_velocity.x,
			character.local_velocity_cap * sign(direction.x),
			character.speed
		)


func state_input(event: InputEvent):
	if event.is_action_pressed("jump") && !has_double_jumped:
		double_jump()
	pass


func on_exit():
	if next_state == landing_state:
		has_double_jumped = false
		playback.travel("jump_end")


func double_jump():
	character.local_velocity.y = double_jump_velocity
	has_double_jumped = true
	playback.travel("double_jump")
