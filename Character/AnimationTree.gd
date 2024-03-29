extends AnimationTree

@export var state_machine : CharacterStateMachine
@export var player : CharacterBody2D
var shoot : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(state_machine.current_state)
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("fire"):
		shoot = 60
	if shoot > 0:
		shoot -= 1
