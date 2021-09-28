extends Node2D

const BLOCK_DISTANCE: int = 20

onready var blocks: Array = [
	$Block1,
	$Block2,
	$Block3,
	$Block4,
]


func _ready() -> void:
	rotate(deg2rad(180))


func set_pos(grid_position: Vector2) -> void:
	for block in blocks:
		block.set_pos(grid_position)


func move(direction: Vector2, grid: Array) -> bool:
	for block in blocks:
		if not block.can_move(direction, grid):
			return false
	for block in blocks:
		block.grid_pos += direction
	return true


func drop(grid: Array) -> bool:
	# Which is -1 for y in Godot
	return move(Vector2.UP, grid)
