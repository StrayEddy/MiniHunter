extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func randb():
	var b = true
	if randi() % 2:
		b = false
	return b