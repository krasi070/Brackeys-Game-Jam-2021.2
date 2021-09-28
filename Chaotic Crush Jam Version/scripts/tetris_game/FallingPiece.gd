extends Sprite

signal placed

export var time_per_unit_fall: float = 0.5

const BLOCK_DISTANCE: int = 20

var timer: float
var col: int
var row: int = 12
var empty_col: int
var placed: bool = false


func _process(delta: float) -> void:
	if Manager.has_started and not placed:
		timer += delta
		if timer >= time_per_unit_fall:
			position += Vector2(0, BLOCK_DISTANCE)
			row -= 1
			timer = 0
			if row < 4 and col != empty_col:
				var diff = 4 - row
				position -= Vector2(0, diff * BLOCK_DISTANCE)
				row = 4
			if row == 0 or (row == 4 and col != empty_col):
				placed = true
				emit_signal("placed")


func _input(event: InputEvent) -> void:
	if Manager.has_started and not placed and row > 3:
		if event.is_action_pressed("a") and col > 0:
			AudioController.play_sfx(AudioController.PIECE_MOVE)
			position -= Vector2(BLOCK_DISTANCE, 0)
			col -= 1
		if event.is_action_pressed("d") and col < 9: 
			AudioController.play_sfx(AudioController.PIECE_MOVE)
			position += Vector2(BLOCK_DISTANCE, 0)
			col += 1
