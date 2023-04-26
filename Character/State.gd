extends Node

class_name State

var character : CharacterBody2D
var next_state : State
@export var can_move : bool = true
var playback : AnimationNodeStateMachinePlayback
var direction : Vector2
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

func state_process(delta):
	pass

func state_input(event : InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
