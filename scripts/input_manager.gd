extends Node2D
class_name InputManager

signal draw_card
signal toggle_card_select
signal toggle_deck_expand
signal start_drag
signal end_drag

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var node_found = Global.raycast()
				if node_found is Deck:
					emit_signal("draw_card", node_found)
				if node_found is Card:
					emit_signal("toggle_card_select", node_found)
					emit_signal("start_drag", node_found)
			else:
				emit_signal("end_drag")
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				var node_found = Global.raycast()
				if node_found is Deck:
					print("inputmanager attempting to expand ", node_found)
					emit_signal("toggle_deck_expand", node_found)

""" This is somewhat werid since we have decided to use a different structure 
for our decks- which means that detection for different masking layer is unneeded
I dont think that is too good
Also in the future I need to decide whihc functions should go to which scripts.
This is literally factorio where now every document is somewhat citing each other
"""
