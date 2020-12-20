extends Area

var player
var exclamation_scene = load("res://Exclamation.tscn")

var state = "walking"

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	match state:
		"eating":
			eat()
		"walking":
			walk(delta)
		"fleeing":
			flee()

func _on_DangerTimer_timeout():
	if is_player_closeby():
		state = "fleeing"

func _on_ThinkTimer_timeout():
	if Global.randb():
		state = "eating"
	else:
		state = "walking"

func is_player_closeby():
	return player.translation.distance_to(translation) < 5

func eat():
	pass

func walk(delta):
	if $RayCastDownFront.is_colliding() :
		translate(Vector3(1,0,0) * delta)
	elif $TurnTimer.is_stopped():
		rotate_y(PI)
		$TurnTimer.start()

func flee():
	var exclamation = exclamation_scene.instance()
	add_child(exclamation)

func _on_Animal_body_entered(body):
	if body.name == "Player":
		player.win()
		queue_free()
