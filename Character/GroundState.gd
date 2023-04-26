extends State

class_name GroundState

@export var jump_velocity : float = -150.0
@export var air_state : State
@export var running_state : State

func state_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	# you shouldn't be in the air!
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		# check if we're pressing anything and transition into running
		if direction.x != 0:
			character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*dumb_float(direction.x), character.speed)
			next_state = running_state
			playback.travel("running")

func state_input(event : InputEvent):
	if Input.is_action_pressed("jump"):
		jump()
	

func jump():
	character.local_velocity.y = jump_velocity
	next_state = air_state
	playback.travel("jump_start")
