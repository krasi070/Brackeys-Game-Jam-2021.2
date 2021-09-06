extends Node

const BALL_MIN_X: float = 320.0
const BALL_MAX_X: float = 660.0

var relative_pos: float
var edges: Array

onready var ball := $Ball
onready var bar := $Bar
onready var course := $Course
onready var timer := $Timer


func _ready() -> void:
	set_level(Manager.game_levels[Manager.GOLF_GAME])
	ball.hide()
	bar.show()


func _input(event: InputEvent) -> void:
	if (Manager.has_started and 
		event.is_action_pressed("action") and 
		ball != null and
		not ball.play):
		AudioController.play_sfx(AudioController.GOLF_SWING)
		relative_pos = _calc_point()
		bar.hide()
		_play_ball()
		timer.stop()


func set_level(level: int) -> void:
	match level:
		1:
			edges = [0.9, 0.8, 0.2, 0.1]
			bar.slider_speed = 1750
		2:
			edges = [0.95, 0.875, 0.125, 0.05]
			bar.slider_speed = 2200
		3:
			edges = [0.975, 0.925, 0.075, 0.025]
			bar.slider_speed = 2500
		_:
			return


func _play_ball() -> void:
	ball.play = true
	var pos_x: float = _get_ball_start_pos_x()
	ball.position = Vector2(pos_x, ball.position.y)
	var target: Vector2 = _get_target_point()
	ball.from_to_positions = [ball.position, target]
	ball.show()


func _get_target_point() -> Vector2:
	if relative_pos >= edges[0]:
		return course.point_e.position
	if relative_pos >= edges[1]:
		return course.point_d.position
	if relative_pos >= edges[2]:
		return course.point_c.position
	if relative_pos >= edges[3]:
		return course.point_b.position
	return course.point_a.position


func _get_ball_start_pos_x() -> float:
	var distance: float = BALL_MAX_X - BALL_MIN_X
	var x: float = distance * relative_pos
	return BALL_MIN_X + x


func _calc_point() -> float:
	var distance: float = bar.SLIDER_MAX - bar.SLIDER_MIN
	var pos: float = bar.slider.position.x - bar.SLIDER_MIN
	return pos / distance
