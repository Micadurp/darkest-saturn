extends Area2D

@onready var sprite : Sprite2D = $Sprite2D
@export var visibility : VisibleOnScreenNotifier2D
var direction = Vector2(1.0,0.0)
var speed = 350.0

func _ready():
	add_to_group("Bullets")
	var bullets = get_tree().get_nodes_in_group("Bullets")
	if bullets.size() > 4: # Why the fuck does this need to be a 4???
		queue_free()
	print(bullets.size()-1) # Account for the weird er... counting.

func _process(delta):
	position = position + speed * direction * delta
	sprite.flip_h = (direction.x == -1.0) # flips the sprite if moving left
#some collision detection stuff here

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Deletes bullet if it leaves the screen.
