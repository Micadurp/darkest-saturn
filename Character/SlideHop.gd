extends State

class_name SlideHop

@export var double_jump_velocity : float = -100
@export var ground_state : State
@export var running_state : State

var has_double_jumped = false

func state_process(delta, direction):
	if(character.is_on_floor()):
		#print_debug("floor")
		character.local_velocity.y = 0
		if direction.x != 0:
			next_state = running_state
		else:
			next_state = ground_state
		playback.travel("idle")
	else:
		if character.local_velocity.y < character.gravity:
			character.local_velocity.y += character.gravity * delta
		else:
			pass
		character.local_velocity.x = character.speed*sign(direction.x)
		#if (direction.x * character.local_velocity.x < 0) or (direction.x == 0):
		## air friction yippee!!! time to add the boost
			#character.local_velocity.x = move_toward(character.local_velocity.x, 0, character.friction*1)
		#else:
			#character.local_velocity.x = move_toward(character.local_velocity.x, character.local_velocity_cap*sign(direction.x), character.speed)

func state_input(event : InputEvent):
	#if (event.is_action_pressed("jump") && !has_double_jumped):
		#double_jump()
	#elif (event.is_action_pressed("boost")) and character.boost_guage >= 3:
		#boost()
	if event.is_action_released("jump") && character.local_velocity.y  < 0:
		character.local_velocity.y = 0
	if event.is_action_pressed("fire"):
		var fire_funne = 69
		if character.last_faced == DDirection.RIGHT:
			fire_funne = 0
		elif character.last_faced == DDirection.LEFT:
			fire_funne = rad_to_deg(180)
		fire(fire_funne)

func on_exit():
	if(next_state == ground_state):
		#has_double_jumped = false
		playback.travel("idle")

func fire(angle):
	var bullet = load("Bullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT.rotated(angle).normalized()
	get_parent().add_child(bullet)
	bullet.position = character.position + Vector2(0, -10)
