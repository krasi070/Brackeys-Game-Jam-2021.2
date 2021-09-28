extends Node

onready var score_label := $ScoreField/ScoreLabel
onready var game_screen := $GameScreen


func _ready() -> void:
	set_level(Manager.game_levels[Manager.SPACESHIP_GAME])


func _on_Spaceship_crashed():
	var length: int = score_label.text.length()
	score_label.text = score_label.text.substr(0, length - 1) + "0"


func set_level(level: int) -> void:
	match level:
		1:
			game_screen.number_of_asteroids = 5
			game_screen.scroll_speed = 200
		2:
			game_screen.number_of_asteroids = 3
			game_screen.scroll_speed = 300
		3:
			game_screen.number_of_asteroids = 2
			game_screen.scroll_speed = 350
		_:
			return
	game_screen.instantiate_asteroids()


func _on_GameScreen_finished():
	score_label.text = """HIGH
							SCORE
							4525150
							SCORE
							4525240
							LIVES
							1"""
