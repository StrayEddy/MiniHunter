extends Area

export (int) var standing_speed = 75
export (int) var crouching_speed = 50
export (int) var crawling_speed = 30

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.1

var velocity = 0

var is_standing = true
var is_crouching = false
var is_crawling = false
var is_aiming = false

var hud
var camera

func _ready():
	hud = get_tree().get_nodes_in_group("HUD")[0]
	camera = get_tree().get_nodes_in_group("Camera")[0]

func _physics_process(delta):
	if not is_aiming:
		get_movement_input(delta)
	get_other_input()

func get_movement_input(delta):
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
	if movement != 0:
		rotation_degrees += Vector3(0, camera.rotation_degrees.y + 90, 0)
	
	if movement > 0:
		var speed = 0
		if is_standing:
			speed = standing_speed
			walk()
		elif is_crouching:
			speed = crouching_speed
			crouch()
		elif is_crawling:
			speed = crawling_speed
			crawl()
		
		velocity = lerp(velocity, movement * speed, acceleration) * delta
	else:
		velocity = lerp(velocity, 0, friction) * delta
		if is_standing and $AnimationPlayer.current_animation != "Idle" and $IdleTimer.is_stopped():
			$IdleTimer.start()
	
	translate(Vector3(velocity, 0, 0))

func walk():
	if $AnimationPlayer.current_animation != "Walk":
		$AnimationPlayer.play("Walk")

func crouch():
	if $AnimationPlayer.current_animation != "CrouchWalk":
		$AnimationPlayer.play("CrouchWalk")

func crawl():
	if $AnimationPlayer.current_animation != "CrawlWalk":
		$AnimationPlayer.play("CrawlWalk")


func get_other_input():
	if Input.is_action_just_pressed("ui_select"):
		if is_crawling:
			get_in_stand_position()
		else:
			get_in_crawl_position()
	if Input.is_action_just_released("ui_accept"):
		if is_crouching:
			get_in_stand_position()
		else:
			get_in_crouch_position()
	if Input.is_action_just_pressed("ui_aim"):
		if is_aiming:
			stop_aim()
		else:
			aim()
	if Input.is_action_just_pressed("ui_shoot") and is_aiming:
		$Armature/Skeleton/BoneAttachment/Rifle.shoot()

func aim():
	is_aiming = true
	$Armature/Skeleton/BoneAttachment/Rifle.aim()
	if is_crawling:
		$AnimationPlayer.play("AimCrawl")
	else:
		$AnimationPlayer.play("Aim")

func stop_aim():
	is_aiming = false
	$Armature/Skeleton/BoneAttachment/Rifle.stop_aim()
	if is_crawling:
		$AnimationPlayer.play_backwards("AimCrawl")
	else:
		$AnimationPlayer.play_backwards("Aim")

func get_in_stand_position():
	if is_crouching:
		$AnimationPlayer.play_backwards("Crouch")
	elif is_crawling:
		$AnimationPlayer.play_backwards("Crawl")
	is_standing = true
	is_crouching = false
	is_crawling = false

func get_in_crouch_position():
	is_standing = false
	is_crouching = true
	is_crawling = false
	$AnimationPlayer.play("Crouch")

func get_in_crawl_position():
	is_standing = false
	is_crouching = false
	is_crawling = true
	$AnimationPlayer.play("Crawl")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "Aim" and anim_name != "AimCrawl" and anim_name != "Idle":
		if is_aiming and is_crawling:
			$AnimationPlayer.play("AimCrawl")
		elif is_aiming:
			$AnimationPlayer.play("Aim")

func win():
	print("I win")

func die():
	get_tree().reload_current_scene()

func _on_VisionTimer_timeout():
	var has_grass_cover = false
	var has_tree_cover = false
	
	for area in get_overlapping_areas():
		if "Grass" in area.name:
			has_grass_cover = true
			break
		if "Tree" in area.name:
			has_tree_cover = true
			break
	
	var level_of_cover = 0
	if is_crawling:
		level_of_cover = 2
	elif is_crouching:
		if has_tree_cover or has_grass_cover:
			level_of_cover = 2
		else:
			level_of_cover = 1
	else:
		if has_tree_cover:
			level_of_cover = 2
		elif has_grass_cover:
			level_of_cover = 1
		else:
			level_of_cover = 0
	
	hud.update_vision_indicator(level_of_cover)

func _on_IdleTimer_timeout():
	if not $AnimationPlayer.is_playing() and is_standing and not is_aiming:
		$AnimationPlayer.play("Idle")
