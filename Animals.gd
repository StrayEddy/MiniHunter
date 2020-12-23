extends Spatial

export var max_number_of_animals = 30

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
	
#	var tiles = get_tree().get_nodes_in_group("Tile")
	
#	var rand_index = rng.randi_range(0, tiles.size()-1)
	
#	animal.translation = tiles[rand_index].translation
	animal.translation = Vector3(rand_range(-size/2, size/2), 0, rand_range(-size/2, size/2))
	add_child(animal)
	
	animal_count += 1
