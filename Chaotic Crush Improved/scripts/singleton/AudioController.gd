extends Node

const GOLF_HIT: String = "golf_hit"
const GOLF_SWING: String = "golf_swing"
const RUN_OVER: String = "run_over"
const CRASH: String = "crash"
const SPEECH_BUBBLE: String = "speech_bubble"
const TETRIS: String = "tetris"
const PIECE_MOVE: String = "piece_move"
const PIECE_PLACE: String = "piece_place"
const TIMER: String = "timer"
const WHEEL_STOP: String = "wheel_stop"

const MUSIC := preload("res://resources/audio/music_loop.wav")
const SFX: Dictionary = {
	GOLF_HIT: preload("res://resources/audio/golf_hit.wav"),
	GOLF_SWING: preload("res://resources/audio/golf_swing.wav"),
	RUN_OVER: preload("res://resources/audio/run_over.wav"),
	CRASH: preload("res://resources/audio/spaceship_crash.wav"),
	SPEECH_BUBBLE: preload("res://resources/audio/speech_bubble_2.wav"),
	TETRIS: preload("res://resources/audio/tetris.wav"),
	PIECE_MOVE: preload("res://resources/audio/tetris_move.mp3"),
	PIECE_PLACE: preload("res://resources/audio/tetris_place1.wav"),
	TIMER: preload("res://resources/audio/timer_2.wav"),
	WHEEL_STOP: preload("res://resources/audio/wheel_stop.wav")
}

const VOLUME_FIXER: Dictionary = {
	GOLF_HIT: 0,
	GOLF_SWING: 0,
	RUN_OVER: 10,
	CRASH: 20,
	SPEECH_BUBBLE: 0,
	TETRIS: 0,
	PIECE_MOVE: 0,
	PIECE_PLACE: 0,
	TIMER: 0,
	WHEEL_STOP: 10
}

const VOLUME: float = -30.0
const MUTE_VOLUME: float = -1000.0

var is_muted: bool = false

onready var music_player := $MusicPlayer
onready var sfx_player := $SfxPlayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mute"):
		if not is_muted:
			music_player.volume_db = MUTE_VOLUME
			is_muted = true
		else:
			music_player.volume_db = VOLUME
			is_muted = false


func play_sfx(sfx: String) -> void:
	if not is_muted:
		sfx_player.volume_db = VOLUME + VOLUME_FIXER[sfx]
	else:
		sfx_player.volume_db = MUTE_VOLUME
	sfx_player.stream = SFX[sfx]
	sfx_player.play()


func play_music() -> void:
	music_player.volume_db = VOLUME if not is_muted else MUTE_VOLUME
	music_player.stream = MUSIC
	music_player.play()
