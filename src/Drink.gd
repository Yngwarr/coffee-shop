@tool
class_name Drink
extends Node2D

@export var drink_type: int
@export_range(1, 100, 1) var width: int = 2
@export_range(1, 100, 1) var height: int = 2

@export_group("Internal")
@export var view: TextureRect
@export var drink_textures: Array[Texture2D]

func _ready() -> void:
    if not Engine.is_editor_hint():
        resize_view()
        update_texture()

func _process(_delta: float) -> void:
    if Engine.is_editor_hint():
        resize_view()
        update_texture()

func set_type(value: int) -> void:
    drink_type = value

    if drink_type >= len(drink_textures):
        drink_type = len(drink_textures) - 1
        printerr("Drink type should be in range of len(drink_textures)")

    if drink_type < 0:
        drink_type = 0
        printerr("Drink type should be in range of len(drink_textures)")

    view.texture = drink_textures[drink_type]

func randomize_type() -> void:
    set_type(randi() % len(drink_textures))

func resize_view() -> void:
    if view == null or width < 1 or height < 1:
        return

    view.size = Vector2(width, height)

func update_texture() -> void:
    set_type(drink_type)
