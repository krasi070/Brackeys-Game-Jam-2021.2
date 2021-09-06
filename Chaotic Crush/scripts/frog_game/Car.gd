extends Area2D

export var speed: float = 200

var direction: int = 1

onready var sprite := $Sprite


func _ready() -> void:
	if direction > 0:
		sprite.set_flip_h(true)


func _process(delta: float) -> void:
	if Manager.has_started:
		position += Vector2(speed * delta * direction, 0)
