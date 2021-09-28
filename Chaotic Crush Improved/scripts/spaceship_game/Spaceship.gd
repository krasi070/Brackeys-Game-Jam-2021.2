extends Area2D

signal crashed
signal lost_life

const MIN_X: int = 380
const MAX_X: int = 545
const MIN_Y: int = 140
const MAX_Y: int = 400

export var hor_speed: float
export var ver_speed: float

var lives: int = 3
var exploded: bool = false

onready var animated_sprite := $AnimatedSprite
onready var explode_animated_sprite := $ExplodeAnimatedSprite


func _ready() -> void:
	explode_animated_sprite.hide()
	animated_sprite.show()


func _process(delta: float) -> void:
	if Manager.has_started:
		if not animated_sprite.playing:
			animated_sprite.play("default")
		if not exploded:
			_handle_movement(delta)


func reset() -> void:
	animated_sprite.stop()
	animated_sprite.play("default")


func _handle_movement(delta: float) -> void:
	var x_pos: float = position.x
	var y_pos: float = position.y
	
	if Input.is_action_pressed("a"):
		x_pos -= delta * hor_speed
	if Input.is_action_pressed("d"):
		x_pos += delta * hor_speed
	if Input.is_action_pressed("w"):
		y_pos -= delta * ver_speed
	if Input.is_action_pressed("s"):
		y_pos += delta * ver_speed
	
	x_pos = clamp(x_pos, MIN_X, MAX_X)
	y_pos = clamp(y_pos, MIN_Y, MAX_Y)
	position = Vector2(x_pos, y_pos)


func _explode() -> void:
	exploded = true
	animated_sprite.stop()
	animated_sprite.hide()
	explode_animated_sprite.show()
	explode_animated_sprite.play("explode")
	emit_signal("crashed")
	var timer := get_tree().create_timer(0.5)
	timer.connect("timeout", self, "_get_chaos_point")


func _on_Spaceship_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacle"):
		AudioController.play_sfx(AudioController.CRASH)
		lives -= 1
		emit_signal("lost_life")
		if lives > 0:
			if area.has_method("destroy"):
				area.destroy()
		else:
			_explode()


func _get_chaos_point() -> void:
	Manager.get_chaos_point()
