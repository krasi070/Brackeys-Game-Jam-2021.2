extends Area2D

onready var sprite := $Sprite
onready var anim_sprite := $AnimatedSprite


func _ready() -> void:
	sprite.show()
	anim_sprite.hide() 


func destroy() -> void:
	sprite.hide()
	anim_sprite.show()
	anim_sprite.play("destroy")
	yield(anim_sprite, "animation_finished")
	queue_free()
