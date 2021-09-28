extends Control

export(int, 5, 59) var time = 5 setget set_time
export var controls_text: String

var timer: float
var stopped: bool = false
var played_anim: bool = false

onready var time_label := $ClockTexture/TimeLabel
onready var disabled_label := $ClockTexture/DisabledLabel
onready var controls_label := $ControlsLabel
onready var anim_player := $AnimationPlayer


func _ready() -> void:
	controls_label.text = controls_text
	time_label.show()
	disabled_label.hide()
	timer = time
	_set_label_time()


func stop() -> void:
	if Manager.has_started:
		stopped = true
		time_label.hide()
		disabled_label.show()


func _process(delta: float) -> void:
	if not stopped and Manager.has_started:
		timer -= delta
		if timer < 0:
			time_label.text = "00:00"
			disabled_label.text = "00:00"
			if not played_anim:
				AudioController.play_sfx(AudioController.TIMER)
				played_anim = true
				anim_player.play("time_over")
		else:
			_set_label_time()


func set_time(new_time: int) -> void:
	time = new_time
	timer = time
	_set_label_time()


func _set_label_time() -> void:
	if time_label != null and disabled_label != null:
		time_label.text = "00:%02d" % int(ceil(timer))
		disabled_label.text = "00:%02d" % int(ceil(timer))


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	Manager.timeout()
