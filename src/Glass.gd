@tool
class_name Glass
extends Node2D

@export_group("Internal")
@export var drinks: Array[Drink]
@export var view: Sprite2D

var conv_pos: int = 0

func _ready() -> void:
    if not Engine.is_editor_hint():
        for drink in drinks:
            drink.hide()

func add(drink_type: int) -> void:
    for drink in drinks:
        if drink.visible:
            continue

        drink.set_type(drink_type)
        drink.show()
        break

func get_height() -> float:
    return view.get_rect().size.y

func randomize() -> void:
    for d in drinks:
        d.randomize_type()
        d.show()
