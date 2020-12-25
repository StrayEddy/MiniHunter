extends Area

var exclamation_scene = load("res://Exclamation.tscn")

var state = "walking"
var level_of_alert = 0
var walk_speed = 5
var flee_speed = 15

var player
var hud


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	hud = get_tree().get_nodes_in_group("HUD")[0]
	$Deer/AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

func _process(delta):
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
	if area.name == "Player":
		player.win()
		queue_free()

func _on_CalmTimer_timeout():
	if level_of_alert > 0:
		level_of_alert -= 1
