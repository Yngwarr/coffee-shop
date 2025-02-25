@tool
class_name Heart
extends Node2D

@export var view: Sprite2D

func get_width() -> float:
    if view == null:
        printerr("View cannot be null")
        return 0

    return view.get_rect().size.x
