extends TextureRect

signal finished_transition

var transition_in_played: bool = false

onready var anim_player := $AnimationPlayer
onready var label := $Label


func _ready() -> void:
	Manager.connect("began_transition", self, "transition_to")
	if Manager.first_scene_played:
		transition_in_played = true
		label.text = Manager.transition_text
		show()
		anim_player.play_backwards("fall")
		yield(anim_player, "animation_finished")
		Manager.end_transition()
		set_process_input(true)
	else:
		Manager.first_scene_played = true
		rect_position = Vector2(0, -920)
	visible = true


func transition_to() -> void:
	transition_in_played = false
	label.text = Manager.transition_text
	anim_player.play("fall")
	set_process_input(false)
	yield(anim_player, "animation_finished")
	get_tree().change_scene(Manager.transition_to_scene)


func set_text(text: String) -> void:
	label.text = text


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if transition_in_played:
		emit_signal("finished_transition")
