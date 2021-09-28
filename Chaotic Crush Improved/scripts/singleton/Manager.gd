extends Node

signal began_transition

enum State {
	TITLE_SCREEN,
	INTRO, 
	MINIGAMES,
	CHAOS_END,
	ORDER_END
}

const STARTING_CHAOS_POINTS: int = 5
const MIN_LEVEL: int = 1
const MAX_LEVEL: int = 3

const MAIN_SCENE: String = "res://resources/scenes/VisualNovelScene.tscn"
const TITLE_SREEN_SCENE: String = "res://resources/scenes/TitleScreen.tscn"
const CHAOS_END_SCENE: String = "res://resources/scenes/ChaosEnd.tscn"
const SPACESHIP_GAME: String = "res://resources/scenes/spaceship_game/SpaceshipGame.tscn"
const PRIZE_WHEEL_GAME: String = "res://resources/scenes/prize_wheel_game/PrizeWheelGame.tscn"
const GOLF_GAME: String = "res://resources/scenes/golf_game/GolfGame.tscn"
const ALPHABET_GAME: String = "res://resources/scenes/alphabet_game/AlphabetGame.tscn"
const TETRIS_GAME: String = "res://resources/scenes/tetris_game/TetrisGame.tscn"
const FROG_GAME: String = "res://resources/scenes/frog_game/FrogGame.tscn"

const END_MINI_GAME_WAIT_TIME: float = 1.0

var state

var chaos_points: int = STARTING_CHAOS_POINTS setget _set_chaos_points
var curr_game: String
var last_order_or_chaos: String
var given_chaos_points: int = 0

var end_mini_game_timer: float = 0
var first_scene_played: bool = false
var has_started: bool

var is_transitioning: bool = false
var transition_text: String = ""
var transition_to_scene: String

var rng = RandomNumberGenerator.new()

var queue: Array
var games: Array = [
	SPACESHIP_GAME,
	PRIZE_WHEEL_GAME,
	GOLF_GAME,
	ALPHABET_GAME,
	TETRIS_GAME,
	FROG_GAME,
]

var game_levels: Dictionary = {
	SPACESHIP_GAME: MIN_LEVEL,
	PRIZE_WHEEL_GAME: MIN_LEVEL,
	GOLF_GAME: MIN_LEVEL,
	ALPHABET_GAME: MIN_LEVEL,
	TETRIS_GAME: MIN_LEVEL,
	FROG_GAME: MIN_LEVEL,
}

var transition_texts: Dictionary = {
	"chaos": "chaos",
	"order": "order",
	SPACESHIP_GAME: "spaceship  race",
	GOLF_GAME: "golf",
	ALPHABET_GAME: "alphabet",
	PRIZE_WHEEL_GAME: "spin  to  win",
	TETRIS_GAME: "block  game",
	FROG_GAME: "poor  froggy",
	CHAOS_END_SCENE: "chaos end",
	TITLE_SREEN_SCENE: "game over",
}


func _ready() -> void:
	state = State.TITLE_SCREEN
	rng.randomize()
	_queue_games(100)


func _process(delta: float) -> void:
	if end_mini_game_timer > 0:
		end_mini_game_timer -= delta


func get_chaos_point() -> void:
	if end_mini_game_timer > 0:
		return
	end_mini_game_timer = END_MINI_GAME_WAIT_TIME
	chaos_points += game_levels[curr_game]
	given_chaos_points = game_levels[curr_game]
	game_levels[curr_game] = clamp(game_levels[curr_game] + 1, MIN_LEVEL, MAX_LEVEL)
	last_order_or_chaos = "chaos"
	begin_transition(MAIN_SCENE, transition_texts["chaos"])


func fail_chaos_point() -> void:
	if end_mini_game_timer > 0:
		return
	end_mini_game_timer = END_MINI_GAME_WAIT_TIME
	chaos_points -= 1
	given_chaos_points = 0
	last_order_or_chaos = "order"
	begin_transition(MAIN_SCENE, transition_texts["order"])


func timeout() -> void:
	if end_mini_game_timer > 0:
		return
	if curr_game == FROG_GAME:
		fail_chaos_point()
		return
	end_mini_game_timer = END_MINI_GAME_WAIT_TIME
	chaos_points -= 1
	given_chaos_points = 0
	last_order_or_chaos = "time"
	begin_transition(MAIN_SCENE, transition_texts["order"])


func next_game() -> void:
	state = State.MINIGAMES
	if queue.size() == 0:
		_queue_games(100)
	curr_game = queue.pop_front()
	has_started = false
	begin_transition(curr_game)


func get_reply() -> Array:
	match state:
		State.INTRO:
			if Replies.INTRO_TEXT.size() == 0:
				return [Replies.TRY_OVER_REPLY]
			return Replies.INTRO_TEXT
		State.MINIGAMES:
			return [Replies.get_random_reply(curr_game, last_order_or_chaos)]
		State.CHAOS_END:
			return Replies.CHAOS_TEXT.duplicate(true)
		State.ORDER_END:
			return Replies.ORDER_TEXT.duplicate(true)
		_:
			return Replies.DEFAULT_REPLY.duplicate(true)


func end_transition() -> void:
	is_transitioning = false


func is_transitioning() -> bool:
	return is_transitioning


func begin_transition(to_scene: String, t_text: String = "") -> void:
	if not is_transitioning:
		is_transitioning = true
		transition_to_scene = to_scene
		if t_text == "":
			transition_text = transition_texts[to_scene]
		else:
			transition_text = t_text
		emit_signal("began_transition")


func go_to_chaos_end() -> void:
	state = State.CHAOS_END


func go_to_order_end() -> void:
	state = State.ORDER_END


func show_chaos_end() -> void:
	begin_transition(CHAOS_END_SCENE)


func show_order_end() -> void:
	state = State.TITLE_SCREEN
	chaos_points = STARTING_CHAOS_POINTS
	last_order_or_chaos = ""
	given_chaos_points = 0
	begin_transition(TITLE_SREEN_SCENE)


func _set_chaos_points(points: int) -> void:
	chaos_points = clamp(points, 0, 100)


func _queue_games(amount: int) -> void:
	var unselected: Array = _get_unselected_array()
	for i in amount:
		if unselected.size() < 1:
			unselected = _get_unselected_array()
		var rand_index: int = rng.randi_range(0, unselected.size() - 1)
		queue.append(games[unselected[rand_index]])
		unselected.remove(rand_index)


func _get_unselected_array() -> Array:
	var unselected: Array
	for i in games.size():
		unselected.append(i)
	return unselected
