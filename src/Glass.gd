class_name Glass
extends Node2D

@export_group("Internal")
@export var drinks: Array[Drink]
@export var view: Sprite2D

func _ready() -> void:
    for drink in drinks:
        drink.hide()

func add(drink_type: int) -> void:
    for drink in drinks:
        if drink.visible:
            continue

        drink.set_type(drink_type)
        drink.show()

func get_height() -> float:
    return view.get_rect().size.y
