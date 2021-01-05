extends Area

var default_mat = load("res://assets/models/Tracks_default.material")
var highlighted_mat = load("res://assets/models/Tracks_highlighted.material")

func highlight(b):
	if b:
		$Mesh.mesh.surface_set_material(0, highlighted_mat)
	else:
		$Mesh.mesh.surface_set_material(0, default_mat)

func _on_Track_area_entered(area):
	if area.name == "Player":
		$Action.show_action("A", "Follow", self, "follow")

func follow():
	for track in get_tree().get_nodes_in_group("Track"):
			if track.get_parent() == get_parent():
				track.highlight(true)
			else:
				track.highlight(false)


func _on_Track_area_exited(area):
	if area.name == "Player":
		$Action.hide_action()
