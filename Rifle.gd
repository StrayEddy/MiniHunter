extends Spatial

var damage = .5
var accuracy = .3
var firerange = .6

var wobble_sign = 1

var is_wobbling = false
var is_reloading = false

func aim():
	$RayCast.show()
	$RayCast.enabled = true
	is_wobbling = true
	wobble()

func wobble():
	if is_wobbling:
		var old_rotation_degrees = $RayCast.rotation_degrees
		var new_rotation_degrees = Vector3(0, wobble_sign * 5, 0)
		$RayCast/WobbleTween.interpolate_property($RayCast, "rotation_degrees", 
		old_rotation_degrees, new_rotation_degrees, 1 + randf(), Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$RayCast/WobbleTween.start()

func stop_aim():
	$RayCast.hide()
	$RayCast.enabled = false
	is_wobbling = false

func _on_WobbleTween_tween_completed(object, key):
	wobble_sign *= -1
	wobble()

func shoot():
	if not is_reloading:
		$GunFire.emitting = true
		$ReloadTimer.start()
		is_reloading = true
		
		var animal = $RayCast.get_collider()
		if animal != null:
			animal.shot(damage)

func _on_ReloadTimer_timeout():
	is_reloading = false
