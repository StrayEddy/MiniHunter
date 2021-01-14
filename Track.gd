extends Area

var default_mat = load("res://assets/models/Tracks_default.material")
var highlighted_mat = load("res://assets/models/Tracks_highlighted.material")

func setup(pos, target, is_blood):
	look_at_from_position(pos, target, Vector3.UP)
	if is_blood:
		$Blood.visible = true
		$Deer.visible = false
		$Rabbit.visible = false
	else:
		$Blood.visible = false
		$Deer.visible = true
		$Rabbit.visible = true

func highlight(b):
	if b:
		$Blood.mesh.surface_set_material(0, highlighted_mat)
		$Deer.mesh.surface_set_material(0, highlighted_mat)
		$Rabbit.mesh.surface_set_material(0, highlighted_mat)
	else:
		$Blood.mesh.surface_set_material(0, default_mat)
		$Deer.mesh.surface_set_material(0, default_mat)
		$Rabbit.mesh.surface_set_material(0, default_mat)

func _on_Track_area_entered(area):
	if area.name == "Player":
		$Action.show_action("A", "Follow", self, "follow")
		$Range.visible = true

func follow():
	for track in get_tree().get_nodes_in_group("Track"):
			if track.get_parent() == get_parent():
				track.highlight(true)
			else:
				track.highlight(false)


func _on_Track_area_exited(area):
	if area.name == "Player":
		$Action.hide_action()
		$Range.visible = false
