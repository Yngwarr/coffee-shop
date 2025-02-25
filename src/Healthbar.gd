@tool
class_name Healthbar
extends Node2D

@export var heart_prefab: PackedScene

var max_health: int = 3
var health: int = 3

func _ready() -> void:
	populate_hearts()

func populate_hearts() -> void:
	if heart_prefab == null:
		printerr("Heart must not be null")
		return

	var count := get_child_count()

	for i in range(count, max_health):
		var new_heart: Heart = heart_prefab.instantiate()
		new_heart.position.x = (new_heart.get_width() + 1) * i
		add_child(new_heart)
