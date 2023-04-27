extends Node

class_name State

@export var character: CharacterBody2D
var next_state: State
@export var can_move: bool = true
var playback: AnimationNodeStateMachinePlayback
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine

# set up processes for other states to inherit


func state_process(_delta, _direction):
	pass


func state_input(_event: InputEvent):
	pass


# what to do when the state is entered
func on_enter():
	pass


# what to do when the state is exited
func on_exit():
	pass


# Forces a number to be converted to negative
func force_negative(nval):
	if nval < 0:
		return nval
	elif nval > 0:
		return nval * -1


# Forces a number to be converted to positive
func force_positive(pval):
	if pval < 0:
		return pval * -1
	elif pval > 0:
		return pval
