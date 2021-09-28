extends Area2D

export var rotation_speed: float

var wait_timer: float = 0.6
var stop_timer: bool = false
var is_spinning: bool = true


func _process(delta: float) -> void:
	if is_spinning:
		_spin(delta)
	else:
		_decrease_wait_time(delta)


func _spin(delta: float) -> void:
	var amount_to_rotate: float = rotation_speed * delta
	rotate(deg2rad(amount_to_rotate))


func _decrease_wait_time(delta: float) -> void:
	wait_timer -= delta
	if wait_timer <= 0 and !stop_timer:
		stop_timer = true
		Manager.fail_chaos_point()


func _on_Pointer_stopped() -> void:
	is_spinning = false


func _on_Pointer_area_entered(area: Area2D) -> void:
	stop_timer = true
	var timer := get_tree().create_timer(0.5)
	timer.connect("timeout", self, "_get_chaos_point")


func _get_chaos_point() -> void:
	Manager.get_chaos_point()
