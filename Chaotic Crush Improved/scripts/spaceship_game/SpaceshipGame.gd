extends Node

onready var score_label := $ScoreField/ScoreLabel
onready var game_screen := $GameScreen
onready var spaceship := $Spaceship


func _ready() -> void:
	set_level(Manager.game_levels[Manager.SPACESHIP_GAME])
	set_scoreboard_lives()


func set_level(level: int) -> void:
	match level:
		1:
			spaceship.lives = 3
			game_screen.number_of_asteroids = 5
			game_screen.scroll_speed = 300
		2:
			spaceship.lives = 3
			game_screen.number_of_asteroids = 4
			game_screen.scroll_speed = 400
		3:
			spaceship.lives = 3
			game_screen.number_of_asteroids = 4
			game_screen.scroll_speed = 500
		_:
			return
	game_screen.instantiate_asteroids()


func set_scoreboard_lives() -> void:
	var length: int = score_label.text.length()
	score_label.text = score_label.text.substr(0, length - 1) + str(spaceship.lives)


func _on_GameScreen_finished():
	score_label.text = """HIGH
							SCORE
							4525150
							SCORE
							4525240
							LIVES
							%d""" % spaceship.lives 


func _on_Spaceship_lost_life():
	set_scoreboard_lives()
