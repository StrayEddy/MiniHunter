extends KinematicBody

export (int) var speed = 10
export (int) var jump_speed = 15
export (int) var gravity = 20
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.1

var velocity = Vector3.ZERO

func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
func _physics_process(delta):
	get_input()
	if not $RayCast.is_colliding():
		velocity.y -= gravity * delta
	elif velocity.y < .1:
		velocity.y = 0
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if $RayCast.is_colliding() and Input.is_action_just_pressed("ui_up"):
		velocity.y += jump_speed
	
	check_collisions()

func check_collisions():
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)

func win():
	print("I win")

func die():
	get_tree().reload_current_scene()
