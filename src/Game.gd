extends Node2D

## The game node, the beginning of all, the almighty entry point, the place,
## where your dreams come true! Adjust to your likings and may the code be with
## you.

@export var pause_ctl: Pause
@export var pause_menu: PauseMenu

@export_group("Internal")
@export var glass: Glass
@export var machines_container: Node2D

var machines: Array[Machine]

func _ready() -> void:
	# pause_menu.modal_open.connect(pause_ctl.drop_next)
	# pause_menu.resume_pressed.connect(pause_ctl.unpause)

	for c in machines_container.get_children():
		if c is not Machine:
			continue

		machines.push_back(c)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("game_fill_0"):
		move_glass(0)
	if Input.is_action_pressed("game_fill_1"):
		move_glass(1)
	if Input.is_action_pressed("game_fill_2"):
		move_glass(2)
	if Input.is_action_pressed("game_fill_3"):
		move_glass(3)

func move_glass(idx: int) -> void:
	machines[idx].put_under(glass)
