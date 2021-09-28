extends Area2D

export var speed: float = 200
export var start_scale: float
export var end_scale: float

var time: float = 0
var play: bool
var stop: bool = false
var from_to_positions: Array

onready var sprite := $Sprite
onready var collision_shape := $CollisionShape2D
onready var anim_player := $AnimationPlayer


func _ready() -> void:
	anim_player.play("roll")


func _process(delta: float) -> void:
	if play and !stop:
		time += delta * speed
		# Move
		var from: Vector2 = from_to_positions[0]
		var to: Vector2 = from_to_positions[1]
		position = from.linear_interpolate(to, time)
		# Decrease scale
		var start: Vector2 = Vector2(start_scale, start_scale)
		var end: Vector2 = Vector2(end_scale, end_scale)
		var scale: Vector2 = start.linear_interpolate(end, time)
		sprite.scale = scale
		collision_shape.scale = scale


func _on_Ball_area_entered(area: Area2D) -> void:
	if area.is_in_group("wall"):
		AudioController.play_sfx(AudioController.GOLF_HIT)
		stop = true
		anim_player.stop()
		Manager.get_chaos_point()
