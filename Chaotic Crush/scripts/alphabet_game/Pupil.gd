extends Node2D

onready var speech_bubble := $SpeechBubble
onready var default_sprite := $Default
onready var open_mouth_sprite := $OpenMouth


func _ready() -> void:
	default_sprite.show()
	open_mouth_sprite.hide()


func open_mouth() -> void:
	default_sprite.hide()
	open_mouth_sprite.show()
