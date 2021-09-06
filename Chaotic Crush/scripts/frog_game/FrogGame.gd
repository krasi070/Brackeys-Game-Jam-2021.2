extends Node

const MIN_CARS: int = 1
const MAX_CARS: int = 13

const MIN_CAR_SPEED_1: float = 75.0
const MAX_CAR_SPEED_1: float = 125.0

const MIN_CAR_SPEED_2: float = 125.0
const MAX_CAR_SPEED_2: float = 200.0

const MIN_CAR_SPEED_3: float = 200.0
const MAX_CAR_SPEED_3: float = 300.0

var rng := RandomNumberGenerator.new()
var car_scene: PackedScene = preload("res://resources/scenes/frog_game/objects/Car.tscn")

var number_of_cars: int
var min_car_speed: float
var max_car_speed: float

onready var car_container := $CarContainer
onready var spawn_points := [
	$CarSpawningPoints/SpawnPointA,
	$CarSpawningPoints/SpawnPointB,
	$CarSpawningPoints/SpawnPointC,
	$CarSpawningPoints/SpawnPointD,
	$CarSpawningPoints/SpawnPointE,
]


func _ready() -> void:
	rng.randomize()
	set_level(Manager.game_levels[Manager.FROG_GAME])
	var points: Array = _get_random_spawn_points(number_of_cars)
	for point in points:
		var rand_speed := rng.randi_range(min_car_speed, max_car_speed)
		_instance_car(point.position, point.direction, rand_speed)


func set_level(level: int) -> void:
	match level:
		1:
			number_of_cars = MAX_CARS
			min_car_speed = MIN_CAR_SPEED_1
			max_car_speed = MAX_CAR_SPEED_1
		2:
			number_of_cars = 2
			min_car_speed = MIN_CAR_SPEED_2
			max_car_speed = MAX_CAR_SPEED_2
		3:
			number_of_cars = MIN_CARS
			min_car_speed = MIN_CAR_SPEED_3
			max_car_speed = MAX_CAR_SPEED_3
		_:
			return


func _get_random_spawn_points(amount: int) -> Array:
	amount = clamp(amount, MIN_CARS, MAX_CARS)
	var a_or_b: int = rng.randi_range(0, 1)
	var d_or_e: int = rng.randi_range(3, 4)
	var candidates: Array = [
		spawn_points[a_or_b], 
		spawn_points[2], 
		spawn_points[d_or_e]]
	var to_return: Array = []
	var end: int = min(amount, candidates.size())
	for i in end:
		var rand_index: int = rng.randi_range(0, candidates.size() - 1)
		to_return.append(candidates[rand_index])
		candidates.remove(rand_index)
	return to_return


func _instance_car(pos: Vector2, direction: int, speed: float) -> void:
	var instance := car_scene.instance() as Area2D
	instance.position = pos
	instance.direction = direction
	instance.speed = speed
	car_container.add_child(instance)
