class_name Table
extends Sprite2D

@export_group("Internal")
@export var conveyor: TextureRect

var moving := false
var direction: Game.Direction = Game.Direction.Right
var conv_offset := Vector2.ZERO
var conv_speed := Vector2(-4, 0)

func _physics_process(delta: float) -> void:
	if not moving:
		return

	conv_offset += conv_speed * direction * delta
	conveyor.material.set_shader_parameter(&"offset", conv_offset)

func conv_start(new_direction: Game.Direction) -> void:
	moving = true
	direction = new_direction

func conv_stop() -> void:
	moving = false
