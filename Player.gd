extends Area

export (int) var speed = 200
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.1

var velocity = 0

var hud

func _ready():
	hud = get_tree().get_nodes_in_group("HUD")[0]

func get_input():
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	
	var dir = Vector2.ZERO
	
	var movement = 0
	if up or down or right or left:
		movement = 1
		if up:
			dir.x = 1
		elif down:
			dir.x = -1
		
		if right:
			dir.y = 1
		elif left:
			dir.y = -1
	
	match dir:
		Vector2(1,0):
			rotation_degrees = Vector3(0,0,0)
		Vector2(1,1):
			rotation_degrees = Vector3(0,-45,0)
		Vector2(0,1):
			rotation_degrees = Vector3(0,-90,0)
		Vector2(-1,1):
			rotation_degrees = Vector3(0,-135,0)
		Vector2(-1,0):
			rotation_degrees = Vector3(0,180,0)
		Vector2(-1,-1):
			rotation_degrees = Vector3(0,135,0)
		Vector2(0,-1):
			rotation_degrees = Vector3(0,90,0)
		Vector2(1,-1):
			rotation_degrees = Vector3(0,45,0)
	
	if movement > 0:
		velocity = lerp(velocity, movement * speed, acceleration)
		if $AnimationPlayer.current_animation != "Walk":
			$AnimationPlayer.play("Walk")
	else:
		velocity = lerp(velocity, 0, friction)
		if $AnimationPlayer.current_animation != "Idle":
			$AnimationPlayer.play("Idle")

func _physics_process(delta):
	get_input()
	velocity *= delta
	translate(Vector3(velocity, 0, 0))

func win():
	print("I win")

func die():
	get_tree().reload_current_scene()

func update_vision_indicators():
	var has_grass = false
	var has_tree = false
	
	for area in get_overlapping_areas():
		if "Grass" in area.name:
			has_grass = true
			break
		if "Tree" in area.name:
			has_tree = true
			break
	
	hud.has_grass_cover(has_grass)
	hud.has_tree_cover(has_tree)

func _on_VisionTimer_timeout():
	update_vision_indicators()
