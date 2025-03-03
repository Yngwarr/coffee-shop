class_name Game
extends Node2D

## The game node, the beginning of all, the almighty entry point, the place,
## where your dreams come true! Adjust to your likings and may the code be with
## you.

const MoveTime := .5
const PourTime := .1

enum Direction { Left = -1, Right = 1 }

@export var pause_ctl: Pause
@export var pause_menu: PauseMenu

@export_group("Prefabs")
@export var glass_prefab: PackedScene

@export_group("Internal")
@export var machines_container: Node2D
@export var glasses_container: Node2D
@export var score_label: Label
@export var capacity_label: Label
@export var orders_panel: OrdersPanel
@export var bin_point: Marker2D
@export var glass_spawn_point: Marker2D
@export var cooldown: Timer
@export var table: Table
@export var healthbar: Healthbar
@export var game_over_screen: CanvasLayer
@export var final_score_label: Label
@export var anim: AnimationPlayer

var machines: Array[Machine]
var glasses: Array[Glass]
var score: int = 0
var is_on_cooldown := false
var capacity := 100
# var capacity := 10
var game_is_over := false

@onready var action_queue := ActionQueue.new()

func _ready() -> void:
	pause_menu.modal_open.connect(pause_ctl.drop_next)
	pause_menu.resume_pressed.connect(pause_ctl.unpause)
	capacity_label.text = "%d" % capacity

	RenderingServer.set_default_clear_color(Color("#c7f0d8"))
	cooldown.timeout.connect(end_cooldown)
	cooldown.wait_time = MoveTime

	for c in machines_container.get_children():
		if c is not Machine:
			continue

		machines.push_back(c)

	spawn_glass()

	score_label.text = str(score)

func _process(_delta: float) -> void:
	if game_is_over:
		return

	if Input.is_action_just_pressed("game_fill_0"):
		action_queue.fill_glass(0)
	if Input.is_action_just_pressed("game_fill_1"):
		action_queue.fill_glass(1)
	if Input.is_action_just_pressed("game_fill_2"):
		action_queue.fill_glass(2)
	if Input.is_action_just_pressed("game_fill_3"):
		action_queue.fill_glass(3)
	if Input.is_action_just_pressed("game_move_left"):
		action_queue.move_glasses(Direction.Left)
	if Input.is_action_just_pressed("game_move_right"):
		action_queue.move_glasses(Direction.Right)

	if is_on_cooldown:
		return

	perform_action(action_queue.pop_action())

func perform_action(action: Variant) -> void:
	if action == null:
		return

	match action.type:
		ActionQueue.Type.FillGlass:
			fill_glass(action.index)
			start_cooldown(PourTime)
		ActionQueue.Type.MoveGlasses:
			var success := move_glasses(action.direction)
			if success:
				add_capacity(-1)

				if capacity <= 0:
					game_over()
					return

				start_cooldown(MoveTime)

func can_move_left() -> bool:
	var cannot := not machines[0].is_empty()

	for i in range(1, len(machines)):
		cannot = cannot and machines[i].is_empty()

	return not cannot

func move_glasses(direction: Direction) -> bool:
	if direction == Direction.Left and not can_move_left():
		return false

	for m in machines:
		m.empty()

	GlobalSoundCtrl.play_effect(SoundCtrl.Effect.Roll if direction == Direction.Right else SoundCtrl.Effect.Roll)
	table.conv_start(direction)

	for glass in glasses:
		glass.conv_pos += direction

		if glass.conv_pos < 0:
			# hide the extra glass
			var dest := glass_spawn_point.global_position
			var t := get_tree().create_tween()
			t.tween_property(glass, "global_position", dest, MoveTime)
			t.tween_callback(glass.hide)
		elif glass.conv_pos >= len(machines):
			glasses.pop_back()
			var idx := orders_panel.get_glass_number(glass)
			if idx < 0:
				# healthbar.dec_health()
				var dest := bin_point.global_position
				var t := get_tree().create_tween()
				t.tween_property(glass, "global_position:x", glass.global_position.x + 12, .2)
				t.tween_property(glass, "global_position:y", dest.y, .3)\
					.set_ease(Tween.EASE_IN)\
					.set_trans(Tween.TRANS_QUINT)
				t.parallel().tween_property(glass, "global_position:x", dest.x, .3)\
					.set_ease(Tween.EASE_IN)\
					.set_trans(Tween.TRANS_SINE)
				t.parallel().tween_property(glass, "rotation_degrees", 180, .3)\
					.set_ease(Tween.EASE_IN)\
					.set_trans(Tween.TRANS_SINE)
				t.tween_callback(glass.queue_free)
			else:
				var dest := orders_panel.get_glass_position(idx)
				var t := get_tree().create_tween()
				t.tween_property(glass, "global_position", dest, MoveTime)\
					.set_ease(Tween.EASE_IN)\
					.set_trans(Tween.TRANS_SINE)
				t.tween_callback(orders_panel.reroll_glass.bind(idx))
				t.tween_callback(glass.queue_free)

				# TODO combos (consecutive serves)
				add_score(5)
		else:
			glass.show()
			put_under(glass.conv_pos, glass)

	if direction == Direction.Right and glasses[0].conv_pos > 0:
		spawn_glass()

	return true

func put_under(machine_index: int, glass: Glass) -> void:
	machines[machine_index].put_under(glass)

func fill_glass(idx: int) -> void:
	if idx < 0 or idx >= len(machines):
		printerr("Glass index must be in range of len(machines)")

	machines[idx].fill(PourTime)
	GlobalSoundCtrl.play_machine(idx)

func spawn_glass() -> void:
	var new_glass: Glass = glass_prefab.instantiate()
	new_glass.global_position = glass_spawn_point.global_position

	glasses.push_front(new_glass)
	put_under(0, new_glass)
	glasses_container.add_child(new_glass)

func add_score(amount: int) -> void:
	score += amount
	score_label.text = "%d" % score

func start_cooldown(time: float) -> void:
	is_on_cooldown = true
	cooldown.start(time)

func end_cooldown() -> void:
	is_on_cooldown = false
	table.conv_stop()

func add_capacity(value: int) -> void:
	capacity += value
	capacity_label.text = "%d" % capacity

func game_over() -> void:
	game_is_over = true
	final_score_label.text = str(score)
	game_over_screen.show()
	anim.play(&"game_over")
	GlobalSoundCtrl.play_effect(SoundCtrl.Effect.Over)
