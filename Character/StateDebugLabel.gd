extends Label

@export var state_machine : CharacterStateMachine
@export var character : CharacterBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "State: " + state_machine.current_state.name + "\nStamina: " + str(character.boost_guage)
