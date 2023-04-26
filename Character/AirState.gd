extends State

class_name AirState

@export var double_jump_velocity : float = -100
@export var landing_state : State

var has_double_jumped = false

func state_process(delta):
	if(character.is_on_floor()):
		character.local_velocity.y = 0
		next_state = landing_state
		playback.travel("idle")
	else:
		character.local_velocity.y += character.gravity * delta

func state_input(event : InputEvent):
	if (event.is_action_pressed("jump") && !has_double_jumped):
		double_jump()
	pass

func on_exit():
	if(next_state == landing_state):
		has_double_jumped = false
		playback.travel("jump_end")

func double_jump():
	character.local_velocity.y = double_jump_velocity
	has_double_jumped = true
	playback.travel("double_jump")
