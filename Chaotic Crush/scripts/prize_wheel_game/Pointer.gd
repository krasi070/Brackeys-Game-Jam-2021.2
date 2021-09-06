extends Area2D

signal stopped

var played_anim: bool = false

onready var collision_shape := $CollisionShape2D
onready var anim_player := $AnimationPlayer


func _ready() -> void:
	collision_shape.disabled = true


func _input(event: InputEvent) -> void:
	if Manager.has_started and event.is_action_pressed("action") and not played_anim:
		played_anim = true
		AudioController.play_sfx(AudioController.WHEEL_STOP)
		var anim_duration: float = anim_player.get_animation("select").length
		var timer := get_tree().create_timer(anim_duration / 2)
		timer.connect("timeout", self, "_stop_wheel")
		anim_player.play("select")


func _stop_wheel() -> void:
	emit_signal("stopped")
	collision_shape.disabled = false
