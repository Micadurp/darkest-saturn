extends CharacterBody2D

@export var camera : Camera2D
@export var speed : float = 120
@export var slide_velocity : float = 200
@export var friction : float = 5
@export var local_velocity_cap : float = 250
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var jump_velocity : float = -255
var last_state : State
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var input_direction : Vector2
var local_velocity : Vector2 = Vector2.ZERO
var environmental_velocity : Vector2 = Vector2.ZERO
# true for right, false for left
var moving_direction : bool = true
var last_faced : int = 1
var owie : bool = false

func _ready():
	print("i was never book smart, im money smart")
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

func _on_death_box_of_doom_body_entered(body):
	print("ENTERED")
	position.x = 0
	position.y = 0

func _on_camera_y_trigger_body_entered(body):
	print("ENTER2")
	camera.follow_y = true


func _on_camera_y_trigger_body_exited(body):
	camera.follow_y = false
