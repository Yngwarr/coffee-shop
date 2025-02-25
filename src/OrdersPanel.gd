@tool
class_name OrdersPanel
extends Node2D

@export_group("Internal")
@export var glass_prefab: PackedScene
@export var glass_container: Node2D
@export var glass_positions: Array[Node2D]

func _ready() -> void:
    populate_orders()

func populate_orders() -> void:
    if glass_prefab == null:
        printerr("Glass prefab must not be null")
        return

    if glass_container == null:
        printerr("Glass container must not be null")
        return

    if glass_positions == null:
        printerr("Glass positions array must not be null")
        return

    var count := glass_container.get_child_count()

    for i in range(count, len(glass_positions)):
        var new_glass: Glass = glass_prefab.instantiate()
        new_glass.position = glass_positions[i].position
        add_child(new_glass)
        new_glass.randomize()
