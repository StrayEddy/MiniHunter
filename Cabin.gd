extends Spatial

var hud

func _ready():
	hud = get_tree().get_nodes_in_group("HUD")[0]

func _on_Cabin_area_entered(area):
	if area.name == "Player":
		$Action.show_action("A", "Shop", self, "shop")

func _on_Cabin_area_exited(area):
	if area.name == "Player":
		$Action.hide_action()

func shop():
	hud.show_shop()
