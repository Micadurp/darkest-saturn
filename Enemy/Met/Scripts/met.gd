extends CharacterBody2D

@export var speed : float = 120
@export var active_box : CollisionShape2D
@export var sprite : Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@export var sound : AudioStreamPlayer2D
@export var hp : int = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# true for right, false for left
var moving_direction : bool = true
var facing : bool = false
var state = "inactive"
var inactive_timer = 60
var active_timer = 20
var delay_timer = 30
var dir : int
var bullets_fired : int = 0

func _ready():
	#animation_tree.active = true
	pass

func _physics_process(_delta):
	if hp < 1:
		queue_free()
	if facing == true:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	match state:
		"active":
			if inactive_timer > 0:
				inactive_timer -= 1
				return
			else:
				remove_from_group("Deflect")
				add_to_group("Enemy")
				if facing == true:
					speed = 60
				else:
					speed = -60
				if bullets_fired >= 3:
					if delay_timer > 0:
						delay_timer -= 1
					else:
						state = "inactive"
						delay_timer = 0
				else:
					if active_timer > 0:
						active_timer -=1
					else:
						fire(3.14)
						bullets_fired += 1
						active_timer = 20
		"inactive":
			remove_from_group("Enemy")
			add_to_group("Deflect")
		_:
			pass
	
	if is_on_floor():
		pass
	else:
		velocity.y += gravity
	
	move_and_slide()



func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("eek!")
		if body.position.x <= position.x:
			print("left")
			facing = false
		else:
			print("right")
			facing = true
		state = "active"
		sound.play(0)


func _on_hurtbox_area_entered(area):
	if area.is_in_group("Bullets") and state == "active":
		hp -= 1

func fire(angle):
	var direction = Vector2(1.0,0.0).rotated(angle).normalized()
	var bullet = load("res://Enemy/Met/MetBullet.tscn").instantiate()
	bullet.direction = direction
	get_parent().add_child(bullet)
	if facing == true:
		dir = 1
	else:
		dir = -1
	bullet.position = position + Vector2(dir*1, 0)
