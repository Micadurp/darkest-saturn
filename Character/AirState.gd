# TODO: Walljump???

extends State

class_name AirState

@export var double_jump_velocity : float = -100
@export var ground_state : State

var has_double_jumped = false

func state_process(delta, direction):
	if(character.is_on_floor()):
		#print("floor")
		character.local_velocity.y = 0
		next_state = ground_state
		playback.travel("idle")
	else:
		character.local_velocity.y += character.gravity * delta
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
	pass

func on_exit():
	if(next_state == ground_state):
		#has_double_jumped = false
		playback.travel("idle")

#func double_jump():
	#character.local_velocity.y = double_jump_velocity
	#has_double_jumped = true
	#playback.travel("double_jump")

#func boost():
	#character.boost_guage -= 3
	#if character.local_velocity.y >= 0:
		#character.local_velocity.y = 0
	#if (character.input_direction.x * character.local_velocity.x < 0):
		#character.local_velocity.x *= -1
	#character.local_velocity.x += sign(character.input_direction.x) * character.boost_velocity
	#character.local_velocity.y = -character.boost_height
