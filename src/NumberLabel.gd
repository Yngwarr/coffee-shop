@tool
class_name NumberLabel
extends Node2D

@export_range(1, 4) var number: int

@export_group("Internal")
@export var view: Sprite2D

func _ready() -> void:
    if not Engine.is_editor_hint():
        update_number()

func _process(_delta: float) -> void:
    if Engine.is_editor_hint():
        update_number()

func update_number() -> void:
    view.frame = number - 1
