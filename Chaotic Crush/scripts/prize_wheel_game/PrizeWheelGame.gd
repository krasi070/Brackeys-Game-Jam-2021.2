extends Node

onready var timer := $Timer
onready var wheel := $Wheel/PrizeWheel


func _ready() -> void:
	set_level(Manager.game_levels[Manager.PRIZE_WHEEL_GAME])


func set_level(level: int) -> void:
	match level:
		1:
			wheel.rotation_speed = 250
		2:
			wheel.rotation_speed = 375
		3:
			wheel.rotation_speed = 500
		_:
			return


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		timer.stop()
