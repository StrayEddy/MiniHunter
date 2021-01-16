extends Spatial

var hud
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = get_tree().get_nodes_in_group("HUD")[0]
	player = get_tree().get_nodes_in_group("Player")[0]


func get_level_of_alert():
	var alert_level = 0
	
	if hud.level_of_cover == 2:
		if distance_to_player() < 10: 
			alert_level = 3
		elif distance_to_player() < 20:
			alert_level = 2
		elif distance_to_player() < 30:
			alert_level = 1
	if hud.level_of_cover == 1:
		if distance_to_player() < 20: 
			alert_level = 3
		elif distance_to_player() < 30:
			alert_level = 2
		elif distance_to_player() < 40:
			alert_level = 1
	if hud.level_of_cover == 0:
		if distance_to_player() < 30: 
			alert_level = 3
		elif distance_to_player() < 40:
			alert_level = 2
		elif distance_to_player() < 50:
			alert_level = 1
	
	return alert_level

func distance_to_player():
	return player.translation.distance_to(translation)
