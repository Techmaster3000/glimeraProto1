extends Control

signal item_selected(item)

var player
var items = []
var selected_item = null
var inventory = []

@onready var slots = [
	$Panel/GridContainer/Slot1,
	$Panel/GridContainer/Slot2,
	$Panel/GridContainer/Slot3,
	$Panel/GridContainer/Slot4,
	$Panel/GridContainer/Slot5,
	$Panel/GridContainer/Slot6
]

func _ready():
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

	items = [
		preload("res://resources/violin.tres"),
		preload("res://resources/woodstomp.tres")
	]

	inventory = [
		items[0],
		items[1],
		null,
		null,
		null,
		null
	]

	visible = false

func _process(delta):
	update_slots()

func _input(event):
	if event.is_action_pressed("open_inventory"):
		visible = !visible
		get_tree().paused = visible

func update_slots():
	for i in range(slots.size()):
		var slot = slots[i]
		if slot == null:
			continue

		# STYLE (background + border)
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.15, 0.15, 0.15)

		style.set_border_width(SIDE_LEFT, 2)
		style.set_border_width(SIDE_TOP, 2)
		style.set_border_width(SIDE_RIGHT, 2)
		style.set_border_width(SIDE_BOTTOM, 2)

		style.border_color = Color(1, 1, 1)

		slot.add_theme_stylebox_override("normal", style)

		# ICON (scaled correctly)
		if inventory[i] != null and inventory[i].icon != null:
			slot.icon = inventory[i].icon
			slot.expand_icon = true
		else:
			slot.icon = null

func _on_slot_pressed(index):
	if inventory[index] == null:
		return

	selected_item = inventory[index]
	emit_signal("item_selected", selected_item)

func close_inventory():
	visible = false
	get_tree().paused = false

func _on_slot_1_pressed():
	_on_slot_pressed(0)

func _on_slot_2_pressed():
	_on_slot_pressed(1)

func _on_slot_3_pressed():
	_on_slot_pressed(2)

func _on_slot_4_pressed():
	_on_slot_pressed(3)

func _on_slot_5_pressed():
	_on_slot_pressed(4)

func _on_slot_6_pressed():
	_on_slot_pressed(5)
