class_name ActionQueue
extends Object

enum Type { FillGlass, MoveGlasses }

var queue: Array[Dictionary]

func _init() -> void:
    queue = []

func can_add_action() -> bool:
    return len(queue) < 2

func fill_glass(idx: int) -> void:
    if not can_add_action():
        return

    queue.push_back({ type = Type.FillGlass, index = idx })

func move_glasses(direction: Game.Direction) -> void:
    if not can_add_action():
        return

    queue.push_back({ type = Type.MoveGlasses, direction = direction })

func pop_action() -> Variant:
    return queue.pop_front()
