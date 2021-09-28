extends Node

var selected_wheel: Area2D

onready var timer := $Timer
onready var wheels := [
	$Wheel/PrizeWheelOne,
	$Wheel/PrizeWheelTwo
]


func _ready() -> void:
	set_level(Manager.game_levels[Manager.PRIZE_WHEEL_GAME])


func set_level(level: int) -> void:
	match level:
		1:
			select_wheel(0)
			selected_wheel.rotation_speed = 300
		2:
			select_wheel(1)
			selected_wheel.rotation_speed = 300
		3:
			select_wheel(1)
			selected_wheel.rotation_speed = 400
		_:
			return


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		timer.stop()


func select_wheel(index: int) -> void:
	selected_wheel = wheels[index]
	for wheel in wheels:
		if wheel != selected_wheel:
			wheel.queue_free()
