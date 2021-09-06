extends Area2D

const STEP: int = 64
const MIN_ROW: int = 0
const MIN_COL: int = 0
const MAX_ROW: int = 7
const MAX_COL: int = 14

const START_X: float = 32.0
const START_Y: float = 508.0

var rng := RandomNumberGenerator.new()
var row := 0
var col := 0
var ran_over: bool = false

onready var sprite := $Sprite
onready var ran_over_sprite := $RanOverSprite


func _ready():
	rng.randomize()
	_set_random_pos()
	sprite.show()
	ran_over_sprite.hide()


func _input(event: InputEvent) -> void:
	if not ran_over and Manager.has_started:
		_handle_movement(event)


func _handle_movement(event: InputEvent) -> void:
	if event.is_action_pressed("a") and col > MIN_COL:
		position -= Vector2(STEP, 0)
		col -= 1
	if event.is_action_pressed("s") and row > MIN_ROW:
		position += Vector2(0, STEP)
		row -= 1
	if event.is_action_pressed("d") and col < MAX_COL:
		position += Vector2(STEP, 0)
		col += 1
	if event.is_action_pressed("w") and row < MAX_ROW:
		position -= Vector2(0, STEP)
		row += 1


func _set_random_pos() -> void:
	row = rng.randi_range(MIN_ROW, MIN_ROW + 1)
	col = rng.randi_range(MIN_COL, MAX_COL)
	var x: float = START_X + col * STEP
	var y: float = START_Y - row * STEP
	position = Vector2(x, y)


func _on_Frog_area_entered(area: Area2D) -> void:
	if area.is_in_group("car"):
		AudioController.play_sfx(AudioController.RUN_OVER)
		ran_over = true
		sprite.hide()
		ran_over_sprite.show()
		var timer := get_tree().create_timer(0.3)
		timer.connect("timeout", self, "_get_chaos_point")


func _get_chaos_point() -> void:
	Manager.get_chaos_point()
