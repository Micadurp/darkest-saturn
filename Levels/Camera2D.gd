extends Camera2D
@export var character : CharacterBody2D
var follow_y : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Checks to see if the room allows following the y axis.
	if follow_y:
		position.y = character.position.y
	position.x = character.position.x
	pass
