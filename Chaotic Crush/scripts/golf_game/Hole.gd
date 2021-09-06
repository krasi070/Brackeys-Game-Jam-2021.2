extends Area2D


func _on_Hole_area_entered(area: Area2D) -> void:
	if area.is_in_group("ball"):
		AudioController.play_sfx(AudioController.GOLF_HIT)
		var timer := get_tree().create_timer(0.2)
		timer.connect("timeout", self, "_on_timeout")
		area.queue_free()


func _on_timeout() -> void:
	Manager.fail_chaos_point()
