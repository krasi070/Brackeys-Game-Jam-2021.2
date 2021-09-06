extends Node

var text: Array

onready var girl := $Girl
onready var text_box := $UI/TextBox/TextBox
onready var chaos_meter := $UI/ChaosMeter


func _ready() -> void:
	chaos_meter.set_value(Manager.chaos_points, Manager.last_order_or_chaos)
	text = Manager.get_reply()
	if text.size() > 0 and text[0] is Array:
		var msg_args: Array = text.pop_front()
		text_box.text = msg_args[0]
		set_pose(msg_args[1])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action") and not Manager.is_transitioning():
		if (Manager.state == Manager.State.CHAOS_END and
			text.size() == 0):
			Manager.show_chaos_end()
		elif (Manager.state == Manager.State.ORDER_END and
			text.size() == 0):
			Manager.show_order_end()
		elif text.size() > 0:
			var msg_args: Array = text.pop_front()
			text_box.text = msg_args[0]
			set_pose(msg_args[1])
		else:
			Manager.next_game()


func set_pose(pose: String) -> void:
	girl.show_pose(pose)
