extends Camera

var player
export var pos_diff = Vector3(-20, 20, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	look_at_from_position(player.translation + pos_diff, player.translation, Vector3.UP)
