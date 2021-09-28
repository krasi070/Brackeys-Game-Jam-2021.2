extends Sprite

export var slider_speed: float = 600

const SLIDER_MIN: float = -80.0
const SLIDER_MAX: float = 720.0

var direction: int = 1
var stopped: bool = false

onready var slider := $Slider


func _ready() -> void:
	slider.position = Vector2(SLIDER_MIN, 0)


func _process(delta: float) -> void:
	if not stopped:
		if slider.position.x <= SLIDER_MIN:
			direction = 1
		elif slider.position.x >= SLIDER_MAX:
			direction = -1
		slider.position += Vector2(delta * slider_speed * direction, 0)
