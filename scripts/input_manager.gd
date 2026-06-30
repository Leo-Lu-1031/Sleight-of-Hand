extends Node2D
class_name InputManager

signal play_cards
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
					emit_signal("draw_card", node_found.character_id)
				if node_found is Card:
					emit_signal("start_drag", node_found)
					if node_found.is_selectible:
						emit_signal("toggle_card_select", node_found)
				if node_found is PlayCardButton:
					emit_signal("play_cards")
			else:
				emit_signal("end_drag")
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				var node_found = Global.raycast()
				if node_found is Deck:
					emit_signal("toggle_deck_expand", node_found)
