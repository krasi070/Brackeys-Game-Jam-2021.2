extends Node

const SPEECH_BUBBLE_TIMER: float = 0.5

const normal_variants: Array = [
	["A", "B", "C", "D"],
	["X", "Y", "Z", "A"],
	["T", "U", "V", "W"],
	["P", "Q", "R", "S"],
]

const opposite_variants: Array = [
	["G", "F", "E", "D"],
	["D", "C", "B", "A"],
	["Z", "Y", "X", "W"],
	["V", "U", "T", "S"],
]

var letter_order: Array
var speech_bubbles_hidden: bool = true
var player_bubble_hidden: bool = true

var rng = RandomNumberGenerator.new()

onready var timer := $Timer
onready var player_pupil := $PlayerPupil
onready var pupils := [
	$Pupil1,
	$Pupil2,
	$Pupil3,
]


func _ready() -> void:
	rng.randomize()
	_hide_speech_bubbles()
	set_level(Manager.game_levels[Manager.ALPHABET_GAME])
	for i in pupils.size():
		pupils[i].speech_bubble.letter_label.text = letter_order[i]


func _process(delta: float) -> void:
	if Manager.has_started and speech_bubbles_hidden:
		_show_speech_bubbles()
		speech_bubbles_hidden = false


func _input(event: InputEvent) -> void:
	if (Manager.has_started and 
		player_bubble_hidden and 
		pupils[pupils.size() - 1].speech_bubble.shown):
		if event.is_action_pressed("a"):
			_validate_answer("A")
		elif event.is_action_pressed("s"):
			_validate_answer("S")
		elif event.is_action_pressed("d"):
			_validate_answer("D")
		elif event.is_action_pressed("w"):
			_validate_answer("W")


func set_level(level: int) -> void:
	match level:
		1:
			letter_order = normal_variants[0]
		2:
			letter_order = _get_random_variant()
		3:
			letter_order = _get_random_variant(true)
		_:
			return


func _get_random_variant(opposite: bool = false) -> Array:
	if opposite:
		var rand_index: int = rng.randi_range(0, opposite_variants.size() - 1)
		return opposite_variants[rand_index]
	var rand_index: int = rng.randi_range(0, normal_variants.size() - 1)
	return normal_variants[rand_index]


func _validate_answer(answer: String) -> void:
	timer.stop()
	player_pupil.speech_bubble.letter_label.text = answer
	if letter_order[letter_order.size() - 1] == answer:
		var end_timer := get_tree().create_timer(0.5)
		end_timer.connect("timeout", Manager, "fail_chaos_point")
	else:
		var end_timer := get_tree().create_timer(0.5)
		end_timer.connect("timeout", Manager, "get_chaos_point")
	_say_letter(player_pupil)
	player_bubble_hidden = false


# Including player speech bubble
func _hide_speech_bubbles() -> void:
	player_pupil.speech_bubble.scale = Vector2.ZERO
	for i in pupils.size():
		pupils[i].speech_bubble.scale = Vector2.ZERO


# Excluding player speech bubble
func _show_speech_bubbles() -> void:
	_say_letter(pupils[0])
	for i in range(1, pupils.size()):
		var timer := get_tree().create_timer(SPEECH_BUBBLE_TIMER * i)
		timer.connect("timeout", self, "_say_letter", [pupils[i]])


func _say_letter(pupil) -> void:
	AudioController.play_sfx(AudioController.SPEECH_BUBBLE)
	pupil.open_mouth()
	pupil.speech_bubble.anim_player.play("appear")
	pupil.speech_bubble.shown = true
