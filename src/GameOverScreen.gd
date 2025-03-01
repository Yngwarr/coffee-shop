extends CanvasLayer

@export var first_to_focus: Control

func _ready() -> void:
	visibility_changed.connect(on_visibility_changed)

func on_visibility_changed() -> void:
	if visible:
		first_to_focus.grab_focus()
