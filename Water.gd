extends Area

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _on_Water_body_entered(body):
	player.die()
