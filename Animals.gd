extends Spatial

export var max_number_of_animals = 100

var animal_scene = load("res://Animal.tscn")
var rng = RandomNumberGenerator.new()

var animal_count = 0

var size = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func _process(delta):
	if animal_count < max_number_of_animals:
		add_animal()

func add_animal():
	var animal = animal_scene.instance()
	animal.translation = Vector3(rand_range(-size/2, size/2), 0, rand_range(-size/2, size/2))
	add_child(animal)
	
	animal_count += 1
