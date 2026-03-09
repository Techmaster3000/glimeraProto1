class_name DialMan extends Node

var character : NPC
var inRange : bool = false
	
func _process(delta: float) -> void:
	if inRange and Input.is_action_just_pressed("ui_interact"):
		showDialogue()
		
		
func _ready() -> void:
	Dialogue.interactRange.connect(setNPC)
	
func setNPC(npc : NPC, range : bool):
	character = npc
	inRange = range

func showDialogue():
	pass
