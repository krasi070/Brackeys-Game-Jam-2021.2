extends Control

const VISIBLE_MIN_VALUE: int = 4
const VISIBLE_MAX_VALUE: int = 45

onready var progress_bar := $ChaosProgress
onready var minus_one := $MinusOne
onready var plus_amount := $PlusAmount


func set_value(new_value: int, order_or_chaos: String) -> void:
	new_value += VISIBLE_MIN_VALUE
	progress_bar.value = clamp(new_value, VISIBLE_MIN_VALUE, VISIBLE_MAX_VALUE)
	
	check_for_game_end()
	
	match order_or_chaos:
		"order", "time":
			plus_amount.hide()
			minus_one.show()
		"chaos":
			minus_one.hide()
			plus_amount.text = "+%d" % Manager.given_chaos_points
			plus_amount.show()
		_:
			minus_one.hide()
			plus_amount.hide()


func check_for_game_end() -> void:
	if progress_bar.value == VISIBLE_MAX_VALUE:
		Manager.go_to_chaos_end()
	elif progress_bar.value == VISIBLE_MIN_VALUE:
		Manager.go_to_order_end()
