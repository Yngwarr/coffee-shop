extends Node2D

## Main menu scene's main script.

## The node that will grab focus on ready. Usually, the top button on the
## screen.
@export var first_to_focus: Control

func _ready() -> void:
	ConfigCtl.load_config()
	first_to_focus.grab_focus()
	RenderingServer.set_default_clear_color(Color("#c7f0d8"))
