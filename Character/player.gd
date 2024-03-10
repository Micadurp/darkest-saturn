extends CharacterBody2D

@export var speed : float = 100
@export var friction : float = 5
@export var local_velocity_cap : float = 250
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
# Get the gravity from the project settings to be synced with RigidBody nodes.
var boost_limit : float = 3
var boost_height : float = 125
var boost_guage : float = 0 
var boost_velocity : float = 250
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var input_direction : Vector2
var local_velocity : Vector2 = Vector2.ZERO
var environmental_velocity : Vector2 = Vector2.ZERO
# true for right, false for left
var moving_direction : bool = true
var last_faced : int = 1

func _ready():
	print("haiiii uwu funne megaman game is a go!!!")
	animation_tree.active = true

func _physics_process(_delta):
	#print(last_faced)
	input_direction = Input.get_vector("left", "right", "up", "down")
	
	# unused, might be useful later
	if input_direction.x != 0 && state_machine.check_if_can_move():
		if input_direction.x > 0:
			last_faced = 1
		elif input_direction.x < 0:
			last_faced = -1
		if !is_on_floor():
			pass
	
	if is_on_floor():
		pass
	
	# environmental velocity is controlled by objects in the environment, such as speed boosters, and naturally slows down
	environmental_velocity.x = move_toward(environmental_velocity.x, 0, friction)
	
	velocity = local_velocity + environmental_velocity
	move_and_slide()
	update_animation(input_direction)
	update_facing_direction(input_direction)
	
func update_animation(direction):
	animation_tree.set("parameters/Move/blend_position", direction.x)

func update_facing_direction(direction):
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
