extends State

# TODO: implement this
class_name SlideState

# CHECK RUNNING STATE JUMP VELOCITY
@export var jump_velocity : float = -200.0
@export var slide_velocity : float = 200
@export var air_state : State
@export var running_state : State
@export var slide_state : State
@export var ground_state : State
@export var timer : int = 45
@export var slide_dir : int = 1

func state_process(_delta, direction):
	# you shouldn't be in the air!
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		timer -= 1
		# check if we're pressing anything and transition into running
		if timer <= 0:
			next_state = ground_state
			playback.travel("idle")
		# checking if pressing opposite direction
		#print(sign(direction.x)*sign(character.last_faced))
		if sign(direction.x)*slide_dir == -1:
			#character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*sign(direction.x), character.speed)
			#character.local_velocity.x = slide_velocity*sign(direction.x) 
			next_state = ground_state
			playback.travel("idle")
		else:
			character.local_velocity.x = slide_velocity*sign(character.last_faced)

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("slide"):
		slide()
	
func on_enter():
	timer = 45
	slide_dir = character.last_faced
	#print(sign(slide_dir))

func jump():
	character.local_velocity.y = jump_velocity
	next_state = air_state
	playback.travel("jump_end")

func slide():
	character.local_velocity.x = slide_velocity*sign(character.last_faced)
	next_state = slide_state
