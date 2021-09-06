extends Control

onready var label_anim_player := $Label/AnimationPlayer
onready var heads_anim_player := $Heads/AnimationPlayer


func _ready() -> void:
	label_anim_player.play("blink")
	heads_anim_player.play("heads")
	AudioController.play_music()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		Manager.state = Manager.State.INTRO
		Manager.begin_transition(Manager.MAIN_SCENE, "Good Luck")
