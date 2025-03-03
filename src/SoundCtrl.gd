class_name SoundCtrl
extends AudioStreamPlayer

enum Effect {
    Menu,
    Start,
    Over,
    Roll,
    RollBack
}

@export var menu: AudioStream
@export var start: AudioStream
@export var over: AudioStream

@export var roll: Array[AudioStream]
@export var roll_back: Array[AudioStream]

@export var machine: Array[AudioStream]

func play_effect(effect: Effect) -> void:
    stop()

    match effect:
        Effect.Menu:
            stream = menu
        Effect.Start:
            stream = start
        Effect.Over:
            stream = over
        Effect.Roll:
            stream = roll.pick_random()
        Effect.RollBack:
            stream = roll_back.pick_random()

    play()

func play_machine(idx: int) -> void:
    stop()
    stream = machine[idx]
    play()
