extends Node

class_name CharacterStateMachine

@export var character : CharacterBody2D
@export var current_state : State
@export var animation_tree : AnimationTree

var states : Array[State]
var input_direction : Vector2

func _ready():
	# Checks every child Node (ex. Ground, Air, Landing...)
	for child in get_children():
		# Adds child to the array above, assuming it's a State
		if(child is State):
			states.append(child)
			
			# Set states up for what they need to function
		# There shouldn't be any children that aren't states.
			child.character = character
			child.playback = animation_tree["parameters/playback"]
		else:
			push_warning("Child " + child.name + " is not a State for CharacterStateMachine!")
			
func _physics_process(delta):
	if (current_state.next_state != null):
		switch_states(current_state.next_state)
	
	input_direction = Input.get_vector("left", "right", "up", "down")
	
	current_state.state_process(delta, input_direction)

func check_if_can_move():
	return current_state.can_move
	
func get_input_direction():
	return input_direction

func switch_states(new_state : State):
	if (current_state != null):
		# Calls exit functions
		current_state.on_exit()
		# Making sure it doesn't immediately try to switch into the same state AGAIN
		current_state.next_state = null
	# The great switching of states occurs
	current_state = new_state
	
	# Calls enter functions for new state
	current_state.on_enter()

func _input(event : InputEvent):
	current_state.state_input(event)
