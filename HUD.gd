extends Control

var level_of_cover = 0

var vision_indicator_full = load("res://assets/vectors/vision-indicator-full.png")
var vision_indicator_semi = load("res://assets/vectors/vision-indicator-semi.png")
var vision_indicator_none = load("res://assets/vectors/vision-indicator-none.png")

func _ready():
	pass # Replace with function body.

func update_vision_indicator(level_of_cover):
	self.level_of_cover = level_of_cover
	match self.level_of_cover:
		0: 
			$VisionIndicator.texture = vision_indicator_full
		1:
			$VisionIndicator.texture = vision_indicator_semi
		2:
			$VisionIndicator.texture = vision_indicator_none
