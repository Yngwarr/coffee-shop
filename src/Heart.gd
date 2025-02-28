@tool
class_name Heart
extends Node2D

@export var parts: Array[Sprite2D]

func get_width() -> float:
    if len(parts) == 0:
        printerr("View cannot be null")
        return 0

    var sum: float = parts.reduce(func(acc: float, p: Sprite2D) -> float: \
        return acc + p.get_rect().size.x, 0)

    # +1 is a workaround for our specific case of halves of pixels
    return sum + 1

func remove_half() -> void:
    if parts[0].visible:
        # TODO animate
        parts[0].visible = false
    else:
        # TODO animate
        parts[1].visible = false
