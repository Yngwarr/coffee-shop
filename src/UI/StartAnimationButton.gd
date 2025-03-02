class_name StartAnimationButton
extends Button

@export var anim: AnimationPlayer
@export var animation_name: StringName

func _ready() -> void:
    pressed.connect(on_pressed)

func on_pressed() -> void:
    anim.play(animation_name)
