extends Node

export(float, 0.01, 1) var time_per_unit_fall 

const COLUMNS: int = 10
const ROWS: int = 20

var timer: float = 0
var placed: bool = false

# Used for waiting for completed row animation to finish and
# resume dropping pieces
var wait_timer: float = 0

var rng := RandomNumberGenerator.new()

var grid: Array
var dict: Dictionary
var next_pieces: Array = []
var curr_piece: Node2D
var stop_spawning: bool = false # Used to determine whether the mini-game should end

onready var pieces: Array = [
	preload("res://resources/scenes/tetris_game/objects/LongPiece.tscn"),
	preload("res://resources/scenes/tetris_game/objects/TPiece.tscn"),
	preload("res://resources/scenes/tetris_game/objects/JPiece.tscn"),
	preload("res://resources/scenes/tetris_game/objects/LPiece.tscn"),
	preload("res://resources/scenes/tetris_game/objects/OPiece.tscn"),
	preload("res://resources/scenes/tetris_game/objects/SPiece.tscn"),
	preload("res://resources/scenes/tetris_game/objects/ZPiece.tscn"),
]

onready var ui_timer := $Timer
onready var score_label := $ScoreLabel
onready var piece_container := $PieceContainer


func _ready() -> void:
	_init_grid()
	randomize()
	rng.randomize()
	set_level(Manager.game_levels[Manager.TETRIS_GAME])
	spawn_new_piece()


func set_level(level: int) -> void:
	match level:
		1:
			time_per_unit_fall = 0.12
			ui_timer.timer = 12
		2:
			time_per_unit_fall = 0.1
			ui_timer.time = 9
		3:
			time_per_unit_fall = 0.05
			ui_timer.time = 6
		_:
			return


func _process(delta: float) -> void:
	if not Manager.has_started:
		return
	if wait_timer > 0:
		wait_timer -= delta
		if wait_timer <= 0:
			Manager.fail_chaos_point()
		return
	timer += delta
	if timer >= time_per_unit_fall and curr_piece != null:
		var dropped: bool = curr_piece.drop(grid)
		if not dropped:
			AudioController.play_sfx(AudioController.PIECE_PLACE)
			place_in_grid()
			check_for_completed_rows()
			if stop_spawning:
				curr_piece = null
			else:
				spawn_new_piece()
		timer = 0


func _input(event: InputEvent) -> void:
	if curr_piece != null and Manager.has_started:
		if event.is_action_pressed("a"):
			AudioController.play_sfx(AudioController.PIECE_MOVE)
			curr_piece.move(Vector2.LEFT, grid)
		if event.is_action_pressed("d"):
			AudioController.play_sfx(AudioController.PIECE_MOVE)
			curr_piece.move(Vector2.RIGHT, grid)


func _increase_score(cleared_rows: int) -> void:
	var curr_score: int = 1357420
	var multiplier: int = 20
	var points_per_cleared_rows: Array = [40, 100, 300, 1200]
	var new_score: int = curr_score + (points_per_cleared_rows[cleared_rows - 1] * multiplier)
	score_label.text = """TOP
						1357428
						SCORE
						%d""" % (new_score)


func place_in_grid() -> void:
	for block in curr_piece.blocks:
		grid[block.grid_pos.y][block.grid_pos.x] = true
		dict[Vector2(block.grid_pos.x, block.grid_pos.y)] = block
		if block.grid_pos.y + 1 > block.MAX_VISIBLE_Y:
			stop_spawning = true
			yield(get_tree().create_timer(0.3), "timeout")
			Manager.get_chaos_point()
			return


func spawn_new_piece() -> void:
	var col: int = rng.randi_range(1, 8)
	if next_pieces.size() == 0:
		prepare_next_pieces_arr()
	curr_piece = pieces[next_pieces.pop_front()].instance()
	piece_container.add_child(curr_piece)
	curr_piece.set_pos(Vector2(col, 16))


func prepare_next_pieces_arr() -> void:
	for i in range(pieces.size()):
		next_pieces.append(i)
	next_pieces.shuffle()


func check_for_completed_rows() -> void:
	var completed_rows: int = 0
	for row in range(ROWS):
		if _is_row_completed(row):
			stop_spawning = true
			completed_rows += 1
			var anim_duration: float = _destroy_completed_row(row)
			if wait_timer <= 0:
				wait_timer = anim_duration
		elif completed_rows > 0:
			# To do add a dictionary to remember their drop by amount
			_drop_blocks_above_destroyed_row(row, completed_rows, wait_timer)
	if completed_rows > 0:
		AudioController.play_sfx(AudioController.TETRIS)
		_increase_score(completed_rows)


func _is_row_completed(row: int) -> bool:
	for col in range(COLUMNS):
		if not grid[row][col]:
			return false
	return true


# Returns destroy animation duration in seconds
func _destroy_completed_row(row: int) -> float:
	var anim_duration: float = 0
	for col in range(COLUMNS):
		var key: Vector2 = Vector2(col, row)
		dict[key].destroy()
		anim_duration = dict[key].anim_player.current_animation_length
		dict.erase(key)
		grid[row][col] = false
	return anim_duration


func _drop_blocks_above_destroyed_row(row: int, drop_by: int, wait_time: float) -> void:
	yield(get_tree().create_timer(wait_time), "timeout")
	for col in range(COLUMNS):
		# In Godot up is -1 for y
		var key: Vector2 = Vector2(col, row)
		if dict.has(key):
			grid[row][col] = false
			var block = dict[key]
			block.grid_pos += Vector2.UP * drop_by
			dict.erase(key)
			dict[Vector2(block.grid_pos.x, block.grid_pos.y)] = block
			grid[row - drop_by][col] = true


func _init_grid() -> void:
	for row in range(ROWS):
		grid.append([])
		for col in range(COLUMNS):
			grid[row].append(false)
