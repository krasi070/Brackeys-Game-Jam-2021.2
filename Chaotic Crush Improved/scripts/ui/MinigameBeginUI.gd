extends Control

export var tick_time: float

var info_text: String setget set_info_label
var transition_finished: bool = false
var timer: float = 0

onready var tip_label := $InfoPanel/GameTipLabel
onready var start_counter := $InfoPanel/CounterToStart
onready var go_label := $InfoPanel/GoLabel
onready var anim_player := $AnimationPlayer


func _ready() -> void:
	tip_label.show()
	start_counter.text = "3"
	start_counter.show()
	go_label.hide()


func _process(delta: float) -> void:
	if transition_finished:
		timer += delta
		if timer >= tick_time:
			_change_timer()


func _change_timer() -> void:
	var current_num := int(start_counter.text)
	if current_num > 0:
		start_counter.text = var2str(current_num - 1)
		
	if current_num == 1:
		tip_label.hide()
		start_counter.hide()
		go_label.show()
	elif current_num < 1:
		finish_timer()
	timer = 0


func finish_timer() -> void:
	Manager.has_started = true
	anim_player.play("shrink")
	yield(anim_player, "animation_finished")
	queue_free()


func set_info_label(text: String) -> void:
	info_text = text
	tip_label.text = text
