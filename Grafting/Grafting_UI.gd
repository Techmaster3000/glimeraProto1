extends Control

@export var armIcons : Array[Texture2D]
@export var legIcons : Array[Texture2D]
@export var armGraftNames : Array[String]
@export var armGraftDescs : Array[String]
@export var legGraftNames : Array[String]
@export var legGraftDescs : Array[String]

var selected_slot : String = ""
var is_open : bool = false

@onready var graft_grid = $GraftGrid
@onready var info_card = $InfoCard
@onready var info_name = $InfoCard/InfoName
@onready var info_desc = $InfoCard/InfoDesc
@onready var info_icon = $InfoCard/InfoIcon
@onready var arm_slot = $RightArmSlot
@onready var leg_slot = $LeftLegSlot

func _ready() -> void:
	set_process_input(true)
	#visible = false
	info_card.visible = false
	graft_grid.visible = false
	$LeftArmSlot.disabled = true
	$RightLegSlot.disabled = true

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			is_open = !is_open
			visible = is_open

func _on_right_arm_slot_pressed() -> void:
	selected_slot = "arm"
	_populate_grid(armIcons, armGraftNames)
	graft_grid.visible = true
	info_card.visible = false
	SFXPlayer.play_sfx(load("res://Sounds/SFX/SE_STATIC_00000.wav"))

func _on_left_leg_slot_pressed() -> void:
	selected_slot = "leg"
	_populate_grid(legIcons, legGraftNames)
	graft_grid.visible = true
	info_card.visible = false
	SFXPlayer.play_sfx(load("res://Sounds/SFX/SE_STATIC_00000.wav"))

func _populate_grid(icons: Array[Texture2D], names: Array[String]) -> void:
	for child in graft_grid.get_children():
		child.queue_free()
	for i in icons.size():
		var btn = TextureButton.new()
		btn.texture_normal = icons[i]
		btn.ignore_texture_size = true
		btn.custom_minimum_size = Vector2(200, 200)
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED

		var is_locked = false
		if selected_slot == "arm":
			if i == 1 and !GraftGlobals.sawObtained: is_locked = true
			if i == 2 and !GraftGlobals.hoseObtained: is_locked = true
		elif selected_slot == "leg":
			if i == 1 and !GraftGlobals.sledgehammerObtained: is_locked = true
		btn.disabled = is_locked
		btn.modulate = Color(0.4, 0.4, 0.4) if is_locked else Color.WHITE
		var idx = i
		btn.pressed.connect(func(): _on_graft_selected(idx))
		btn.mouse_entered.connect(func(): _on_graft_hovered(idx))
		graft_grid.add_child(btn)

func _on_graft_selected(index: int) -> void:
	if selected_slot == "arm":
		GraftGlobals.right_arm_graft_changed.emit(index)
		GraftGlobals.right_arm_graft_index = index
		arm_slot.icon = armIcons[index]
		arm_slot.add_theme_constant_override("icon_max_width", 150)
	elif selected_slot == "leg":
		GraftGlobals.left_leg_graft_changed.emit(index)
		GraftGlobals.left_leg_graft_index = index
		leg_slot.icon = legIcons[index]
		leg_slot.add_theme_constant_override("icon_max_width", 150)
	graft_grid.visible = false
	info_card.visible = false
	SFXPlayer.play_sfx(GraftGlobals.graftSFX)

func _on_graft_hovered(index: int) -> void:
	info_card.visible = true
	if selected_slot == "arm":
		info_name.text = armGraftNames[index] if index < armGraftNames.size() else ""
		info_desc.text = armGraftDescs[index] if index < armGraftDescs.size() else ""
		info_icon.texture = armIcons[index]
	elif selected_slot == "leg":
		info_name.text = legGraftNames[index] if index < legGraftNames.size() else ""
		info_desc.text = legGraftDescs[index] if index < legGraftDescs.size() else ""
		info_icon.texture = legIcons[index]
