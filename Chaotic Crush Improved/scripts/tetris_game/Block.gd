extends Node2D

const START_X: int = 358
const START_Y: int = 450
const BLOCK_DISTANCE: int = 20

const MIN_X: int = 0
const MAX_X: int = 9
const MIN_Y: int = 0
const MAX_VISIBLE_Y: int = 15
const MAX_Y: int = 19

var grid_pos: Vector2 setget set_grid_pos
var relative_pos: Vector2

onready var sprite := $Sprite
onready var anim_player := $AnimationPlayer


func _ready():
	relative_pos = Vector2(position.x / BLOCK_DISTANCE, position.y / BLOCK_DISTANCE)


func set_pos(pos: Vector2) -> void:
	set_grid_pos(pos + relative_pos)


func set_grid_pos(new_pos: Vector2) -> void:
	if not is_valid_position(new_pos):
		return
	grid_pos = new_pos
	var x: int = START_X + BLOCK_DISTANCE * grid_pos.x
	var y: int = START_Y - BLOCK_DISTANCE * grid_pos.y
	global_position = Vector2(x, y)
	if grid_pos.y > MAX_VISIBLE_Y:
		sprite.hide()
	else:
		sprite.show()


# If element in grid is true, it means it's not empty.
# The return value states whether the movemet was actually made.
func can_move(direction: Vector2, grid: Array) -> bool:
	var new_pos: Vector2 = grid_pos + direction
	if not is_valid_position(new_pos):
		return false
	if grid[new_pos.y][new_pos.x]:
		return false
	return true


func is_valid_position(pos: Vector2) -> bool:
	if pos.x < MIN_X or pos.x > MAX_X or pos.y < MIN_Y or pos.y > MAX_Y:
		return false
	return true


func destroy() -> void:
	anim_player.play("destroy")
	yield(anim_player, "animation_finished")
	queue_free()
