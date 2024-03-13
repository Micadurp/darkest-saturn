extends State

class_name GroundState

# CHECK RUNNING STATE JUMP VELOCITY
@export var jump_velocity : float = -225.0
@export var slide_velocity : float = 200
@export var air_state : State
@export var running_state : State
@export var slide_state : State
@export var runstart_state : State

func state_process(_delta, direction):
	# you shouldn't be in the air!
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		#print(direction.x)
		# check if we're pressing anything and transition into running
		if direction.x != 0:
			#character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*sign(direction.x), character.speed)
			character.local_velocity.x = character.speed*sign(direction.x/2) 
			next_state = runstart_state
			playback.travel("running")
		else:
			character.local_velocity.x = 0

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("slide"):
		slide()
	if event.is_action_pressed("fire"):
		var fire_funne = 69
		if character.last_faced > 0:
			fire_funne = 0
		elif character.last_faced < 0:
			# WHAT THE FUCK IS A RADIAN?!
			fire_funne = 3.1415926536
		fire(fire_funne)
	

func jump():
	character.local_velocity.y = character.jump_velocity
	next_state = air_state
	playback.travel("jump_end")

func slide():
	character.local_velocity.x = slide_velocity*sign(character.last_faced)
	next_state = slide_state

# TODO: copy to other states once finalized
func fire(angle):
	var direction = Vector2(1.0,0.0).rotated(angle).normalized()
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = direction
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(0, -10)

