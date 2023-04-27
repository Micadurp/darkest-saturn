extends State

@export var jump_velocity: float = -150.0
@export var air_state: State
@export var running_state: State
@export var ground_state: State


func state_process(_delta, direction):
	# you shouldn't be in the air!
	if !character.is_on_floor():
		next_state = air_state
	else:
		# check to see if we're holding the same direction we're moving
		if direction.x != 0 and (direction.x * character.local_velocity.x > 0):
			# put us back into running state
			character.local_velocity.x = move_toward(
				character.local_velocity.x,
				character.local_velocity_cap * sign(direction.x),
				character.speed
			)
			next_state = running_state
			playback.travel("running")
		else:
			if character.local_velocity.x == 0:
				# check to see if we're not pressing anything when we stop
				if direction.x == 0:
					next_state = ground_state
				# i don't even know if this is ever called
				else:
					character.local_velocity.x = move_toward(
						character.local_velocity.x,
						character.local_velocity_cap * sign(direction.x),
						character.speed
					)
			else:
				# apply friction if we're moving
				character.local_velocity.x = move_toward(
					character.local_velocity.x, 0, character.friction * 2
				)


func state_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		jump()


func jump():
	character.local_velocity.y = jump_velocity
	next_state = air_state
	playback.travel("jump_start")
