extends Camera

var player
export var pos_diff = Vector3(0, 20, 20)

var rotation_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	move_camera(delta)

func move_camera(delta):
	var turn_left = Input.is_action_pressed("ui_cam_left")
	var turn_right = Input.is_action_pressed("ui_cam_right")
	
	if turn_left:
		pos_diff = pos_diff.rotated(Vector3.UP, -rotation_speed * delta)
	if turn_right:
		pos_diff = pos_diff.rotated(Vector3.UP, rotation_speed * delta)
	
	look_at_from_position(player.translation + pos_diff, player.translation, Vector3.UP)
