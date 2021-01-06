extends Spatial

var is_shown = false
var camera

var button = ""
var label = ""
var callback_object = null
var callback_method = ""

func _ready():
	camera = get_tree().get_nodes_in_group("Camera")[0]
	hide_all()

func _process(delta):
	if is_shown:
		look_at(camera.translation, Vector3.UP)
		if button == "A" and Input.is_action_just_pressed("ui_a"):
			callback_object.call(callback_method)
		elif button == "B" and Input.is_action_just_pressed("ui_b"):
			callback_object.call(callback_method)
		elif button == "X" and Input.is_action_just_pressed("ui_x"):
			callback_object.call(callback_method)
		elif button == "Y" and Input.is_action_just_pressed("ui_y"):
			callback_object.call(callback_method)

func hide_all():
	for button in $Buttons.get_children():
		button.hide()
	for label in $Labels.get_children():
		label.hide()

func show_action(button, label, object, method):
	self.button = button
	self.label = label
	self.callback_object = object
	self.callback_method = method
	
	hide_all()
	is_shown = true
	show()
	
	match button:
		"A":
			$Buttons/A.show()
		"B":
			$Buttons/B.show()
		"X":
			$Buttons/X.show()
		"Y":
			$Buttons/Y.show()
	
	match label:
		"Follow":
			$Labels/Follow.show()
		"Retrieve":
			$Labels/Retrieve.show()
		"Shop":
			$Labels/Shop.show()

func hide_action():
	is_shown = false
	hide()
