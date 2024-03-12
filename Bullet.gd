extends Area2D

var direction = Vector2(1.0,0.0)
var speed = 300.0

func _ready():
	add_to_group("Bullets")
	# TODO: LIMIT TO 3 ONSCREEN

# TODO: make them despawn after a little bit

func _process(delta):
	position = position + speed * direction * delta

#some collision detection stuff here
