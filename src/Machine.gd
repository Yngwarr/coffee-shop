@tool
class_name Machine
extends Sprite2D

@export var drink_type: int

@export_group("Internal")
@export var drink: Drink
@export var fill_point: Node2D

var fill_point_position: Vector2
var glass_under: Glass

func _ready() -> void:
	if not Engine.is_editor_hint():
		editor_update()
		fill_point_position = fill_point.global_position

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		editor_update()

func editor_update() -> void:
	if drink == null:
		printerr("drink cannot be null")
		return

	drink.set_type(drink_type)

func put_under(glass: Glass) -> void:
	glass.global_position = Vector2(fill_point_position.x, fill_point_position.y - glass.get_height())
	glass_under = glass
