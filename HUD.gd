extends Control

var grass_cover = false
var tree_cover = false

var level_of_cover = 0

var vision_indicator_full = load("res://assets/vectors/vision-indicator-full.png")
var vision_indicator_semi = load("res://assets/vectors/vision-indicator-semi.png")
var vision_indicator_none = load("res://assets/vectors/vision-indicator-none.png")

func _ready():
	pass # Replace with function body.

func has_grass_cover(b):
	grass_cover = b
	update_vision_indicator()

func has_tree_cover(b):
	tree_cover = b
	update_vision_indicator()

func update_vision_indicator():
	if tree_cover:
		$VisionIndicator.texture = vision_indicator_none
		level_of_cover = 2
	elif grass_cover:
		$VisionIndicator.texture = vision_indicator_semi
		level_of_cover = 1
	else:
		$VisionIndicator.texture = vision_indicator_full
		level_of_cover = 0
