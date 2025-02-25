extends Node2D

## The game node, the beginning of all, the almighty entry point, the place,
## where your dreams come true! Adjust to your likings and may the code be with
## you.

enum Direction { Left = -1, Right = 1 }

@export var pause_ctl: Pause
@export var pause_menu: PauseMenu

@export_group("Prefabs")
@export var glass_prefab: PackedScene

@export_group("Internal")
@export var machines_container: Node2D
@export var glasses_container: Node2D
@export var score_label: Label
@export var orders_panel: OrdersPanel

var machines: Array[Machine]
var glasses: Array[Glass]
var score: int = 0

func _ready() -> void:
	# pause_menu.modal_open.connect(pause_ctl.drop_next)
	# pause_menu.resume_pressed.connect(pause_ctl.unpause)

	for c in machines_container.get_children():
		if c is not Machine:
			continue

		machines.push_back(c)

	spawn_glass()

	score_label.text = '%d' % score

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("game_fill_0"):
		fill_glass(0)
	if Input.is_action_just_pressed("game_fill_1"):
		fill_glass(1)
	if Input.is_action_just_pressed("game_fill_2"):
		fill_glass(2)
	if Input.is_action_just_pressed("game_fill_3"):
		fill_glass(3)
	if Input.is_action_just_pressed("game_move_left"):
		if can_move_left():
			move_glasses(Direction.Left)
	if Input.is_action_just_pressed("game_move_right"):
		move_glasses(Direction.Right)

func can_move_left() -> bool:
	var cannot := not machines[0].is_empty()

	for i in range(1, len(machines)):
		cannot = cannot and machines[i].is_empty()

	return not cannot

func move_glasses(direction: Direction) -> void:
	for m in machines:
		m.empty()

	for glass in glasses:
		glass.conv_pos += direction

		if glass.conv_pos < 0:
			glass.hide()
		elif glass.conv_pos >= len(machines):
			glasses.pop_back()
			var idx := orders_panel.get_glass_number(glass)
			if idx < 0:
				# TODO lose a life
				print("nope")
			else:
				# TODO send glass that way
				orders_panel.reroll_glass(idx)
				add_score(5)
			glass.queue_free()
		else:
			glass.show()
			put_under(glass.conv_pos, glass)

	if direction == Direction.Right and glasses[0].conv_pos > 0:
		spawn_glass()

func put_under(machine_index: int, glass: Glass) -> void:
	machines[machine_index].put_under(glass)

func fill_glass(idx: int) -> void:
	if idx < 0 or idx >= len(machines):
		printerr("Glass index must be in range of len(machines)")

	machines[idx].fill()

func spawn_glass() -> void:
	var new_glass: Glass = glass_prefab.instantiate()

	glasses.push_front(new_glass)
	put_under(0, new_glass)
	glasses_container.add_child(new_glass)

func add_score(amount: int) -> void:
	score += amount
	score_label.text = "%d" % score
