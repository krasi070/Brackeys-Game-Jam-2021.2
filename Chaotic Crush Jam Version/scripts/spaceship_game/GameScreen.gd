extends Area2D

signal finished

var scroll_speed: float
var number_of_asteroids: int

var rng = RandomNumberGenerator.new()

var max_y: float
var scroll: bool = true

# Should be between:
# x: 425 - 540
# y: -950 - 100
var spawn_points: Array = [
	Vector2(495, -350),
	Vector2(530, -200),
	Vector2(475, -50),
	Vector2(437, 100),
	Vector2(455, -500),
	Vector2(500, -650),
	Vector2(445, -800),
	Vector2(540, -950),
]

onready var background = $Background
onready var asteroids = [
	preload("res://resources/scenes/spaceship_game/objects/Asteroid1.tscn"),
	preload("res://resources/scenes/spaceship_game/objects/Asteroid2.tscn"),
	preload("res://resources/scenes/spaceship_game/objects/Asteroid3.tscn"),
	preload("res://resources/scenes/spaceship_game/objects/Asteroid4.tscn"),
]


func _ready() -> void:
	rng.randomize()
	max_y = position.y + background.texture.get_height() / 2


func _process(delta: float) -> void:
	if Manager.has_started and scroll and position.y < max_y:
		var scroll_amount: float = scroll_speed * delta
		position += Vector2(0, scroll_amount)


func reset() -> void:
	for child in get_children():
		if child.is_in_group("obstacle"):
			child.queue_free()
	instantiate_asteroids()


func instantiate_asteroids() -> void:
	var copy_arr: Array = spawn_points.duplicate(true)
	var end: int = min(number_of_asteroids, copy_arr.size())
	for i in end:
		var rand_spawn_point_index: int = rng.randi_range(0, copy_arr.size() - 1)
		var rand_asteroid_index: int = rng.randi_range(0, asteroids.size() - 1)
		var new_asteroid: Area2D = asteroids[rand_asteroid_index].instance()
		add_child(new_asteroid)
		new_asteroid.global_position = copy_arr[rand_spawn_point_index]
		new_asteroid.z_index = 0
		copy_arr.remove(rand_spawn_point_index)


func _on_Background_area_exited(area):
	emit_signal("finished")
	Manager.fail_chaos_point()


func _on_Spaceship_crashed():
	scroll = false
