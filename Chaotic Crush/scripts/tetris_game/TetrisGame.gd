extends Node

const START_X: int = 358
const START_Y: int = 180
const BLOCK_DISTANCE: int = 20

var empty_column: int
var empty_col: int
var rng := RandomNumberGenerator.new()

onready var score_label := $ScoreLabel
onready var anim_player := $AnimationPlayer
onready var falling_piece := $FallingPiece
onready var pieces := [
	$BoardPiecesContainer/Piece1,
	$BoardPiecesContainer/Piece2,
	$BoardPiecesContainer/Piece3,
	$BoardPiecesContainer/Piece4,
	$BoardPiecesContainer/Piece5,
	$BoardPiecesContainer/Piece6,
	$BoardPiecesContainer/Piece7,
	$BoardPiecesContainer/Piece8,
	$BoardPiecesContainer/Piece9,
	$BoardPiecesContainer/Piece10,
]


func _ready() -> void:
	rng.randomize()
	empty_col = _select_column()
	set_level(Manager.game_levels[Manager.TETRIS_GAME])
	_position_falling_piece()


func set_level(level: int) -> void:
	match level:
		1:
			falling_piece.time_per_unit_fall = 0.5
		2:
			falling_piece.time_per_unit_fall = 0.375
		3:
			falling_piece.time_per_unit_fall = 0.25
		_:
			return


func _position_falling_piece() -> void:
	var rand_col: int = rng.randi_range(0, 9)
	falling_piece.col = rand_col
	falling_piece.empty_col = empty_col
	falling_piece.position = Vector2(START_X + rand_col * BLOCK_DISTANCE, START_Y)


func _select_column() -> int:
	var rand_col: int = rng.randi_range(0, 9)
	pieces[rand_col].hide()
	return rand_col


func _increase_score() -> void:
	score_label.text = """TOP
						1357428
						SCORE
						1357430

						NEXT"""


func _get_chaos_point() -> void:
	print("Chaos")
	Manager.get_chaos_point()


func _on_FallingPiece_placed():
	if falling_piece.row == 0:
		AudioController.play_sfx(AudioController.TETRIS)
		anim_player.play("tetris")
		_increase_score()
	elif falling_piece.row == 4:
		var timer := get_tree().create_timer(0.3)
		timer.connect("timeout", self, "_get_chaos_point")


func _on_AnimationPlayer_animation_finished(anim_name):
	print("Order")
	Manager.fail_chaos_point()
