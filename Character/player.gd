extends CharacterBody2D

@export var speed : float = 5
@export var friction : float = 7
@export var local_velocity_cap : float = 250
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO
var local_velocity : Vector2 = Vector2.ZERO
var environmental_velocity : Vector2 = Vector2.ZERO
# true for right, false for left
var moving_direction : bool = true

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# I would give some ferocious head for some guidance on how to move this into the state machine
	# oh my fucking god this is so bad
	direction = Input.get_vector("left", "right", "up", "down")
	
	# THE GREAT MOMENTUM ADVENTURE
	if direction.x != 0 && state_machine.check_if_can_move():
		if !is_on_floor():
			# clusterfuck of a line that determines if we're holding the opposite direction
			if (local_velocity.x < 0 and dumb_float(direction.x) == 1) or (local_velocity.x > 0 and dumb_float(direction.x) == -1):
				# flips your current velocity so you can change direction on a dime
				local_velocity.x *= -1
				# cuts your current velocity by 3/4 so that it's not super jarring
				local_velocity.x /= 4
			# apply normal momentum rules
			local_velocity.x = move_toward(local_velocity.x, local_velocity_cap*dumb_float(direction.x), speed)
		else:
			# grounded "check if we're holding the opposite direction
			if (local_velocity.x < 0 and dumb_float(direction.x) == 1) or (local_velocity.x > 0 and dumb_float(direction.x) == -1):
				local_velocity.x = move_toward(local_velocity.x, 0, friction)
			else:
				# let us move normally ffs
				local_velocity.x = move_toward(local_velocity.x, local_velocity_cap*dumb_float(direction.x), speed)
	else:
#		if (local_velocity.x < 0 and sprite.flip_h == false) or (local_velocity.x > 0 and sprite.flip_h == true):
		local_velocity.x = move_toward(local_velocity.x, 0, friction)
	
	environmental_velocity.x = move_toward(environmental_velocity.x, 0, friction)
	
	velocity = local_velocity + environmental_velocity
	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	animation_tree.set("parameters/Move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
		

func dumb_float(inputf):
	if inputf == 0:
		return 0
	elif inputf > 0:
		return 1
	elif inputf < 0:
		return -1
