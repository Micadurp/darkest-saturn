extends State

# TODO: implement this
class_name SlideState

# CHECK RUNNING STATE JUMP VELOCITY
@export var jump_velocity : float = -200.0
@export var air_state : State
@export var running_state : State
@export var slide_state : State
@export var ground_state : State
@export var runstart_state : State
@export var timer : int = 69
@export var slide_dir : int = 1

func state_process(_delta, direction):
	# you shouldn't be in the air!
	#if last_state != null:
		#dsprint(last_state)
	if(!character.is_on_floor()):
		next_state = air_state
	else:
		timer -= 1
		# check if we're pressing anything and transition into running
		if timer <= 0:
			if sign(direction.x)*slide_dir == 1:
				next_state = running_state
			else:
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
			character.local_velocity.x = character.slide_velocity*sign(character.last_faced)

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
	
func on_enter():
	timer = 30
	slide_dir = character.last_faced

func jump():
	character.local_velocity.y = character.jump_velocity
	next_state = air_state
	playback.travel("jump_end")

func slide(): # Do we wanna remove this???
	character.local_velocity.x = character.slide_velocity*sign(character.last_faced)
	next_state = slide_state

func fire(angle):
	var direction = Vector2(1.0,0.0).rotated(angle).normalized()
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = direction
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(0, -10)
