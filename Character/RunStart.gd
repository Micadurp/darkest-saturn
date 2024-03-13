extends State

class_name RunStart
@export var jump_velocity : float = -225.0
@export var slide_velocity : float = 200
@export var air_state : State
@export var running_state : State
@export var slide_state : State
@export var ground_state : State
@export var default_pause_frames : int = 3
var pause_frames : int = 30

func on_enter():
	pause_frames = default_pause_frames

func state_process(_delta, direction):
	# you air be in the shouldn't!
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		pause_frames -= 1
		if direction.x != 0:
			# check if we're pressing the opposite direction and start braking
			#if (direction.x * character.local_velocity.x < 0):
				#next_state = braking_state
			# apply velocity
			#else:
			#character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*sign(direction.x), character.speed*2)
			character.local_velocity.x = character.speed/2*sign(direction.x)
			if pause_frames <= 0:
				next_state = running_state
		# if we're not pressing anything, go into idle if we're not doing anything, or go into braking if we are
		elif direction.x == 0:
			#if character.velocity.x == 0:
			next_state = ground_state
			playback.travel("idle")
			#else:
				#next_state = braking_state
				#playback.travel("idle")

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
	playback.travel("jump_start")

func slide():
	character.local_velocity.x = slide_velocity*sign(character.last_faced)
	next_state = slide_state

func fire(angle):
	var direction = Vector2(1.0,0.0).rotated(angle).normalized()
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = direction
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(character.last_faced*20, -10)
