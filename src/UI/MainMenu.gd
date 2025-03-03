extends Node2D

## Main menu scene's main script.

## The node that will grab focus on ready. Usually, the top button on the
## screen.
@export var first_to_focus: Control
@export_file("*.tscn") var game_scene_name: String

func _ready() -> void:
	ConfigCtl.load_config()
	first_to_focus.grab_focus()
	RenderingServer.set_default_clear_color(Color("#c7f0d8"))
	GlobalSoundCtrl.play_effect(SoundCtrl.Effect.Menu)

func start_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(game_scene_name)

func play_start_effect() -> void:
	GlobalSoundCtrl.play_effect(SoundCtrl.Effect.Start)
