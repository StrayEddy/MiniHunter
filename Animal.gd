extends Area

var exclamation_scene = load("res://Exclamation.tscn")
var track_scene = load("res://Track.tscn")

var state = "walking"
var level_of_alert = 0
var walk_speed = 5
var flee_speed = 15
var health_points = 1.0 + Global.rng.randf() / 3

var is_injured = false
var is_dead = false

var player
var hud
var animals

var path_of_tracks = Path.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	hud = get_tree().get_nodes_in_group("HUD")[0]
	animals = get_parent()
	$Deer/AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	build_path_of_tracks()

func build_curve():
	var curve = Curve3D.new()
	var nb_points = 5 + Global.rng.randi()%3
	var min_x = 0
	var max_x = 100
	var min_z = -25
	var max_z = 25
	
	for i in range(0, nb_points):
		var x = (i+1) * ((max_x - min_x) / nb_points)
		var z = min_z + Global.rng.randf() * max_z
		var point = Vector3(x, 0.1, z)
		curve.add_point(point)
	return curve

func build_path_of_tracks():
	var curve = build_curve()
	for i in range(0, curve.get_point_count()):
		var pos = curve.get_point_position(i)
		var angle
		if i == curve.get_point_count() - 1:
			angle = rotation.y
		else:
			var next_pos = curve.get_point_position(i+1)
			angle = atan2(next_pos.z - pos.z, next_pos.x - pos.x)
		add_track_at(pos, angle, false)
	
	path_of_tracks.curve = curve
	path_of_tracks.translation = self.translation
	path_of_tracks.rotate_y(self.rotation.y) 
	animals.add_child(path_of_tracks)

func add_track_at(point, angle, is_blood):
	var track = track_scene.instance()
	track.setup(point, angle, is_blood)
	path_of_tracks.add_child(track)

func _process(delta):
	if not is_dead:
		if state == "walking":
			move(walk_speed*delta)
		elif state == "fleeing":
			move(flee_speed*delta)

func move(speed):
	translate(Vector3(1,0,0) * speed)

func _on_DangerTimer_timeout():
	var new_alert_level = 0
	
	if hud.level_of_cover == 2:
		if distance_to_player() < 10: 
			new_alert_level = 3
		elif distance_to_player() < 20:
			new_alert_level = 2
		elif distance_to_player() < 30:
			new_alert_level = 1
	if hud.level_of_cover == 1:
		if distance_to_player() < 20: 
			new_alert_level = 3
		elif distance_to_player() < 30:
			new_alert_level = 2
		elif distance_to_player() < 40:
			new_alert_level = 1
	if hud.level_of_cover == 0:
		if distance_to_player() < 30: 
			new_alert_level = 3
		elif distance_to_player() < 40:
			new_alert_level = 2
		elif distance_to_player() < 50:
			new_alert_level = 1
	
	if new_alert_level > level_of_alert:
		level_of_alert = new_alert_level
	
	if level_of_alert == 0:
		eat()
	elif level_of_alert == 1:
		check()
	elif level_of_alert == 2:
		walk()
	elif level_of_alert >= 3:
		level_of_alert = 3
		flee()

func update_rotation():
	var forward = global_transform.basis.x.normalized()
	var diff = (self.translation - player.translation).normalized()
	var angle =  Vector2(diff.x, diff.z).angle_to(Vector2(forward.x, forward.z))
	rotate_y(angle)
	
func distance_to_player():
	return player.translation.distance_to(translation)

func eat():
	state = "eating"
	if $Deer/AnimationPlayer.current_animation != "Eat":
		$Deer/AnimationPlayer.play("Eat")
		$Exclamation.visible = false

func check():
	state = "checking"
	if $Deer/AnimationPlayer.current_animation != "Idle":
		$Deer/AnimationPlayer.play("Idle")
		$Exclamation.visible = true

func walk():
	state = "walking"
	if $Deer/AnimationPlayer.current_animation != "Walk":
		$Deer/AnimationPlayer.play("Walk")
		$Exclamation.visible = true
		update_rotation()

func flee():
	state = "fleeing"
	if $Deer/AnimationPlayer.current_animation != "Jump" and $Deer/AnimationPlayer.current_animation != "Fall":
		$Deer/AnimationPlayer.play("Jump")
		$Exclamation.visible = true
		update_rotation()

func on_animation_finished(anim_name):
	if anim_name == "Jump":
		$Deer/AnimationPlayer.play_backwards("Fall")
	elif anim_name == "Fall" and state == "fleeing":
		$Deer/AnimationPlayer.play("Jump")

func _on_Animal_area_entered(area):
	if is_dead and area.name == "Player":
		$Action.show_action("A", "Retrieve", self, "retrieved")

func _on_Animal_area_exited(area):
	if is_dead and area.name == "Player":
		$Action.hide_action()

func _on_CalmTimer_timeout():
	if level_of_alert > 0:
		level_of_alert -= 1

func shot(damage):
	is_injured = true
	lose_health(damage)
	$InjuryTimer.start()
	level_of_alert = 4

func lose_health(points):
	health_points -= points
	var blood_pos = translation - path_of_tracks.translation + Vector3(0,.1,0)
	add_track_at(blood_pos, rotation.y, true)
	if health_points <= 0:
		die()

func die():
	is_dead = true
	$Deer/AnimationPlayer.play("Die")
	$DangerTimer.queue_free()
	$CalmTimer.queue_free()
	$InjuryTimer.queue_free()
	$Exclamation.queue_free()
	$RayCastDownFront.queue_free()

func retrieved():
	player.retrieve_animal(100)
	queue_free()

func _on_InjuryTimer_timeout():
	lose_health(.5)
