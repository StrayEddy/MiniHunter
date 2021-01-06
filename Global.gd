extends Node

var rng = RandomNumberGenerator.new()

var has_rifle1 = true
var has_rifle2 = false
var has_rifle3 = false

func _init():
	rng.randomize()

func randb():
	var b = true
	if randi() % 2:
		b = false
	return b
