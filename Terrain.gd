extends Spatial

var tree_scene = load("res://Tree.tscn")
var multigrass_scene = load("res://MultiGrass.tscn")

var foliage_center = Vector2(-250,-250)
var foliage_radius = 125

var player
var noise

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	
	noise = OpenSimplexNoise.new()
	noise.seed = Global.rng.randi()
	noise.octaves = 1
	noise.period = 20.0
	noise.persistence = 1.0
	
	build_foliage_around_player()

func build_foliage_around_player():
	var prev_foliage_center = foliage_center
	foliage_center = Vector2(player.transform.origin.x, player.transform.origin.z)
	
	remove_all_foliage_too_far_from_center(foliage_center)
	
	var min_x = foliage_center.x - foliage_radius
	var max_x = foliage_center.x + foliage_radius
	var min_y = foliage_center.y - foliage_radius
	var max_y = foliage_center.y + foliage_radius
	
	for x in range(min_x, max_x, 7):
		for y in range(min_y, max_y, 7):
			if not Geometry.is_point_in_circle(Vector2(x,y), foliage_center, foliage_radius):
				continue
			elif Geometry.is_point_in_circle(Vector2(x,y), prev_foliage_center, foliage_radius):
				continue
			else:
				var value = noise.get_noise_2d(float(x), float(y))
				if value > 0:
					add_multigrass(x + randf()*7, y + randf()*7)
					if value > 0.4:
						add_tree(x + randf()*7, y + randf()*7)
	
	print("-------")
	print($Grasses.get_child_count())
	print($Trees.get_child_count())

func remove_all_foliage_too_far_from_center(center):
	for grass in $Grasses.get_children():
		var grass_center = Vector2(grass.transform.origin.x, grass.transform.origin.z)
		if not Geometry.is_point_in_circle(grass_center, center, foliage_radius):
			grass.queue_free()
	
	for tree in $Trees.get_children():
		var tree_center = Vector2(tree.transform.origin.x, tree.transform.origin.z)
		if not Geometry.is_point_in_circle(tree_center, center, foliage_radius):
			tree.queue_free()

func add_multigrass(x,z):
	var multigrass = multigrass_scene.instance()
	multigrass.translate(Vector3(x, 0, z))
	multigrass.rotate_y(Global.randrad())
	$Grasses.add_child(multigrass)

func add_tree(x,z):
	var tree = tree_scene.instance()
	tree.translate(Vector3(x, 0, z))
	tree.rotate_y(Global.randrad())
	$Trees.add_child(tree)

func _on_FoliageTimer_timeout():
	build_foliage_around_player()
