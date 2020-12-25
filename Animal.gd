extends Area

var exclamation_scene = load("res://Exclamation.tscn")

var state = "walking"

var player
var tiles

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	if state == "walking":
		move(delta)

func move(delta):
	if $RayCastDownFront.is_colliding() :
		translate(Vector3(1,0,0) * delta)
	elif $TurnTimer.is_stopped():
		rotate_y(PI)
		$TurnTimer.start()

func _on_DangerTimer_timeout():
	if is_player_closeby():
		check()

func _on_ThinkTimer_timeout():
	if is_player_closeby():
		flee()
	elif randi() % 4 < 2:
		eat()
	else:
		walk()

func is_player_closeby():
	return player.translation.distance_to(translation) < 5

func eat():
	state = "eating"
	$Deer/AnimationPlayer.play("Eat")

func walk():
	state = "walking"
	$Deer/AnimationPlayer.play("Walk")

func check():
	state = "checking"
	$Deer/AnimationPlayer.play("Idle")
	var exclamation = exclamation_scene.instance()
	add_child(exclamation)

func flee():
	pass
#	var tile = tiles.get_escape_tile()
#	jump_on(tile)

func jump_on(tile):
	var path = Path.new()
	var curve = Curve3D.new()
	curve.add_point(translation)
	curve.add_point(tile.translation)
	path.curve = curve
	

func _on_Animal_area_entered(area):
	if area.name == "Player":
		player.win()
		queue_free()
