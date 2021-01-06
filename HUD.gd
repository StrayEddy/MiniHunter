extends Control

var level_of_cover = 0

var vision_indicator_full = load("res://assets/vectors/vision-indicator-full.png")
var vision_indicator_semi = load("res://assets/vectors/vision-indicator-semi.png")
var vision_indicator_none = load("res://assets/vectors/vision-indicator-none.png")

var nb_coins = 0

var is_shop_open = false

func _ready():
	$Shop.hide()

func update_vision_indicator(level_of_cover):
	self.level_of_cover = level_of_cover
	match self.level_of_cover:
		0: 
			$VisionIndicator.texture = vision_indicator_full
		1:
			$VisionIndicator.texture = vision_indicator_semi
		2:
			$VisionIndicator.texture = vision_indicator_none

func add_coins(nb):
	nb_coins += nb
	$Coins/Label.text = String(nb_coins)

func show_shop():
	is_shop_open = true
	$Shop.show()
	
	if Global.has_rifle1:
		$Shop/Rifle1.focus_mode = Control.FOCUS_NONE
		$Shop/Rifle1.modulate = Color(.5,.5,.5,1)
		$Shop/Rifle1/Price.hide()
		$Shop/Rifle1/Coin.hide()
	if Global.has_rifle2:
		$Shop/Rifle2.focus_mode = Control.FOCUS_NONE
		$Shop/Rifle2.modulate = Color(.5,.5,.5,1)
		$Shop/Rifle2/Price.hide()
		$Shop/Rifle2/Coin.hide()
	if Global.has_rifle3:
		$Shop/Rifle3.focus_mode = Control.FOCUS_NONE
		$Shop/Rifle3.modulate = Color(.5,.5,.5,1)
		$Shop/Rifle3/Price.hide()
		$Shop/Rifle3/Coin.hide()
	
	if not Global.has_rifle1:
		$Shop/Rifle1.grab_focus()
	elif not Global.has_rifle2:
		$Shop/Rifle2.grab_focus()
	elif not Global.has_rifle3:
		$Shop/Rifle3.grab_focus()
	
	get_tree().paused = true

func hide_shop():
	is_shop_open = false
	$Shop.hide()
	get_tree().paused = false

func _on_Rifle1_focus_entered():
	$Shop/Rifle1.modulate = Color(1,1,0,1)
func _on_Rifle1_focus_exited():
	$Shop/Rifle1.modulate = Color(1,1,1,1)

func _on_Rifle2_focus_entered():
	$Shop/Rifle2.modulate = Color(1,1,0,1)
func _on_Rifle2_focus_exited():
	$Shop/Rifle2.modulate = Color(1,1,1,1)

func _on_Rifle3_focus_entered():
	$Shop/Rifle3.modulate = Color(1,1,0,1)
func _on_Rifle3_focus_exited():
	$Shop/Rifle3.modulate = Color(1,1,1,1)

func _input(event):
	if is_shop_open:
		if event.is_action_pressed("ui_b"):
			get_tree().set_input_as_handled()
			hide_shop()
		if event.is_action_pressed("ui_a"):
			buy_selected_gun()

func buy_selected_gun():
	if $Shop/Rifle2.has_focus() and nb_coins >= int($Shop/Rifle2/Price.text):
		Global.has_rifle2 = true
		add_coins(-int($Shop/Rifle2/Price.text))
		show_shop()
	elif $Shop/Rifle3.has_focus() and nb_coins >= int($Shop/Rifle3/Price.text):
		Global.has_rifle3 = true
		add_coins(-int($Shop/Rifle3/Price.text))
		show_shop()
