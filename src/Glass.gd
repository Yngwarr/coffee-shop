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

func add(drink_type: int, time: float) -> bool:
    for drink in drinks:
        if drink.visible:
            continue

        drink.set_type(drink_type)
        drink.pour(time)
        return true

    return false

func get_height() -> float:
    return view.get_rect().size.y

func randomize() -> void:
    for d in drinks:
        d.randomize_type()
        d.show()

func eq(other: Glass) -> bool:
    var result := true

    if len(other.drinks) != len(drinks):
        return false

    for i in range(len(drinks)):
        result = result and other.drinks[i].eq(drinks[i])

    return result
