extends State

class_name RunningState

@export var jump_velocity : float = -150.0
@export var air_state : State
@export var ground_state : State
@export var braking_state : State

func state_process(_delta, direction):
	# you air be in the shouldn't!
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		if direction.x != 0:
			# check if we're pressing the opposite direction and start braking
			if (direction.x * character.local_velocity.x < 0):
				next_state = braking_state
			# apply velocity
			else:
				character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*sign(direction.x), character.speed)
		# if we're not pressing anything, go into idle if we're not doing anything, or go into braking if we are
		elif direction.x == 0:
			if character.velocity.x == 0:
				next_state = ground_state
				playback.travel("idle")
			else:
				next_state = braking_state
				playback.travel("idle")

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()
	
func jump():
	character.local_velocity.y = jump_velocity
	next_state = air_state
	playback.travel("jump_start")
