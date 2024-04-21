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
		#print_debug(last_state)
	if(!character.is_on_floor()):
		next_state = air_state
		if slidecast.is_colliding():
			# janky workaround for getting stuck in the ceiling after sliding off an edge while under a ceiling
			character.position.y += 14
	else:
		timer -= 1
		# check if we're pressing anything and transition into running
		if timer <= 0:
			if slidecast.is_colliding():
				return
			elif sign(direction.x)*slide_dir == 1:
				next_state = running_state
			else:
				next_state = ground_state
				playback.travel("idle")
		# checking if pressing opposite direction
		#print_debug(sign(direction.x)*sign(character.last_faced))
		if sign(direction.x)*slide_dir == -1:
			if slidecast.is_colliding():
				slide()
			else:
				#character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*sign(direction.x), character.speed)
				#character.local_velocity.x = slide_velocity*sign(direction.x) 
				next_state = ground_state
				playback.travel("idle")
		else:
			character.local_velocity.x = character.slide_velocity*sign(character.last_faced)
	shoot_anim_timer("slide")

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		if slidecast.is_colliding():
			return
		else:
			jump()
	if event.is_action_pressed("slide"):
		slide()
	if event.is_action_pressed("fire"):
		var fire_funne = 69
		if character.last_faced == DDirection.RIGHT:
			fire_funne = 0
		elif character.last_faced == DDirection.LEFT:
			fire_funne = deg_to_rad(180)
		fire(fire_funne)
		
		shoot_anim("slide_shoot")
	
func on_enter():
	timer = 30
	slide_dir = character.last_faced
	slide_hurtbox.disabled = false
	hurtbox.disabled = true
	#hurtbox.scale.y = 0.1
	#hurtbox.position.y += 21
	playback.travel("slide")

func on_exit():
	slide_hurtbox.disabled = true
	hurtbox.disabled = false
	#hurtbox.scale.y = 1
	#hurtbox.position.y -= 21
	pass

func jump():
	character.local_velocity.y = character.jump_velocity
	next_state = air_state
	playback.travel("jump")

func slide(): # Do we wanna remove this???
	character.local_velocity.x = character.slide_velocity*sign(character.last_faced)
	next_state = slide_state

func fire(angle):
	var direction = Vector2.RIGHT.rotated(angle).normalized()
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = direction
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(character.last_faced*10, 8)
