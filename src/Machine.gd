@tool
class_name Machine
extends Sprite2D

@export var drink_type: int

@export_group("Internal")
@export var drink: Drink
@export var fill_point: Node2D
@export var anim: AnimationPlayer

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
	var dest := Vector2(fill_point_position.x, fill_point_position.y)
	var t := get_tree().create_tween()
	t.tween_property(glass, "global_position", dest, .5)
	glass_under = glass

func empty() -> void:
	glass_under = null

func is_empty() -> bool:
	return glass_under == null

func fill(time: float) -> void:
	if glass_under == null:
		anim.play(&"pour")
		return

	if glass_under.add(drink_type, time):
		anim.play(&"pour")
