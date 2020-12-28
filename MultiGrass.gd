extends Area

# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_y(Global.rng.randi()%360)
