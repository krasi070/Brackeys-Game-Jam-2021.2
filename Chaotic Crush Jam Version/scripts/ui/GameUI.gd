extends Control

export var info_text: String

onready var info_ui := $MinigameBeginUI


func _ready() -> void:
	show()
	info_ui.info_text = info_text


func _on_Transition_finished_transition():
	info_ui.transition_finished = true
